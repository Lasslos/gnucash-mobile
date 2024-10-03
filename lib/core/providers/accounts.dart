import 'dart:convert';
import 'dart:core';

import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/core/models/account_node.dart';
import 'package:gnucash_mobile/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts.g.dart';

/// Stores and exposes the accounts in tree format.
@Riverpod(keepAlive: true)
class AccountTree extends _$AccountTree {
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
        state.map((accountNode) => accountNode.toJson()).toList(),
      ),
    );
  }

  /// Set the accounts from a CSV string.
  ///
  /// Returns A list of non-parseable lines.
  /// Throws [AccountParsingException] if the CSV is not valid.
  Future<List<List<String>>> setCSV(String csv) async {
    MapEntry<List<Account>, List<List<String>>> accountsAndNonParsable = parseAccountCSV(csv);
    List<Account> accounts = accountsAndNonParsable.key;
    List<List<String>> nonParseable = accountsAndNonParsable.value;
    Map<String, AccountNode> lookup = {};

    // Build hierarchical accounts
    for (Account account in accounts) {
      lookup[account.fullName] = AccountNode(account: account, children: []);
    }
    List<AccountNode> hierarchicalAccounts = [];
    for (Account account in accounts) {
      if (account.hasParent()) {
        AccountNode? parent = lookup[account.parentFullName];
        if (parent == null) {
          throw AccountParsingException('Parent account not found: ${account.parentFullName}');
        }
        lookup[account.parentFullName]!.children.add(lookup[account.fullName]!);
      } else {
        hierarchicalAccounts.add(lookup[account.fullName]!);
      }
    }

    state = List.unmodifiable(hierarchicalAccounts);
    return nonParseable;
  }

  Future<void> clear() async {
    state = List.unmodifiable([]);
  }
}

/// Exposes the accounts in a flat list.
/// This watches [accountTreeProvider] and flattens the tree. Rebuilds when the tree changes.
/// Though inefficient, this is fine as [accountTreeProvider] is not expected to change often.
@riverpod
List<Account> accountList(AccountListRef ref) {
  List<Account> allAccounts = [];
  for (AccountNode accountNode in ref.watch(accountTreeProvider)) {
    allAccounts
      ..add(accountNode.account)
      ..addAll(accountNode.descendants.map((node) => node.account));
  }
  return allAccounts;
}
