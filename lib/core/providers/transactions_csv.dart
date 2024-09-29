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
  List<List<String>> csv = []..add(csvHeader);

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
