import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    Queue<AccountNode> queue = Queue<AccountNode>();
    if (accountNode != null) {
      queue.add(accountNode!);
    } else {
      queue.addAll(ref.watch(rootAccountNodesProvider));
    }
    while (queue.isNotEmpty) {
      AccountNode current = queue.removeFirst();
      List<Transaction> currentTransactions =
          ref.watch(transactionsProvider(current.account));
      for (Transaction transaction in currentTransactions) {
        transactions.add(MapEntry(current.account, transaction));
      }
      queue.addAll(current.children);
    }
    transactions.sort((a, b) => -a.value.compareTo(b.value));

    return ListView(
      children: transactions.map((accountTransactionPair) {
        return TransactionWidget(
          account: accountTransactionPair.key,
          transaction: accountTransactionPair.value,
        );
      }).toList(),
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
      trailing: Text(transaction.amount.toString()),
    );
  }
}
