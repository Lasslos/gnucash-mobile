import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:intl/intl.dart';

class TransactionsView extends ConsumerWidget {
  /// The account node to display transactions for.
  ///
  /// If null, all transactions will be displayed.
  final AccountNode? accountNode;

  const TransactionsView({required this.accountNode, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<MapEntry<Account, Transaction>> transactions = [];
    // If no accountNode is selected, show all transactions.
    // Otherwise, show only those belonging to the selected account node.
    if (accountNode == null) {
      Queue<AccountNode> queue = Queue<AccountNode>()
        ..addAll(ref.watch(accountTreeProvider));
      while (queue.isNotEmpty) {
        AccountNode current = queue.removeFirst();
        List<Transaction> currentTransactions =
            ref.watch(transactionsProvider(current.account));
        for (Transaction transaction in currentTransactions) {
          transactions.add(MapEntry(current.account, transaction));
        }
        queue.addAll(current.children);
      }
    } else {
      transactions = ref
          .watch(transactionsProvider(accountNode!.account))
          .map(
            (transaction) => MapEntry(accountNode!.account, transaction),
          )
          .toList();
    }

    transactions.sort((a, b) => a.value.compareTo(b.value));

    return Scaffold(
      appBar: accountNode == null
          ? null
          : AppBar(
              title: Text(
                "${accountNode!.account.name}",
              ),
              actions: [
                // clear all transactions
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      _deleteTransactions(context, ref, transactions),
                ),
              ],
            ),
      body: ListView(
        children: [
          for (MapEntry<Account, Transaction> pair in transactions)
            Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    icon: Icons.edit,
                    backgroundColor: Colors.green,
                    onPressed: (BuildContext context) {
                      //TODO: Edit
                    },
                  ),
                  SlidableAction(
                    icon: Icons.delete,
                    backgroundColor: Colors.red,
                    onPressed: (BuildContext context) {
                      //TODO: Remove
                    },
                  ),
                ],
              ),
              key: ValueKey(pair.value),
              child: TransactionWidget(
                account: pair.key,
                transaction: pair.value,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _deleteTransactions(
    BuildContext context,
    WidgetRef ref,
    List<MapEntry<Account, Transaction>> transactions,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transactions?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete all transactions?'),
                Text('This cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(inherit: true, color: Colors.red),
              ),
              onPressed: () {
                for (MapEntry<Account, Transaction> mapEntry in transactions) {
                  //TODO: Remove transaction in second account!
                  ref
                      .read(transactionsProvider(mapEntry.key).notifier)
                      .remove(mapEntry.value);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
    required this.account,
    required this.transaction,
    super.key,
  });

  final Account account;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    String subtitle = DateFormat.MMMd().format(transaction.date) +
        " | " +
        account.name +
        (transaction.notes.isNotEmpty ? "\n" + transaction.notes : "");
    return ListTile(
      title: Text(transaction.description),
      subtitle: Text(subtitle),
      isThreeLine: transaction.notes.isNotEmpty,
      trailing: Text(
        transaction.amount.toString(),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: transaction.amount.isNegative ? Colors.red : null,
            ),
      ),
    );
  }
}
