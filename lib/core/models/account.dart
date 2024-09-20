import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
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
    ///
    /// Example: `ASSET`, `LIABILITY`, `EQUITY`, `INCOME`, `EXPENSE`
    required String type,

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

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

/// Parse a CSV string into a list of accounts.
///
/// Throws
List<Account> parseAccountCSV(String csvString) {
  const detector = FirstOccurrenceSettingsDetector(
    eols: ['\r\n', '\n'],
  );
  List<List<String>> csv = const CsvToListConverter(
    csvSettingsDetector: detector,
  ).convert(csvString);
  List<Account> accounts = [];
  if (csv.length <= 1) {
    return accounts;
  }
  for (int i = 1; i < csv.length; i++) {
    try {
      String type = csv[i][0];
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
      Logger().e(
        "Error parsing account CSV",
        time: DateTime.now(),
        error: e,
        stackTrace: s,
      );
      throw AccountParsingException(
        "Error parsing account CSV at line ${i + 1}",
      );
    }
  }
  return accounts;
}

class AccountParsingException implements Exception {
  final String message;

  AccountParsingException(this.message);

  @override
  String toString() {
    return 'AccountParsingException: $message';
  }
}
