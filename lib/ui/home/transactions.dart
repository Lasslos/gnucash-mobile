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
      return _AccountTransactionsView(account: account!);
    }
  }
}

class _GlobalTransactionsView extends ConsumerWidget {
  // ignore: unused_element
  const _GlobalTransactionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Transaction> transactions = ref.watch(transactionsProvider);

    return ListView(
      children: [
        for (Transaction transaction in transactions)
          TransactionSlidable(
            key: ValueKey(transaction),
            child: TransactionWidget(transaction: transaction),
            onEdit: (context) {
              // TODO: Implement edit
            },
            onDelete: (context) {
              ref.read(transactionsProvider.notifier).remove(transaction);
            },
          ),
      ],
    );
  }
}

class _AccountTransactionsView extends ConsumerWidget {
  // ignore: unused_element
  const _AccountTransactionsView({required this.account, super.key});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Transaction> transactions = ref.watch(transactionsByAccountProvider(account));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${account.name}",
        ),
        actions: [
          // clear all transactions
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteAllTransactions(context, ref, transactions),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (Transaction transaction in transactions)
            TransactionSlidable(
              key: ValueKey(transaction),
              child: TransactionPartWidget(account: account, transaction: transaction),
              onEdit: (context) {
                // TODO: Implement edit
              },
              onDelete: (context) {
                ref.read(transactionsProvider.notifier).remove(transaction);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _deleteAllTransactions(
    BuildContext context,
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
                  ref.read(transactionsProvider.notifier).remove(transaction);
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

class TransactionSlidable extends ConsumerWidget {
  const TransactionSlidable({required this.child, required this.onEdit, required this.onDelete, super.key});

  final void Function(BuildContext) onEdit;
  final void Function(BuildContext) onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            icon: Icons.edit,
            backgroundColor: Colors.green,
            onPressed: onEdit,
          ),
          SlidableAction(
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: onDelete,
          ),
        ],
      ),
      child: child,
    );
  }
}

class TransactionPartWidget extends StatelessWidget {
  const TransactionPartWidget({
    required this.account,
    required this.transaction,
    super.key,
  });

  final Account account;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    String subtitle = DateFormat.MMMd().format(transaction.date) + " | " + account.name + (transaction.notes.isNotEmpty ? "\n" + transaction.notes : "");
    TransactionPart transactionPart = transaction.parts.firstWhere((part) => part.account == account);
    double amount = transactionPart.amount * (account.type.debitIsNegative ? -1 : 1);

    return ListTile(
      title: Text(transaction.description),
      subtitle: Text(subtitle),
      isThreeLine: transaction.notes.isNotEmpty,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount.toStringAsFixed(2),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: amount.isNegative ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.description + " - " + DateFormat.MMMd().format(transaction.date),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth(),
              3: IntrinsicColumnWidth(),
              4: IntrinsicColumnWidth(),
            },
           children: [
              for (TransactionPart part in transaction.parts)
                TableRow(
                  children: [
                    Text(part.account.name),
                    const SizedBox(width: 8),
                    Text(part.amount.isNegative ? "" : part.amount.toStringAsFixed(2)),
                    const SizedBox(width: 8),
                    Text(part.amount.isNegative ? (-part.amount).toStringAsFixed(2) : ""),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
