import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:gnucash_mobile/ui/account_view.dart';
import 'package:gnucash_mobile/ui/transaction_form.dart';
import 'package:gnucash_mobile/ui/transactions_view.dart';
import 'package:intl/intl.dart';

class ListOfAccounts extends ConsumerWidget {
  final List<Account> accounts;

  const ListOfAccounts({required this.accounts, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _simpleCurrencyNumberFormat = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );

    Map<String, List<Transaction>> transactionsByAccountFullName =
        ref.watch(transactionsByAccountFullNameProvider);

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return const Divider();
        }

        final int i = index ~/ 2;
        if (i >= this.accounts.length) {
          return null;
        }

        final _account = this.accounts[i];
        final List<Transaction> _transactions = [];
        for (var key in transactionsByAccountFullName.keys) {
          if (key.startsWith(_account.fullName)) {
            _transactions.addAll(
              transactionsByAccountFullName[key] ?? [],
            );
          }
        }
        final double _balance = _transactions.fold(
          0.0,
          (previousValue, element) => previousValue + element.amount!,
        );
        final _simpleCurrencyValue =
            _simpleCurrencyNumberFormat.format(_balance);

        return ListTile(
          title: Text(
            _account.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Text(
            _simpleCurrencyValue,
          ),
          onTap: () {
            if (_account.children.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(_account.fullName),
                      ),
                      body: TransactionsView(
                        transactions:
                            transactionsByAccountFullName[_account.fullName] ??
                                [],
                      ),
                      floatingActionButton: Builder(
                        builder: (context) {
                          return FloatingActionButton(
                            child: const Icon(Icons.add),
                            onPressed: () async {
                              final _success = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionForm(
                                    toAccount: _account,
                                  ),
                                ),
                              );

                              if (_success != null && _success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Transaction created!"),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountView(account: _account),
                ),
              );
            }
          },
        );
      },
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
    );
  }
}
