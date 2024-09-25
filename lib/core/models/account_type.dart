import 'package:json_annotation/json_annotation.dart';

part 'account_type.g.dart';

/// The account type.
/// See [GnuCash Source](https://github.com/Gnucash/gnucash/blob/5.8/libgnucash/engine/Account.h)
@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.screamingSnake)
enum AccountType {
  /// The bank account type denotes a savings
  /// or checking account held at a bank.
  /// Often interest bearing.
  bank("Deposit", "Withdrawal"),

  /// The cash account type is used to denote a
  /// shoe-box or pillowcase stuffed with *
  /// cash.
  cash("Receive", "Spend"),

  /// The Credit card account is used to denote
  /// credit (e.g. amex) and debit (e.g. visa,
  /// mastercard) card accounts
  credit("Payment", "Charge"),

  /// asset (and liability) accounts indicate
  /// generic, generalized accounts that are
  /// none of the above.
  asset("Increase", "Decrease"),

  /// liability (and asset) accounts indicate
  /// generic, generalized accounts that are
  /// none of the above.
  liability("Decrease", "Increase"),

  /// Income accounts are used to denote
  /// income
  income("Charge", "Income"),

  /// Expense accounts are used to denote
  /// expenses.
  expense("Expense", "Rebate"),

  /// Equity account is used to balance the
  /// balance sheet.
  equity("Decrease", "Increase");

  const AccountType(this.debitName, this.creditName);
  final String debitName;
  final String creditName;

  String toJson() => _$AccountTypeEnumMap[this]!;
  factory AccountType.fromJson(String json) => _$AccountTypeEnumMap.entries.firstWhere(
    (entry) => entry.value == json,
    orElse: () => throw ArgumentError.value(json, 'json', 'Invalid JSON value for AccountType'),
  ).key;
}
