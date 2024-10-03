import 'dart:convert';

import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

@Riverpod(keepAlive: true)
class Transactions extends _$Transactions {
  @override
  List<Transaction> build() {
    ref.listenSelf((previous, next) {
      if (previous != next) {
        _setCached();
      }
    });
    return _getCached();
  }

  List<Transaction> _getCached() {
    String? json = sharedPreferences.getString('transactions');
    if (json == null) {
      return [];
    }
    List<dynamic> transactionsJson = jsonDecode(json);
    return transactionsJson.map((transactionJson) => Transaction.fromJson(transactionJson)).toList();
  }

  void _setCached() async {
    sharedPreferences.setString(
      'transactions',
      jsonEncode(state.map((transaction) => transaction.toJson()).toList()),
    );
  }

  void add(Transaction transaction) {
    state = [...state, transaction];
  }
  void remove(Transaction transaction) {
    state = [...state]..remove(transaction);
  }
  void update(Transaction oldTransaction, Transaction transaction) {
    state = [...state]..[state.indexOf(oldTransaction)] = transaction;
  }
  void clear() {
    state = [];
  }
}

@riverpod
List<Transaction> transactionsByAccount(TransactionsByAccountRef ref, Account account) {
  List<Transaction> transactions = ref.watch(transactionsProvider);
  return transactions.where((transaction) => transaction.parts.any((part) => part.account == account)).toList();
}
