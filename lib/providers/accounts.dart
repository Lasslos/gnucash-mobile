import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts.freezed.dart';
part 'accounts.g.dart';

late String _accountCSV;

Future<void> initAccounts() async {
  /// TODO: Using applicationSupportDirectory is discouraged for userData, migrate to SharedPreferences
  Directory directory = await getApplicationSupportDirectory();
  File file = File('${directory.path}/accounts.csv');
  if (!(await file.exists())) {
    _accountCSV = "";
    return;
  }
  _accountCSV = await file.readAsString();
}

@Freezed(makeCollectionsUnmodifiable: false)
class Account with _$Account {
  const factory Account({
    required String type,
    required String fullName,
    required String name,
    required String code,
    required String description,
    required String color,
    required String notes,
    required String commodityM,
    required String commodityN,
    required bool hidden,
    required bool tax,
    required bool placeholder,
    @Default(0) double balance,
    @Default([]) List<Account> children,
    String? parentFullName,
  }) = _Account;

  const Account._();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  factory Account.fromCSVLine(List<String> line) {
    line = line.map((e) => e.trim()).toList();

    // Check if account has parent.
    // The full name of the account is in the form
    // "Parent:Child:Grandchild:..."
    String fullName = line[1];
    int lastIndex = fullName.lastIndexOf(":");
    String? parentFullName;
    if (lastIndex > 0) {
      parentFullName = fullName.substring(0, lastIndex);
    }

    return Account(
      type: line[0],
      fullName: line[1],
      name: line[2],
      code: line[3],
      description: line[4],
      color: line[5],
      notes: line[6],
      commodityM: line[7],
      commodityN: line[8],
      hidden: line[9] == 'T',
      tax: line[10] == 'T',
      placeholder: line[11] == 'T',
      parentFullName: parentFullName,
      children: [],
    );
  }
}

/// Stores and exposes the accounts.
@Riverpod(keepAlive: true)
class Accounts extends _$Accounts {
  @override
  List<Account> build() {
    return _getCachedAccounts();
  }

  List<Account> _getCachedAccounts() {
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
    List<List<String>> parsedCSV = converter.convert(_accountCSV.trim());
    if (parsedCSV.isEmpty) {
      return [];
    }
    parsedCSV.removeAt(0); // Remove header

    // Convert List<List<String>> to List<Account>
    List<Account> accounts =
        parsedCSV.map((csvLine) => Account.fromCSVLine(csvLine)).toList();

    Map<String, Account> lookup = {};
    List<Account> hierarchicalAccounts = [];

    // Build hierarchical accounts
    // ToDo: Refactor
    for (Account account in accounts) {
      if (lookup.containsKey(account.parentFullName)) {
        Account parent = lookup[account.parentFullName]!;
        //TODO: This might throw if children list is unmodifiable.
        //TODO: Make children list unmodifiable by default and solve this differently.
        parent.children.add(account);
      } else {
        hierarchicalAccounts.add(account);
      }

      lookup[account.fullName] = account;
    }
    return List.unmodifiable(hierarchicalAccounts);
  }

  Future<void> setAccounts(String csv) async {
    _accountCSV = csv;
    Directory directory = await getApplicationSupportDirectory();
    File file = File('${directory.path}/accounts.csv');
    await file.writeAsString(csv);
    state = _getCachedAccounts();
  }

  Future<void> clearAccounts() async {
    _accountCSV = "";
    Directory directory = await getApplicationSupportDirectory();
    File file = File('${directory.path}/accounts.csv');
    await file.writeAsString("");
    state = List.unmodifiable([]);
  }
}

@riverpod
List<Account> validTransactionAccounts(ValidTransactionAccountsRef ref) {
  Queue<Account> accounts = Queue()
    ..addAll(ref.watch(accountsProvider));
  List<Account> validAccounts = [];
  while (accounts.isNotEmpty) {
    Account account = accounts.removeFirst();
    if (!account.hidden && !account.placeholder) {
      validAccounts.add(account);
    }
    accounts.addAll(account.children);
  }
  return validAccounts;
}

@riverpod
class FavoriteDebitAccount extends _$FavoriteDebitAccount {
  @override
  Account? build() {
    String? json = sharedPreferences.getString('favoriteDebitAccount');
    if (json == null) {
      return null;
    }
    return Account.fromJson(jsonDecode(json));
  }

  void set(Account account) {
    sharedPreferences.setString(
      'favoriteDebitAccount',
      jsonEncode(account.toJson()),
    );
    state = account;
  }

  void clear() {
    sharedPreferences.remove('favoriteDebitAccount');
    state = null;
  }
}

@riverpod
class FavoriteCreditAccount extends _$FavoriteCreditAccount {
  @override
  Account? build() {
    String? json = sharedPreferences.getString('favoriteCreditAccount');
    if (json == null) {
      return null;
    }
    return Account.fromJson(jsonDecode(json));
  }

  void set(Account account) {
    sharedPreferences.setString(
      'favoriteCreditAccount',
      jsonEncode(account.toJson()),
    );
    state = account;
  }

  void clear() {
    sharedPreferences.remove('favoriteCreditAccount');
    state = null;
  }
}
