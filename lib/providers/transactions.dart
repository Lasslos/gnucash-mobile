import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.freezed.dart';
part 'transactions.g.dart';

late String _transactionCSV;
Future<void> initTransactions() async {
  /// TODO: Using applicationSupportDirectory is discouraged for userData, migrate to SharedPreferences
  Directory directory = await getApplicationSupportDirectory();
  File file = File('${directory.path}/transactions.csv');
  if (!(await file.exists())) {
    _transactionCSV = "";
    return;
  }
  _transactionCSV = await file.readAsString();
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String date,
    required String id,
    required int? number,
    required String description,
    required String notes,
    required String commodityCurrency,
    required String voidReason,
    required String action,
    required String memo,
    required String fullAccountName,
    required String accountName,
    required String amountWithSymbol,
    required double? amount,
    required String reconcile,
    required String reconcileDate,
    required int? ratePrice,
  }) = _Transaction;
  const Transaction._();

  static Transaction empty() {
    return const Transaction(
      date: "",
      id: "",
      number: null,
      description: "",
      notes: "",
      commodityCurrency: "",
      voidReason: "",
      action: "",
      memo: "",
      fullAccountName: "",
      accountName: "",
      amountWithSymbol: "",
      amount: null,
      reconcile: "",
      reconcileDate: "",
      ratePrice: null,
    );
  }

  factory Transaction.fromCSVLine(List<String> items) {
    items = items.map((item) => item.trim()).toList();

    return Transaction(
      date: items[0],
      id: items[1],
      number: int.tryParse(items[2]) ?? null,
      description: items[3],
      notes: items[4],
      commodityCurrency: items[5],
      voidReason: items[6],
      action: items[7],
      memo: items[8],
      fullAccountName: items[9],
      accountName: items[10],
      amountWithSymbol: items[11],
      amount: double.tryParse(items[12]) ?? null,
      reconcile: items[13],
      reconcileDate: items[14],
      ratePrice: int.tryParse(items[15]) ?? null,
    );
  }
  List<dynamic> toCSVLine() {
    return [
      date,
      id,
      number ?? "",
      description,
      notes,
      commodityCurrency,
      voidReason,
      action,
      memo,
      fullAccountName,
      accountName,
      amountWithSymbol,
      amount ?? "",
      reconcile,
      reconcileDate,
      ratePrice ?? "",
    ];
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@riverpod
class Transactions extends _$Transactions {
  @override
  List<Transaction> build() {
    return _getCachedTransactions();
  }

  List<Transaction> _getCachedTransactions() {
    // Using _accountCSV.
    // TODO: Migrate data collection to SharedPreferences

    // Convert CSV to List<List<String>>
    const detector = FirstOccurrenceSettingsDetector(
      eols: ['\r\n', '\n'],
    );
    const converter = CsvToListConverter(
      csvSettingsDetector: detector,
      textDelimiter: '"',
      shouldParseNumbers: false,
    );

    List<List<String>> parsedCSV = converter.convert(_transactionCSV.trim());

    // Convert List<List<String>> to List<Transaction>
    return List.unmodifiable(
      parsedCSV.map((line) => Transaction.fromCSVLine(line)).toList(),
    );
  }

  void _setCachedTransactions() async {
    Directory directory = await getApplicationSupportDirectory();
    File file = File('${directory.path}/transactions.csv');
    String csvString = const ListToCsvConverter(eol: "\n")
        .convert(state.map((transaction) => transaction.toCSVLine()).toList());
    await file.writeAsString(csvString);
  }

  void addAll(List<Transaction> transactions) {
    state = List.unmodifiable([...state, ...transactions]);
    _setCachedTransactions();
  }

  void removeAll() {
    state = List.unmodifiable([]);
    _setCachedTransactions();
  }

  void remove(Transaction transaction) {
    state = List.unmodifiable([...state]..remove(transaction));
    _setCachedTransactions();
  }

  String getCSV() {
    String content = const ListToCsvConverter(eol: "\n")
        .convert(state.map((transaction) => transaction.toCSVLine()).toList());
    return "Date,Transaction ID,Number,Description,Notes,Commodity/Currency,Void Reason,Action,Memo,Full Account Name,Account Name,Amount With Sym.,Amount Num,Reconcile,Reconcile Date,Rate/Price\n$content";
  }
}

@riverpod
Map<String, List<Transaction>> transactionsByAccountFullName(
  TransactionsByAccountFullNameRef ref,
) {
  final transactions = ref.watch(transactionsProvider);
  final Map<String, List<Transaction>> transactionsByAccountFullName = {};

  for (var transaction in transactions) {
    transactionsByAccountFullName.putIfAbsent(
      transaction.fullAccountName,
      () => [],
    );
    transactionsByAccountFullName[transaction.fullAccountName]!
        .add(transaction);
  }
  return transactionsByAccountFullName;
}
