import 'dart:convert';

import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

@riverpod
class DoubleEntryTransactionList extends _$DoubleEntryTransactionList {
  @override
  List<DoubleEntryTransaction> build() {
    List<AccountTransactionPair> transactions = [];
    for (Account account in ref.watch(accountListProvider)) {
      transactions.addAll(
        _getCached(account).map(
          (transaction) => AccountTransactionPair(account, transaction),
        ),
      );
    }

    Map<String, List<AccountTransactionPair>> transactionMap = {};
    for (AccountTransactionPair pair in transactions) {
      transactionMap.putIfAbsent(pair.transaction.id, () => []);
      transactionMap[pair.transaction.id]!.add(pair);
    }

    List<DoubleEntryTransaction> doubleEntryTransactions = [];
    for (List<AccountTransactionPair> pairs in transactionMap.values) {
      if (pairs.length == 2) {
        doubleEntryTransactions.add(DoubleEntryTransaction(pairs[0], pairs[1]));
      } else {
        Logger().w("Transaction ${pairs[0].transaction.id} has ${pairs.length} entries");
      }
    }

    return List.unmodifiable(doubleEntryTransactions);
  }

  void add(DoubleEntryTransaction transaction) {
    AccountTransactionPair first = transaction.first;
    AccountTransactionPair second = transaction.second;
    ref.read(transactionsProvider(first.account).notifier)._add(first.transaction);
    ref.read(transactionsProvider(second.account).notifier)._add(second.transaction);

    state = List.unmodifiable([...state, transaction]);
  }

  void addAll(List<DoubleEntryTransaction> transactions) {
    for (DoubleEntryTransaction transaction in transactions) {
      AccountTransactionPair first = transaction.first;
      AccountTransactionPair second = transaction.second;
      ref.read(transactionsProvider(first.account).notifier)._add(first.transaction);
      ref.read(transactionsProvider(second.account).notifier)._add(second.transaction);
    }
    state = List.unmodifiable([...state, ...transactions]);
  }

  void remove(DoubleEntryTransaction transaction) {
    AccountTransactionPair first = transaction.first;
    AccountTransactionPair second = transaction.second;
    ref.read(transactionsProvider(first.account).notifier)._remove(first.transaction);
    ref.read(transactionsProvider(second.account).notifier)._remove(second.transaction);
    state = List.unmodifiable([...state]..remove(transaction));
  }

  void clear() {
    for (DoubleEntryTransaction transaction in state) {
      AccountTransactionPair first = transaction.first;
      AccountTransactionPair second = transaction.second;
      ref.read(transactionsProvider(first.account).notifier)._remove(first.transaction);
      ref.read(transactionsProvider(second.account).notifier)._remove(second.transaction);
    }
    state = List.unmodifiable([]);
  }
}

@Riverpod(keepAlive: true)
class Transactions extends _$Transactions {
  @override
  List<Transaction> build(Account account) {
    ref.listenSelf((previous, next) {
      if (previous != next) {
        _setCached();
      }
    });
    return _getCached(account);
  }

  void _setCached() async {
    sharedPreferences.setString(
      'transactions.account.$account',
      jsonEncode(
        state.map((transaction) => transaction.toJson()).toList(),
      ),
    );
  }

  void _add(Transaction transaction) {
    state = List.unmodifiable([...state, transaction]);
  }

  void _remove(Transaction transaction) {
    state = List.unmodifiable([...state]..remove(transaction));
  }
}

List<Transaction> _getCached(Account account) {
  String? json = sharedPreferences.getString('transactions.account.$account');
  if (json == null) {
    return [];
  }
  List<dynamic> transactions = jsonDecode(json);
  return List.unmodifiable(
    transactions.map((transaction) => Transaction.fromJson(transaction)).toList(),
  );
}
