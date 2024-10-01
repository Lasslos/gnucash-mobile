import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:intl/intl.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class SingleTransaction with _$SingleTransaction implements Comparable<SingleTransaction> {
  const factory SingleTransaction({
    /// The date of the transaction.
    required DateTime date,

    /// The identifier of the transaction.
    ///
    /// This identifier is used for both entries in the double-entry system.
    required String id,
    required String description,
    required String notes,

    /// The type of commodity and currency used in the transaction.
    ///
    /// Example: `CURRENCY::EUR`, `CURRENCY::USD`, `CURRENCY::GBP`
    required String commodityCurrency,
    required double amount,
  }) = _SingleTransaction;

  const SingleTransaction._();

  static SingleTransaction empty() {
    return SingleTransaction(
      date: DateTime.now(),
      id: "",
      description: "",
      notes: "",
      commodityCurrency: "",
      amount: 0.0,
    );
  }

  factory SingleTransaction.fromJson(Map<String, dynamic> json) => _$SingleTransactionFromJson(json);

  @override
  int compareTo(SingleTransaction other) {
    int dateCompare = date.compareTo(other.date);
    if (dateCompare != 0) {
      return dateCompare;
    }
    return amount.compareTo(other.amount);
  }
}

/// Converts a transaction to a CSV row.
///
/// The rows are formatted as follows:
/// Date,Transaction ID,Number,Description,Notes,Commodity/Currency,Void Reason,Action,Memo,Full Account Name,Account Name,Amount With Sym,Amount Num.,Value With Sym,Value Num.,Reconcile,Reconcile Date,Rate/Price
List<String> transactionToCSV(Account account, SingleTransaction transaction) {
  return [
    DateFormat('yyyy-MM-dd').format(transaction.date), // Date
    transaction.id, // Transaction ID
    "", // Number
    transaction.description, // Description
    transaction.notes, // Notes
    transaction.commodityCurrency, // Commodity/Currency
    "", // Void Reason
    "", // Action
    "", // Memo
    account.fullName, // Full Account Name
    account.name, // Account Name
    "${transaction.amount} ${account.symbol}", // Amount With Sym
    "${transaction.amount}", // Amount Num.
    "${transaction.amount} ${account.symbol}", // Value With Sym
    "${transaction.amount}", // Value Num.
    "", // Reconcile
    "", // Reconcile Date
    "", // Rate/Price
  ];
}

@freezed
class Transaction with _$Transaction {
  factory Transaction({
    required SingleTransaction singleTransaction,
    required Account account,
    required SingleTransaction otherSingleTransaction,
    required Account otherAccount,
  }) = _Transaction;
}
