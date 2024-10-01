import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
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
  // ignore: unused_element
  const _GlobalTransactionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> transactionIds = [
      for (Account account in ref.watch(transactionAccountListProvider))
        ...ref.watch(singleTransactionsProvider(account)).keys,
    ];
    Map<String, Transaction> transactionsMap = {
      for (String transactionId in transactionIds)
        transactionId: ref.watch(transactionsProvider(transactionId))!,
    };
    List<Transaction> transactions = transactionsMap.values.toList()..sort(
      (a, b) => a.singleTransaction.compareTo(b.singleTransaction),
    );

    return ListView(
      children: [
        for (Transaction transaction in transactions)
          TransactionSlidable(
            key: ValueKey(transaction.singleTransaction),
            child: TransactionWidget(transaction: transaction),
            onEdit: (context) {
              // TODO: Implement edit
            },
            onDelete: (context) {
              ref.read(transactionsProvider(transaction.singleTransaction.id).notifier).delete();
            },
          ),
      ],
    );
  }
}

class _SingleAccountTransactionsView extends ConsumerWidget {
  // ignore: unused_element
  const _SingleAccountTransactionsView({required this.account, super.key});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<SingleTransaction> transactions = ref.watch(singleTransactionsProvider(account)).values.toList()..sort(
      (a, b) => a.compareTo(b),
    );

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
          for (SingleTransaction singleTransaction in transactions)
            TransactionSlidable(
              key: ValueKey(singleTransaction),
              child: SingleTransactionWidget(account: account, transaction: singleTransaction),
              onEdit: (context) {
                // TODO: Implement edit
              },
              onDelete: (context) {
                ref.read(transactionsProvider(singleTransaction.id).notifier).delete();
              },
            ),
        ],
      ),
    );
  }

  Future<void> _deleteTransactions(
    BuildContext context,
    WidgetRef ref,
    List<SingleTransaction> transactions,
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
                for (SingleTransaction singleTransaction in transactions) {
                  ref.read(transactionsProvider(singleTransaction.id).notifier).delete();
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

class SingleTransactionWidget extends StatelessWidget {
  const SingleTransactionWidget({
    required this.account,
    required this.transaction,
    super.key,
  });

  final Account account;
  final SingleTransaction transaction;

  @override
  Widget build(BuildContext context) {
    String subtitle = DateFormat.MMMd().format(transaction.date) + " | " + account.name + (transaction.notes.isNotEmpty ? "\n" + transaction.notes : "");
    return ListTile(
      title: Text(transaction.description),
      subtitle: Text(subtitle),
      isThreeLine: transaction.notes.isNotEmpty,
      trailing: Text(
        transaction.amount.toStringAsFixed(2),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: transaction.amount.isNegative ? Colors.red : null,
            ),
      ),
    );
  }
}

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    SingleTransaction transaction = this.transaction.singleTransaction;
    SingleTransaction otherTransaction = this.transaction.otherSingleTransaction;
    Account account = this.transaction.account;
    Account otherAccount = this.transaction.otherAccount;

    String subtitle = DateFormat.MMMd().format(transaction.date);
    String topLine = account.name;
    String bottomLine = otherAccount.name;

    double amount = transaction.amount * (account.type.debitIsNegative ? -1 : 1);
    double otherAmount = otherTransaction.amount * (otherAccount.type.debitIsNegative ? -1 : 1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topLine,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                bottomLine,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (amount.isNegative ? "" : "+") + amount.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: amount.isNegative ? Colors.red : Colors.green,
                    ),
              ),
              Text(
                (otherAmount.isNegative ? "" : "+") + otherAmount.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: otherAmount.isNegative ? Colors.red : Colors.green,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
