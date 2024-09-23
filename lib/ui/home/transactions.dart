import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:intl/intl.dart';

class TransactionsView extends ConsumerWidget {
  /// The account node to display transactions for.
  ///
  /// If null, all transactions will be displayed.
  final Account? account;

  const TransactionsView({required this.account, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (account == null) {
      return const _GlobalTransactionsView();
    } else {
      return _SingleAccountTransactionsView(account: account!);
    }
  }
}

class _GlobalTransactionsView extends ConsumerWidget {
  const _GlobalTransactionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Placeholder();
  }
}

class _SingleAccountTransactionsView extends ConsumerWidget {
  const _SingleAccountTransactionsView({required this.account, super.key});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Transaction> transactions = ref.watch(transactionsProvider(account));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${account.name}",
        ),
        actions: [
          // clear all transactions
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTransactions(context, ref, transactions),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (Transaction transaction in transactions)
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
              key: ValueKey(transaction),
              child: TransactionWidget(
                account: account,
                transaction: transaction,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _deleteTransactions(BuildContext context,
    WidgetRef ref,
    List<Transaction> transactions,
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
                for (Transaction transaction in transactions) {
                  //TODO: Remove transaction in second account!
                  ref.read(transactionsProvider(account).notifier)
                      .remove(transaction);
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
        style: Theme
            .of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(
          fontWeight: FontWeight.bold,
          color: transaction.amount.isNegative ? Colors.red : null,
        ),
      ),
    );
  }
}
