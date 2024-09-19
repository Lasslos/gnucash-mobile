// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      type: json['type'] as String,
      fullName: json['fullName'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String,
      color: json['color'] as String,
      notes: json['notes'] as String,
      commodityM: json['commodityM'] as String,
      commodityN: json['commodityN'] as String,
      hidden: json['hidden'] as bool,
      tax: json['tax'] as bool,
      placeholder: json['placeholder'] as bool,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      parentFullName: json['parentFullName'] as String?,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'fullName': instance.fullName,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'color': instance.color,
      'notes': instance.notes,
      'commodityM': instance.commodityM,
      'commodityN': instance.commodityN,
      'hidden': instance.hidden,
      'tax': instance.tax,
      'placeholder': instance.placeholder,
      'balance': instance.balance,
      'children': instance.children,
      'parentFullName': instance.parentFullName,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$validTransactionAccountsHash() =>
    r'bfe30421047afcb63d34e28a78d6adaae9abe44f';

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
String _$accountsHash() => r'fc02fe4bdb7ec2955ad1320df21b31fed57880d3';

/// Stores and exposes the accounts.
///
/// Copied from [Accounts].
@ProviderFor(Accounts)
final accountsProvider = NotifierProvider<Accounts, List<Account>>.internal(
  Accounts.new,
  name: r'accountsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Accounts = Notifier<List<Account>>;
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
