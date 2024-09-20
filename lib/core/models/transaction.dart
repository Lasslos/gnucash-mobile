import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

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
