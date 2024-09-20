import 'package:flutter/material.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsView extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsView({required this.transactions, super.key});

  @override
  Widget build(BuildContext context) {
    final _simpleCurrencyNumberFormat = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );

    final _transactionsBuilder = ListView.builder(
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return const Divider();
        }

        final int i = index ~/ 2;
        if (i >= this.transactions.length) {
          return null;
        }

        final _transaction = this.transactions[i];
        final _simpleCurrencyValue =
            _simpleCurrencyNumberFormat.format(_transaction.amount);
        return Dismissible(
          background: Container(color: Colors.red),
          key: Key(_transaction.description + _transaction.fullAccountName),
          onDismissed: (direction) async {
            transactions.remove(_transaction);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Transaction removed.")),
            );
          },
          child: ListTile(
            title: Text(
              _transaction.description,
            ),
            trailing: Text(_simpleCurrencyValue),
            onTap: () {
              print(_transaction);
            },
          ),
        );
      },
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
    );

    return Container(
      child: this.transactions.isNotEmpty
          ? _transactionsBuilder
          : const Center(child: Text("No transactions.")),
    );
  }
}
