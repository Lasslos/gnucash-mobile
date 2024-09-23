// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsCSVHash() => r'f8bd16881a9d8efb209dcd0a2676726c214b69e4';

/// See also [transactionsCSV].
@ProviderFor(transactionsCSV)
final transactionsCSVProvider = AutoDisposeProvider<String>.internal(
  transactionsCSV,
  name: r'transactionsCSVProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsCSVHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TransactionsCSVRef = AutoDisposeProviderRef<String>;
String _$transactionsHash() => r'9295c82271f26f181b613cd439cc511782609a4a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Transactions extends BuildlessNotifier<List<Transaction>> {
  late final Account account;

  List<Transaction> build(
    Account account,
  );
}

/// See also [Transactions].
@ProviderFor(Transactions)
const transactionsProvider = TransactionsFamily();

/// See also [Transactions].
class TransactionsFamily extends Family<List<Transaction>> {
  /// See also [Transactions].
  const TransactionsFamily();

  /// See also [Transactions].
  TransactionsProvider call(
    Account account,
  ) {
    return TransactionsProvider(
      account,
    );
  }

  @override
  TransactionsProvider getProviderOverride(
    covariant TransactionsProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionsProvider';
}

/// See also [Transactions].
class TransactionsProvider
    extends NotifierProviderImpl<Transactions, List<Transaction>> {
  /// See also [Transactions].
  TransactionsProvider(
    Account account,
  ) : this._internal(
          () => Transactions()..account = account,
          from: transactionsProvider,
          name: r'transactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionsHash,
          dependencies: TransactionsFamily._dependencies,
          allTransitiveDependencies:
              TransactionsFamily._allTransitiveDependencies,
          account: account,
        );

  TransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final Account account;

  @override
  List<Transaction> runNotifierBuild(
    covariant Transactions notifier,
  ) {
    return notifier.build(
      account,
    );
  }

  @override
  Override overrideWith(Transactions Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransactionsProvider._internal(
        () => create()..account = account,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
      ),
    );
  }

  @override
  NotifierProviderElement<Transactions, List<Transaction>> createElement() {
    return _TransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TransactionsRef on NotifierProviderRef<List<Transaction>> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _TransactionsProviderElement
    extends NotifierProviderElement<Transactions, List<Transaction>>
    with TransactionsRef {
  _TransactionsProviderElement(super.provider);

  @override
  Account get account => (origin as TransactionsProvider).account;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
