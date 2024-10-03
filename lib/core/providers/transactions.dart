import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

/// Stores the transactions in a sorted list.
///
/// Could we use an AVL Tree? Yes! Are we going to? Well...
/// If anyone wants to move this to an AVL Tree, feel free to do so.
/// Until now, this is a *permanent-temporary* solution.
@Riverpod(keepAlive: true)
class Transactions extends _$Transactions {
  @override
  List <Transaction> build() {
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
    List<Transaction> transactions = transactionsJson.map((transactionJson) => Transaction.fromJson(transactionJson)).toList()
      ..sort();
    return transactions;
  }

  void _setCached() async {
    sharedPreferences.setString(
      'transactions',
      jsonEncode(state.map((transaction) => transaction.toJson()).toList()),
    );
  }

  void add(Transaction transaction) {
    state = [...state]..insert(_binarySearchDate(transaction.date), transaction);
  }
  void remove(Transaction transaction) {
    state = [...state]..removeAt(binarySearch(state, transaction));
  }
  void update(Transaction oldTransaction, Transaction transaction) {
    state = [...state]..[binarySearch(state, oldTransaction)] = transaction;
  }
  void clear() {
    state = [];
  }

  /// Returns the index of the first transaction that is after the given date.
  int _binarySearchDate(DateTime date) {
    int low = 0;
    int high = state.length - 1;
    while (low <= high) {
      int mid = low + ((high - low) / 2).floor();
      if (state[mid].date.isBefore(date)) {
        low = mid + 1;
      } else if (state[mid].date.isAfter(date)) {
        high = mid - 1;
      } else {
        return mid;
      }
    }
    return low;
  }
}

@riverpod
List<Transaction> transactionsByAccount(TransactionsByAccountRef ref, Account account) {
  List<Transaction> transactions = ref.watch(transactionsProvider);
  return transactions.where((transaction) => transaction.parts.any((part) => part.account == account)).toList();
}
