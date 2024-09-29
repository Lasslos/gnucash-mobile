import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

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
    Map<Account, List<Transaction>> transactions = {};
    for (Account account in ref.watch(transactionAccountListProvider)) {
      transactions[account] = ref.watch(transactionsProvider(account));
    }

    List<DoubleEntryTransaction> doubleEntryTransactions = [];
    Map<String, List<AccountTransactionPair>> transactionsById = {};
    for (Account account in transactions.keys) {
      for (Transaction transaction in transactions[account]!) {
        transactionsById.putIfAbsent(transaction.id, () => []);
        transactionsById[transaction.id]!.add(
          AccountTransactionPair(
            transactions.keys.firstWhere((element) => transactions[element]!.contains(transaction)),
            transaction,
          ),
        );
      }
    }
    for (List<AccountTransactionPair> pairs in transactionsById.values) {
      if (pairs.length != 2) {
        Logger().w("Transaction with id ${pairs.first.transaction.id} has ${pairs.length} entries, expected 2");
      } else {
        doubleEntryTransactions.add(DoubleEntryTransaction(pairs[0], pairs[1]));
      }
    }
    doubleEntryTransactions.sort(
      (a, b) => a.first.transaction.compareTo(b.first.transaction),
    );

    return ListView(
      children: [
        for (DoubleEntryTransaction doubleEntryTransaction in doubleEntryTransactions)
          TransactionSlidable(
            key: ValueKey(doubleEntryTransaction.first.transaction),
            child: DoubleEntryTransactionWidget(doubleEntryTransaction: doubleEntryTransaction),
            onEdit: (context) {
              // TODO: Implement edit
            },
            onDelete: (context) {
              ref.read(doubleEntryTransactionListProvider.notifier).remove(doubleEntryTransaction);
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
            TransactionSlidable(
              key: ValueKey(transaction),
              child: TransactionWidget(account: account, transaction: transaction),
              onEdit: (context) {
                // TODO: Implement edit
              },
              onDelete: (context) {
                DoubleEntryTransaction doubleEntryTransaction = ref.read(doubleEntryTransactionListProvider).firstWhere(
                  (element) => element.first.transaction.id == transaction.id,
                );
                ref.read(doubleEntryTransactionListProvider.notifier).remove(doubleEntryTransaction);
              },
            ),
        ],
      ),
    );
  }

  Future<void> _deleteTransactions(
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
                List<DoubleEntryTransaction> doubleEntryTransactions = ref.read(doubleEntryTransactionListProvider);
                Set<String> transactionIds = transactions.map((e) => e.id).toSet();
                // Only keep those where the transaction id is in the set of transaction ids to delete
                doubleEntryTransactions.removeWhere((element) => !transactionIds.contains(element.first.transaction.id));
                // Remove the transactions
                for (DoubleEntryTransaction transaction in doubleEntryTransactions) {
                  ref.read(doubleEntryTransactionListProvider.notifier).remove(transaction);
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

class DoubleEntryTransactionWidget extends StatelessWidget {
  const DoubleEntryTransactionWidget({required this.doubleEntryTransaction, super.key});

  final DoubleEntryTransaction doubleEntryTransaction;

  @override
  Widget build(BuildContext context) {
    Transaction transaction = doubleEntryTransaction.first.transaction;
    Transaction otherTransaction = doubleEntryTransaction.second.transaction;
    Account account = doubleEntryTransaction.first.account;
    Account otherAccount = doubleEntryTransaction.second.account;

    String subtitle = DateFormat.MMMd().format(transaction.date);
    String topLine = doubleEntryTransaction.first.account.name;
    String bottomLine = doubleEntryTransaction.second.account.name;

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
                  doubleEntryTransaction.first.transaction.description,
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
