import 'dart:convert';

import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

@riverpod
class Transactions extends _$Transactions {
  @override
  Transaction? build(String transactionId) {
    String? json = sharedPreferences.getString('transactions.transaction.$transactionId');
    if (json == null) {
      return null;
    }

    Map<String, dynamic> transactionJson = jsonDecode(json);

    Account? account = ref.watch(
      accountNameMapProvider.select(
        (accountMap) => accountMap[transactionJson["accountFullName"]],
      ),
    );
    Account? otherAccount = ref.watch(
      accountNameMapProvider.select(
        (accountMap) => accountMap[transactionJson["otherAccountFullName"]],
      ),
    );
    if (account == null || otherAccount == null) {
      Logger().w("Could not find account ${transactionJson["accountFullName"]} or ${transactionJson["otherAccountFullName"]} for transaction.");
      return null;
    }

    SingleTransaction? singleTransaction = ref.watch(
      singleTransactionsProvider(account).select(
        (transactions) => transactions[transactionId],
      ),
    );
    SingleTransaction? otherSingleTransaction = ref.watch(
      singleTransactionsProvider(otherAccount).select(
        (transactions) => transactions[transactionId],
      ),
    );
    if (singleTransaction == null || otherSingleTransaction == null) {
      Logger().w("Could not find single transaction for transaction.");
      return null;
    }

    return Transaction(
      account: account,
      otherAccount: otherAccount,
      singleTransaction: singleTransaction,
      otherSingleTransaction: otherSingleTransaction,
    );
  }

  Future<void> _setCached(Transaction? transaction) async {
    if (transaction == null) {
      await sharedPreferences.remove('transactions.transaction.$transactionId');
      return;
    }
    await sharedPreferences.setString(
      'transactions.transaction.$transactionId',
      jsonEncode(
        {
          "accountFullName": transaction.account.fullName,
          "otherAccountFullName": transaction.otherAccount.fullName,
        }
      ),
    );
  }

  void set(Transaction transaction) async {
    state = transaction;
    ref.read(singleTransactionsProvider(transaction.account).notifier)._add(transaction.singleTransaction);
    ref.read(singleTransactionsProvider(transaction.otherAccount).notifier)._add(transaction.otherSingleTransaction);
    await _setCached(transaction);
    // Refreshes the watched providers
    ref.invalidateSelf();
  }

  void delete() async {
    ref.read(singleTransactionsProvider(state!.account).notifier)._remove(state!.singleTransaction.id);
    ref.read(singleTransactionsProvider(state!.otherAccount).notifier)._remove(state!.otherSingleTransaction.id);
    state = null;
    await _setCached(null);
    // Refreshes the watched providers
    ref.invalidateSelf();
  }
}

@Riverpod(keepAlive: true)
class SingleTransactions extends _$SingleTransactions {
  @override
  Map<String, SingleTransaction> build(Account account) {
    ref.listenSelf((previous, next) {
      if (previous != next) {
        _setCached();
      }
    });
    return _getCached(account);
  }

  void _setCached() async {
    sharedPreferences.setString(
      'singleTransactions.account.${account.fullName}',
      jsonEncode(
        state.map((id, transaction) => MapEntry(id, transaction.toJson())),
      ),
    );
  }

  Map<String, SingleTransaction> _getCached(Account account) {
    String? json = sharedPreferences.getString('singleTransactions.account.${account.fullName}');
    if (json == null) {
      return {};
    }
    Map<String, dynamic> transactionsJson = jsonDecode(json);
    Map<String, SingleTransaction> transactions = {};
    for (String id in transactionsJson.keys) {
      transactions[id] = SingleTransaction.fromJson(transactionsJson[id]);
    }
    return Map.unmodifiable(transactions);
  }

  void _add(SingleTransaction transaction) {
    state = Map.unmodifiable({...state, transaction.id: transaction});
  }

  void _remove(String transactionId) {
    state = Map.unmodifiable({...state}..remove(transactionId));
  }
}
