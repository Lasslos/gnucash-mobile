// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      date: json['date'] as String,
      id: json['id'] as String,
      number: (json['number'] as num?)?.toInt(),
      description: json['description'] as String,
      notes: json['notes'] as String,
      commodityCurrency: json['commodityCurrency'] as String,
      voidReason: json['voidReason'] as String,
      action: json['action'] as String,
      memo: json['memo'] as String,
      fullAccountName: json['fullAccountName'] as String,
      accountName: json['accountName'] as String,
      amountWithSymbol: json['amountWithSymbol'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      reconcile: json['reconcile'] as String,
      reconcileDate: json['reconcileDate'] as String,
      ratePrice: (json['ratePrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'id': instance.id,
      'number': instance.number,
      'description': instance.description,
      'notes': instance.notes,
      'commodityCurrency': instance.commodityCurrency,
      'voidReason': instance.voidReason,
      'action': instance.action,
      'memo': instance.memo,
      'fullAccountName': instance.fullAccountName,
      'accountName': instance.accountName,
      'amountWithSymbol': instance.amountWithSymbol,
      'amount': instance.amount,
      'reconcile': instance.reconcile,
      'reconcileDate': instance.reconcileDate,
      'ratePrice': instance.ratePrice,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsByAccountFullNameHash() =>
    r'0300dabe786db679e9a28296f5924ebfef20928e';

/// See also [transactionsByAccountFullName].
@ProviderFor(transactionsByAccountFullName)
final transactionsByAccountFullNameProvider =
    AutoDisposeProvider<Map<String, List<Transaction>>>.internal(
  transactionsByAccountFullName,
  name: r'transactionsByAccountFullNameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsByAccountFullNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TransactionsByAccountFullNameRef
    = AutoDisposeProviderRef<Map<String, List<Transaction>>>;
String _$transactionsHash() => r'3a32dad029fff24ea3e2af51357755c3f20db154';

/// See also [Transactions].
@ProviderFor(Transactions)
final transactionsProvider =
    AutoDisposeNotifierProvider<Transactions, List<Transaction>>.internal(
  Transactions.new,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Transactions = AutoDisposeNotifier<List<Transaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
