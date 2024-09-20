import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts.g.dart';

/// Stores and exposes the accounts.
@Riverpod(keepAlive: true)
class RootAccountNodes extends _$RootAccountNodes {
  @override
  List<AccountNode> build() {
    ref.listenSelf((previous, next) {
      if (previous != next) {
        _setCached();
      }
    });
    return _getCached();
  }

  List<AccountNode> _getCached() {
    String? json = sharedPreferences.getString('accounts');
    if (json == null) {
      return [];
    }
    List<dynamic> accounts = jsonDecode(json);
    return List.unmodifiable(
      accounts.map((account) => AccountNode.fromJson(account)).toList(),
    );
  }

  void _setCached() {
    sharedPreferences.setString(
      'accounts',
      jsonEncode(
        state.map((accountNode) => accountNode.account.toJson()).toList(),
      ),
    );
  }

  Future<void> setCSV(String csv) async {
    List<Account> accounts = parseAccountCSV(csv);
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

    state = List.unmodifiable(hierarchicalAccounts);
  }

  Future<void> clear() async {
    state = List.unmodifiable([]);
  }
}

@riverpod
List<Account> allAccounts(AllAccountsRef ref) {
  Queue<AccountNode> accounts = Queue()..addAll(ref.watch(rootAccountNodesProvider));
  List<Account> allAccounts = [];
  while (accounts.isNotEmpty) {
    AccountNode accountNode = accounts.removeFirst();
    accounts.addAll(accountNode.children);
    allAccounts.add(accountNode.account);
  }
  return allAccounts;
}

@riverpod
List<Account> validTransactionAccounts(ValidTransactionAccountsRef ref) {
  Queue<AccountNode> accounts = Queue()..addAll(ref.watch(rootAccountNodesProvider));
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
