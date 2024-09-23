import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

@Riverpod(keepAlive: true)
class Transactions extends _$Transactions {
  @override
  List<Transaction> build(Account account) {
    ref.listenSelf((previous, next) {
      if (previous != next) {
        _setCached();
      }
    });
    return _getCached();
  }

  List<Transaction> _getCached() {
    String? json = sharedPreferences.getString('transactions.account.$account');
    if (json == null) {
      return [];
    }
    List<dynamic> transactions = jsonDecode(json);
    return List.unmodifiable(
      transactions.map((transaction) => Transaction.fromJson(transaction)).toList(),
    );
  }
  void _setCached() async {
    sharedPreferences.setString(
      'transactions.account.$account',
      jsonEncode(
        state.map((transaction) => transaction.toJson()).toList(),
      ),
    );
  }

  void add(Transaction transaction) {
    state = List.unmodifiable([...state, transaction]);
  }

  void addAll(List<Transaction> transactions) {
    state = List.unmodifiable([...state, ...transactions]);
  }

  void removeAll() {
    state = List.unmodifiable([]);
  }

  void remove(Transaction transaction) {
    state = List.unmodifiable([...state]..remove(transaction));
  }
}

const csvHeader = [
  "Date",
  "Transaction ID",
  "Number",
  "Description",
  "Notes",
  "Commodity/Currency",
  "Void Reason",
  "Action",
  "Memo",
  "Full Account Name",
  "Account Name",
  "Amount With Sym",
  "Amount Num.",
  "Value With Sym",
  "Value Num.",
  "Reconcile",
  "Reconcile Date",
  "Rate/Price",
];

@riverpod
String transactionsCSV(TransactionsCSVRef ref) {
  List<List<String>> csv = []
    ..add(csvHeader);

  List<MapEntry<Account, Transaction>> transactions = [];
  List<Account> accounts = ref.watch(accountListProvider);
  // Iterate over all accounts and collect the transactions
  for (Account account in accounts) {
    List<Transaction> currentTransactions = ref.watch(transactionsProvider(account));
    transactions.addAll(currentTransactions.map((transaction) => MapEntry(account, transaction)));
  }

  for (MapEntry<Account, Transaction> pair in transactions) {
    csv.add(transactionToCSV(pair.key, pair.value));
  }

  return const ListToCsvConverter(eol: "\n").convert(csv);
}
