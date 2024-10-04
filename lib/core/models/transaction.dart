import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

/// A part of a transaction.
///
/// A transaction contains at least two parts.
/// The sum of the amounts of all parts must be zero.
@freezed
class TransactionPart with _$TransactionPart {
  const factory TransactionPart({
    required Account account,
    required double amount,
  }) = _TransactionPart;

  const TransactionPart._();
  factory TransactionPart.fromJson(Map<String, dynamic> json) => _$TransactionPartFromJson(json);
}

@freezed
class Transaction with _$Transaction implements Comparable<Transaction> {
  @Assert('parts.length >= 2', 'A transaction must have at least two parts')
  @Assert('parts.map((part) => part.amount).reduce((a, b) => a + b) == 0', 'The sum of all parts must be zero')
  factory Transaction({
    required List<TransactionPart> parts,

    /// The type of commodity and currency used in the transaction.
    ///
    /// Example: `CURRENCY::EUR`, `CURRENCY::USD`, `CURRENCY::GBP`
    required String commodityCurrency,
    required DateTime date,
    required String description,
    @Default("") String notes,
  }) = _Transaction;

  const Transaction._();

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  @override
  int compareTo(Transaction other) {
    int dateCompare = date.compareTo(other.date);
    if (dateCompare != 0) {
      return dateCompare;
    }
    return description.compareTo(other.description);
  }
}

/// Converts a transaction to a CSV row.
///
/// The rows are formatted as follows:
/// Date,Transaction ID,Number,Description,Notes,Commodity/Currency,Void Reason,Action,Memo,Full Account Name,Account Name,Amount With Sym,Amount Num.,Value With Sym,Value Num.,Reconcile,Reconcile Date,Rate/Price
List<List<String>> transactionToCSV(Transaction transaction) {
  String id = const Uuid().v4();
  return transaction.parts.map((part) => _transactionPartToCSV(transaction, part, id)).toList();
}

List<String> _transactionPartToCSV(Transaction transaction, TransactionPart part, String id) {
  return [
    DateFormat('yyyy-MM-dd').format(transaction.date), // Date
    id, // Transaction ID
    "", // Number
    transaction.description, // Description
    transaction.notes, // Notes
    transaction.commodityCurrency, // Commodity/Currency
    "", // Void Reason
    "", // Action
    "", // Memo
    part.account.fullName, // Full Account Name
    part.account.name, // Account Name
    "${part.amount} ${part.account.symbol}", // Amount With Sym
    "${part.amount}", // Amount Num.
    "${part.amount} ${part.account.symbol}", // Value With Sym
    "${part.amount}", // Value Num.
    "", // Reconcile
    "", // Reconcile Date
    "", // Rate/Price
  ];
}
