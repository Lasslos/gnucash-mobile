import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:intl/intl.dart';

class TransactionsView extends ConsumerWidget {
  final Account account;

  const TransactionsView({required this.account, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Transaction> transactions = ref.watch(
      transactionsProvider(account),
    );

    final _simpleCurrencyNumberFormat = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );

    final _transactionsBuilder = ListView.builder(
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return const Divider();
        }

        final int i = index ~/ 2;
        if (i >= transactions.length) {
          return null;
        }

        final _transaction = transactions[i];
        final _simpleCurrencyValue =
            _simpleCurrencyNumberFormat.format(_transaction.amount);
        return Dismissible(
          background: Container(color: Colors.red),
          key: Key(_transaction.description + account.fullName),
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
      child: transactions.isNotEmpty
          ? _transactionsBuilder
          : const Center(child: Text("No transactions.")),
    );
  }
}
