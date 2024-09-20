import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
