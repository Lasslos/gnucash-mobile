import 'dart:convert';

import 'package:gnucash_mobile/core/models/account.dart';
import 'package:gnucash_mobile/util/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites.g.dart';

mixin FavoriteAccounts on AutoDisposeNotifier<List<Account>> {
  String get _sharedPreferencesKey;

  List<Account> _internBuild() {
    ref.listenSelf((previous, next) {
      if (previous != next) {
        _setCachedAccounts(next);
      }
    });
    return _getCachedAccounts();
  }

  List<Account> _getCachedAccounts() {
    String? json = sharedPreferences.getString(_sharedPreferencesKey);
    if (json == null) {
      return [];
    }
    List<dynamic> decoded = jsonDecode(json);
    return decoded.map((e) => Account.fromJson(e)).toList();
  }
  void _setCachedAccounts(List<Account> accounts) {
    sharedPreferences.setString(
      _sharedPreferencesKey,
      jsonEncode(accounts.map((e) => e.toJson()).toList()),
    );
  }

  void push(Account account) {
    state = [account, ...state.skipWhile((e) => e == account)].take(5).toList();
  }
  void clear() {
    state = [];
  }
}


@riverpod
class FirstAccountFavorites extends _$FirstAccountFavorites with FavoriteAccounts {
  @override
  String get _sharedPreferencesKey => 'firstAccountFavorites';
  @override
  List<Account> build() => _internBuild();
}

@riverpod
class SecondAccountFavorites extends _$SecondAccountFavorites with FavoriteAccounts {
  @override
  String get _sharedPreferencesKey => 'secondAccountFavorites';
  @override
  List<Account> build() => _internBuild();
}
