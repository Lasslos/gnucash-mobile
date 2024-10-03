import 'package:csv/csv.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:gnucash_mobile/core/providers/accounts.dart';
import 'package:gnucash_mobile/core/providers/transactions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_csv.g.dart';

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
  List<List<String>> csv = [
    csvHeader,
    ...ref.watch(transactionsProvider).expand(transactionToCSV),
  ];
  return const ListToCsvConverter(eol: "\n").convert(csv);
}
