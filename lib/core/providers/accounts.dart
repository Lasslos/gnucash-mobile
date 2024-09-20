import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:gnucash_mobile/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';

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

// TODO: Migrate data collection to SharedPreferences
/// Stores and exposes the accounts.
@Riverpod(keepAlive: true)
class Accounts extends _$Accounts {
  @override
  List<AccountNode> build() {
    return _getCachedAccounts();
  }

  List<AccountNode> _getCachedAccounts() {
    List<Account> accounts = parseAccountCSV(_accountCSV);
    Map<String, AccountNode> lookup = {};

    // Build hierarchical accounts
    for (Account account in accounts) {
      lookup[account.fullName] = AccountNode(account: account, children: []);
    }
    List<AccountNode> hierarchicalAccounts = [];
    for (Account account in accounts) {
      if (account.hasParent()) {
        lookup[account.parentFullName]!.children.add(lookup[account.fullName]!);
      } else {
        hierarchicalAccounts.add(lookup[account.fullName]!);
      }
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
  Queue<AccountNode> accounts = Queue()..addAll(ref.watch(accountsProvider));
  List<Account> validAccounts = [];
  while (accounts.isNotEmpty) {
    AccountNode accountNode = accounts.removeFirst();
    accounts.addAll(accountNode.children);
    if (!accountNode.account.placeholder) {
      validAccounts.add(accountNode.account);
    }
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
