import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'balance.g.dart';

@riverpod
double balance(BalanceRef ref, AccountNode accountNode) {
  Account account = accountNode.account;
  Set<Account> accountWithDescendants = accountNode.descendants.map((node) => node.account).toSet()
    ..add(account);
  double balance = 0;
  for (Account account in accountWithDescendants) {
    for (Transaction transaction in ref.watch(transactionsByAccountProvider(account))) {
      balance += transaction.parts
          .where((part) => accountWithDescendants.contains(part.account))
          .fold(0, (sum, part) => sum + part.amount);
    }
  }

  if (account.type.debitIsNegative) {
    balance = -balance;
  }
  // For some reason, in dart: -0.0 is negative, but this should be considered positive.
  if (balance == -0.0) {
    balance = 0.0;
  }
  return balance;
}
