import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gnucash_mobile/core/models/account_type.dart';
import 'package:gnucash_mobile/core/models/transaction.dart';
import 'package:logger/logger.dart';

part 'account.freezed.dart';

part 'account.g.dart';

/// Account model.
///
/// CSV format: Type,Full Account Name,Account Name,Account Code,Description,Account Color,Notes,Symbol,Namespace,Hidden,Tax Info,Placeholder
/// Corresponding fields: [type], [fullName], [name], [code], [description], [color], [notes], [symbol], [namespace], [hidden], [tax], [placeholder]
@freezed
class Account with _$Account {
  const factory Account({
    /// The type of the account.
    required AccountType type,

    /// Fully qualified account name, separated by colons.
    ///
    /// Example: `Assets:Checking Account`
    required String fullName,

    /// Account name. [fullName] ends with [name].
    required String name,

    /// Currency symbol.
    ///
    /// Example: `EUR`, `USD`
    required String symbol,

    /// Commodity namespace.
    ///
    /// Example: `CURRENCY`, `STOCK`
    required String namespace,
    required bool hidden,

    /// `true` if the account is a tax-relevant account.
    required bool tax,

    /// `true` if the account should not be used for transactions.
    required bool placeholder,
    String? code,
    String? description,

    /// Color in ----- format. If empty, use #f0ecec.
    /// TODO: Add format and parsing for color.
    @Deprecated("Unfinished feature") String? color,
    String? notes,
  }) = _Account;

  const Account._();

  bool hasParent() => fullName.contains(':');

  String get parentFullName => fullName.substring(0, fullName.lastIndexOf(':'));

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}

/// Parse a CSV string into a list of accounts.
///
/// Returns Accounts and a String List of non-parseable lines.
/// Throws an [AccountParsingException] if an error occurs.
MapEntry<List<Account>, List<List<String>>> parseAccountCSV(String csvString) {
  const detector = FirstOccurrenceSettingsDetector(
    eols: ['\r\n', '\n'],
  );
  List<List<String>> csv = const CsvToListConverter(
    csvSettingsDetector: detector,
    shouldParseNumbers: false,
  ).convert(csvString);
  List<Account> accounts = [];
  List<List<String>> nonParseable = [];
  String errorMessage = "CSV is empty";

  if (csv.length <= 1) {
    return MapEntry(accounts, nonParseable);
  }
  for (int i = 1; i < csv.length; i++) {
    try {
      AccountType type = AccountType.fromJson(csv[i][0]);

      String fullName = csv[i][1];
      String name = csv[i][2];
      assert(fullName.endsWith(name), "Full name must end with name");

      String? emptyStringToNull(String? s) => s == "" ? null : s;
      String? code = emptyStringToNull(csv[i][3]);
      String? description = emptyStringToNull(csv[i][4]);
      String? color = emptyStringToNull(csv[i][5]);
      String? notes = emptyStringToNull(csv[i][6]);

      String symbol = csv[i][7];
      String namespace = csv[i][8];
      assert(
        csv[i][9] == "T" || csv[i][9] == "F",
        "Hidden must be T or F, got ${csv[i][9]}",
      );
      assert(
        csv[i][10] == "T" || csv[i][10] == "F",
        "Tax must be T or F, got ${csv[i][10]}",
      );
      assert(
        csv[i][11] == "T" || csv[i][11] == "F",
        "Placeholder must be T or F, got ${csv[i][11]}",
      );
      bool hidden = csv[i][9] == "T";
      bool tax = csv[i][10] == "T";
      bool placeholder = csv[i][11] == "T";

      accounts.add(
        Account(
          type: type,
          fullName: fullName,
          name: name,
          code: code,
          description: description,
          color: color,
          notes: notes,
          symbol: symbol,
          namespace: namespace,
          hidden: hidden,
          tax: tax,
          placeholder: placeholder,
        ),
      );
    } catch (e, s) {
      Logger().w(
        "Error parsing account CSV",
        time: DateTime.now(),
        error: e,
        stackTrace: s,
      );
      nonParseable.add(csv[i]);
      errorMessage = e.toString();
    }
  }
  if (accounts.isEmpty) {
    throw AccountParsingException("Zero accounts parsed: $errorMessage");
  }
  return MapEntry(accounts, nonParseable);
}

class AccountParsingException implements Exception {
  final String message;

  AccountParsingException(this.message);

  @override
  String toString() {
    return 'AccountParsingException: $message';
  }
}

@freezed
class AccountTransactionPair with _$AccountTransactionPair {
  factory AccountTransactionPair(
    Account account,
    Transaction transaction,
  ) = _AccountTransactionPair;
}

@freezed
class DoubleEntryTransaction with _$DoubleEntryTransaction {
  factory DoubleEntryTransaction(
    AccountTransactionPair first,
    AccountTransactionPair second,
  ) = _DoubleEntryTransaction;
}
