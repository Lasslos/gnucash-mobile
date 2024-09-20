import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:gnucash_mobile/ui/account_view.dart';
import 'package:gnucash_mobile/ui/transaction_form.dart';
import 'package:gnucash_mobile/ui/transactions_view.dart';
import 'package:intl/intl.dart';

class ListOfAccounts extends ConsumerWidget {
  final List<AccountNode> accountNodes;

  const ListOfAccounts({required this.accountNodes, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _simpleCurrencyNumberFormat = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );

    return ListView.builder(
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return const Divider();
        }

        final int i = index ~/ 2;
        if (i >= accountNodes.length) {
          return null;
        }

        final _accountNode = accountNodes[i];
        final _account = _accountNode.account;

        final List<Transaction> _transactions = [
          ...ref.watch(
            transactionsProvider(_account),
          ),
        ];
        Queue<AccountNode> queue = Queue()..addAll(_accountNode.children);
        while (queue.isNotEmpty) {
          final _node = queue.removeFirst();
          _transactions.addAll(
            ref.watch(
              transactionsProvider(_node.account),
            ),
          );
          queue.addAll(_node.children);
        }

        final double _balance = _transactions.fold(
          0.0,
          (previousValue, element) => previousValue + element.amount,
        );
        final _simpleCurrencyValue =
            _simpleCurrencyNumberFormat.format(_balance);

        return ListTile(
          title: Text(
            _accountNode.account.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Text(
            _simpleCurrencyValue,
          ),
          onTap: () {
            if (_accountNode.children.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(_account.fullName),
                      ),
                      body: TransactionsView(
                        account: _account,
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
                  builder: (context) => AccountView(accountNode: _accountNode),
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
