// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountListHash() => r'5ee1d97fecf2c2bf7f60234ceed97157e7f3f453';

/// See also [accountList].
@ProviderFor(accountList)
final accountListProvider = AutoDisposeProvider<List<Account>>.internal(
  accountList,
  name: r'accountListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AccountListRef = AutoDisposeProviderRef<List<Account>>;
String _$validTransactionAccountsHash() =>
    r'7cbbacd43a55ccc5207773ce783b9af653b3ce9a';

/// See also [validTransactionAccounts].
@ProviderFor(validTransactionAccounts)
final validTransactionAccountsProvider =
    AutoDisposeProvider<List<Account>>.internal(
  validTransactionAccounts,
  name: r'validTransactionAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$validTransactionAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ValidTransactionAccountsRef = AutoDisposeProviderRef<List<Account>>;
String _$accountTreeHash() => r'20177a930623a9ba1cc7e4f13e39b1c9f46cc9df';

/// Stores and exposes the accounts.
///
/// Copied from [AccountTree].
@ProviderFor(AccountTree)
final accountTreeProvider =
    NotifierProvider<AccountTree, List<AccountNode>>.internal(
  AccountTree.new,
  name: r'accountTreeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountTreeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountTree = Notifier<List<AccountNode>>;
String _$favoriteDebitAccountHash() =>
    r'30cfa8aabd644faea0c49155c1e53236d02cabe4';

/// See also [FavoriteDebitAccount].
@ProviderFor(FavoriteDebitAccount)
final favoriteDebitAccountProvider =
    AutoDisposeNotifierProvider<FavoriteDebitAccount, Account?>.internal(
  FavoriteDebitAccount.new,
  name: r'favoriteDebitAccountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteDebitAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FavoriteDebitAccount = AutoDisposeNotifier<Account?>;
String _$favoriteCreditAccountHash() =>
    r'83d6ad32486bf11d69764938671c7d30f327916c';

/// See also [FavoriteCreditAccount].
@ProviderFor(FavoriteCreditAccount)
final favoriteCreditAccountProvider =
    AutoDisposeNotifierProvider<FavoriteCreditAccount, Account?>.internal(
  FavoriteCreditAccount.new,
  name: r'favoriteCreditAccountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteCreditAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FavoriteCreditAccount = AutoDisposeNotifier<Account?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
