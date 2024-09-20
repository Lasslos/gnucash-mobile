import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:intl/intl.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
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
  }) = _Transaction;

  const Transaction._();

  static Transaction empty() {
    return Transaction(
      date: DateTime.now(),
      id: "",
      description: "",
      notes: "",
      commodityCurrency: "",
      amount: 0.0,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

/// Converts a transaction to a CSV row.
///
/// The rows are formatted as follows:
/// Date,Transaction ID,Number,Description,Notes,Commodity/Currency,Void Reason,Action,Memo,Full Account Name,Account Name,Amount With Sym,Amount Num.,Value With Sym,Value Num.,Reconcile,Reconcile Date,Rate/Price
List<String> transactionToCSV(Account account, Transaction transaction) {
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

