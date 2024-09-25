// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  /// The type of the account.
  AccountType get type => throw _privateConstructorUsedError;

  /// Fully qualified account name, separated by colons.
  ///
  /// Example: `Assets:Checking Account`
  String get fullName => throw _privateConstructorUsedError;

  /// Account name. [fullName] ends with [name].
  String get name => throw _privateConstructorUsedError;

  /// Currency symbol.
  ///
  /// Example: `EUR`, `USD`
  String get symbol => throw _privateConstructorUsedError;

  /// Commodity namespace.
  ///
  /// Example: `CURRENCY`, `STOCK`
  String get namespace => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;

  /// `true` if the account is a tax-relevant account.
  bool get tax => throw _privateConstructorUsedError;

  /// `true` if the account should not be used for transactions.
  bool get placeholder => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Color in ----- format. If empty, use #f0ecec.
  /// TODO: Add format and parsing for color.
  @Deprecated("Unfinished feature")
  String? get color => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {AccountType type,
      String fullName,
      String name,
      String symbol,
      String namespace,
      bool hidden,
      bool tax,
      bool placeholder,
      String? code,
      String? description,
      @Deprecated("Unfinished feature") String? color,
      String? notes});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? fullName = null,
    Object? name = null,
    Object? symbol = null,
    Object? namespace = null,
    Object? hidden = null,
    Object? tax = null,
    Object? placeholder = null,
    Object? code = freezed,
    Object? description = freezed,
    Object? color = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccountType,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      namespace: null == namespace
          ? _value.namespace
          : namespace // ignore: cast_nullable_to_non_nullable
              as String,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as bool,
      placeholder: null == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as bool,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AccountType type,
      String fullName,
      String name,
      String symbol,
      String namespace,
      bool hidden,
      bool tax,
      bool placeholder,
      String? code,
      String? description,
      @Deprecated("Unfinished feature") String? color,
      String? notes});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? fullName = null,
    Object? name = null,
    Object? symbol = null,
    Object? namespace = null,
    Object? hidden = null,
    Object? tax = null,
    Object? placeholder = null,
    Object? code = freezed,
    Object? description = freezed,
    Object? color = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$AccountImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccountType,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      namespace: null == namespace
          ? _value.namespace
          : namespace // ignore: cast_nullable_to_non_nullable
              as String,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
      tax: null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as bool,
      placeholder: null == placeholder
          ? _value.placeholder
          : placeholder // ignore: cast_nullable_to_non_nullable
              as bool,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountImpl extends _Account with DiagnosticableTreeMixin {
  const _$AccountImpl(
      {required this.type,
      required this.fullName,
      required this.name,
      required this.symbol,
      required this.namespace,
      required this.hidden,
      required this.tax,
      required this.placeholder,
      this.code,
      this.description,
      @Deprecated("Unfinished feature") this.color,
      this.notes})
      : super._();

  factory _$AccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountImplFromJson(json);

  /// The type of the account.
  @override
  final AccountType type;

  /// Fully qualified account name, separated by colons.
  ///
  /// Example: `Assets:Checking Account`
  @override
  final String fullName;

  /// Account name. [fullName] ends with [name].
  @override
  final String name;

  /// Currency symbol.
  ///
  /// Example: `EUR`, `USD`
  @override
  final String symbol;

  /// Commodity namespace.
  ///
  /// Example: `CURRENCY`, `STOCK`
  @override
  final String namespace;
  @override
  final bool hidden;

  /// `true` if the account is a tax-relevant account.
  @override
  final bool tax;

  /// `true` if the account should not be used for transactions.
  @override
  final bool placeholder;
  @override
  final String? code;
  @override
  final String? description;

  /// Color in ----- format. If empty, use #f0ecec.
  /// TODO: Add format and parsing for color.
  @override
  @Deprecated("Unfinished feature")
  final String? color;
  @override
  final String? notes;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Account(type: $type, fullName: $fullName, name: $name, symbol: $symbol, namespace: $namespace, hidden: $hidden, tax: $tax, placeholder: $placeholder, code: $code, description: $description, color: $color, notes: $notes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Account'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('fullName', fullName))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('symbol', symbol))
      ..add(DiagnosticsProperty('namespace', namespace))
      ..add(DiagnosticsProperty('hidden', hidden))
      ..add(DiagnosticsProperty('tax', tax))
      ..add(DiagnosticsProperty('placeholder', placeholder))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('notes', notes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.namespace, namespace) ||
                other.namespace == namespace) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, fullName, name, symbol,
      namespace, hidden, tax, placeholder, code, description, color, notes);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountImplToJson(
      this,
    );
  }
}

abstract class _Account extends Account {
  const factory _Account(
      {required final AccountType type,
      required final String fullName,
      required final String name,
      required final String symbol,
      required final String namespace,
      required final bool hidden,
      required final bool tax,
      required final bool placeholder,
      final String? code,
      final String? description,
      @Deprecated("Unfinished feature") final String? color,
      final String? notes}) = _$AccountImpl;
  const _Account._() : super._();

  factory _Account.fromJson(Map<String, dynamic> json) = _$AccountImpl.fromJson;

  /// The type of the account.
  @override
  AccountType get type;

  /// Fully qualified account name, separated by colons.
  ///
  /// Example: `Assets:Checking Account`
  @override
  String get fullName;

  /// Account name. [fullName] ends with [name].
  @override
  String get name;

  /// Currency symbol.
  ///
  /// Example: `EUR`, `USD`
  @override
  String get symbol;

  /// Commodity namespace.
  ///
  /// Example: `CURRENCY`, `STOCK`
  @override
  String get namespace;
  @override
  bool get hidden;

  /// `true` if the account is a tax-relevant account.
  @override
  bool get tax;

  /// `true` if the account should not be used for transactions.
  @override
  bool get placeholder;
  @override
  String? get code;
  @override
  String? get description;

  /// Color in ----- format. If empty, use #f0ecec.
  /// TODO: Add format and parsing for color.
  @override
  @Deprecated("Unfinished feature")
  String? get color;
  @override
  String? get notes;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AccountTransactionPair {
  Account get account => throw _privateConstructorUsedError;
  Transaction get transaction => throw _privateConstructorUsedError;

  /// Create a copy of AccountTransactionPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountTransactionPairCopyWith<AccountTransactionPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountTransactionPairCopyWith<$Res> {
  factory $AccountTransactionPairCopyWith(AccountTransactionPair value,
          $Res Function(AccountTransactionPair) then) =
      _$AccountTransactionPairCopyWithImpl<$Res, AccountTransactionPair>;
  @useResult
  $Res call({Account account, Transaction transaction});

  $AccountCopyWith<$Res> get account;
  $TransactionCopyWith<$Res> get transaction;
}

/// @nodoc
class _$AccountTransactionPairCopyWithImpl<$Res,
        $Val extends AccountTransactionPair>
    implements $AccountTransactionPairCopyWith<$Res> {
  _$AccountTransactionPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountTransactionPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? transaction = null,
  }) {
    return _then(_value.copyWith(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      transaction: null == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as Transaction,
    ) as $Val);
  }

  /// Create a copy of AccountTransactionPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountCopyWith<$Res> get account {
    return $AccountCopyWith<$Res>(_value.account, (value) {
      return _then(_value.copyWith(account: value) as $Val);
    });
  }

  /// Create a copy of AccountTransactionPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionCopyWith<$Res> get transaction {
    return $TransactionCopyWith<$Res>(_value.transaction, (value) {
      return _then(_value.copyWith(transaction: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountTransactionPairImplCopyWith<$Res>
    implements $AccountTransactionPairCopyWith<$Res> {
  factory _$$AccountTransactionPairImplCopyWith(
          _$AccountTransactionPairImpl value,
          $Res Function(_$AccountTransactionPairImpl) then) =
      __$$AccountTransactionPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Account account, Transaction transaction});

  @override
  $AccountCopyWith<$Res> get account;
  @override
  $TransactionCopyWith<$Res> get transaction;
}

/// @nodoc
class __$$AccountTransactionPairImplCopyWithImpl<$Res>
    extends _$AccountTransactionPairCopyWithImpl<$Res,
        _$AccountTransactionPairImpl>
    implements _$$AccountTransactionPairImplCopyWith<$Res> {
  __$$AccountTransactionPairImplCopyWithImpl(
      _$AccountTransactionPairImpl _value,
      $Res Function(_$AccountTransactionPairImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountTransactionPair
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? transaction = null,
  }) {
    return _then(_$AccountTransactionPairImpl(
      null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      null == transaction
          ? _value.transaction
          : transaction // ignore: cast_nullable_to_non_nullable
              as Transaction,
    ));
  }
}

/// @nodoc

class _$AccountTransactionPairImpl
    with DiagnosticableTreeMixin
    implements _AccountTransactionPair {
  _$AccountTransactionPairImpl(this.account, this.transaction);

  @override
  final Account account;
  @override
  final Transaction transaction;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountTransactionPair(account: $account, transaction: $transaction)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AccountTransactionPair'))
      ..add(DiagnosticsProperty('account', account))
      ..add(DiagnosticsProperty('transaction', transaction));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountTransactionPairImpl &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.transaction, transaction) ||
                other.transaction == transaction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, account, transaction);

  /// Create a copy of AccountTransactionPair
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountTransactionPairImplCopyWith<_$AccountTransactionPairImpl>
      get copyWith => __$$AccountTransactionPairImplCopyWithImpl<
          _$AccountTransactionPairImpl>(this, _$identity);
}

abstract class _AccountTransactionPair implements AccountTransactionPair {
  factory _AccountTransactionPair(
          final Account account, final Transaction transaction) =
      _$AccountTransactionPairImpl;

  @override
  Account get account;
  @override
  Transaction get transaction;

  /// Create a copy of AccountTransactionPair
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountTransactionPairImplCopyWith<_$AccountTransactionPairImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DoubleEntryTransaction {
  AccountTransactionPair get first => throw _privateConstructorUsedError;
  AccountTransactionPair get second => throw _privateConstructorUsedError;

  /// Create a copy of DoubleEntryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoubleEntryTransactionCopyWith<DoubleEntryTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoubleEntryTransactionCopyWith<$Res> {
  factory $DoubleEntryTransactionCopyWith(DoubleEntryTransaction value,
          $Res Function(DoubleEntryTransaction) then) =
      _$DoubleEntryTransactionCopyWithImpl<$Res, DoubleEntryTransaction>;
  @useResult
  $Res call({AccountTransactionPair first, AccountTransactionPair second});

  $AccountTransactionPairCopyWith<$Res> get first;
  $AccountTransactionPairCopyWith<$Res> get second;
}

/// @nodoc
class _$DoubleEntryTransactionCopyWithImpl<$Res,
        $Val extends DoubleEntryTransaction>
    implements $DoubleEntryTransactionCopyWith<$Res> {
  _$DoubleEntryTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoubleEntryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? first = null,
    Object? second = null,
  }) {
    return _then(_value.copyWith(
      first: null == first
          ? _value.first
          : first // ignore: cast_nullable_to_non_nullable
              as AccountTransactionPair,
      second: null == second
          ? _value.second
          : second // ignore: cast_nullable_to_non_nullable
              as AccountTransactionPair,
    ) as $Val);
  }

  /// Create a copy of DoubleEntryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountTransactionPairCopyWith<$Res> get first {
    return $AccountTransactionPairCopyWith<$Res>(_value.first, (value) {
      return _then(_value.copyWith(first: value) as $Val);
    });
  }

  /// Create a copy of DoubleEntryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountTransactionPairCopyWith<$Res> get second {
    return $AccountTransactionPairCopyWith<$Res>(_value.second, (value) {
      return _then(_value.copyWith(second: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DoubleEntryTransactionImplCopyWith<$Res>
    implements $DoubleEntryTransactionCopyWith<$Res> {
  factory _$$DoubleEntryTransactionImplCopyWith(
          _$DoubleEntryTransactionImpl value,
          $Res Function(_$DoubleEntryTransactionImpl) then) =
      __$$DoubleEntryTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AccountTransactionPair first, AccountTransactionPair second});

  @override
  $AccountTransactionPairCopyWith<$Res> get first;
  @override
  $AccountTransactionPairCopyWith<$Res> get second;
}

/// @nodoc
class __$$DoubleEntryTransactionImplCopyWithImpl<$Res>
    extends _$DoubleEntryTransactionCopyWithImpl<$Res,
        _$DoubleEntryTransactionImpl>
    implements _$$DoubleEntryTransactionImplCopyWith<$Res> {
  __$$DoubleEntryTransactionImplCopyWithImpl(
      _$DoubleEntryTransactionImpl _value,
      $Res Function(_$DoubleEntryTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DoubleEntryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? first = null,
    Object? second = null,
  }) {
    return _then(_$DoubleEntryTransactionImpl(
      null == first
          ? _value.first
          : first // ignore: cast_nullable_to_non_nullable
              as AccountTransactionPair,
      null == second
          ? _value.second
          : second // ignore: cast_nullable_to_non_nullable
              as AccountTransactionPair,
    ));
  }
}

/// @nodoc

class _$DoubleEntryTransactionImpl
    with DiagnosticableTreeMixin
    implements _DoubleEntryTransaction {
  _$DoubleEntryTransactionImpl(this.first, this.second);

  @override
  final AccountTransactionPair first;
  @override
  final AccountTransactionPair second;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DoubleEntryTransaction(first: $first, second: $second)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DoubleEntryTransaction'))
      ..add(DiagnosticsProperty('first', first))
      ..add(DiagnosticsProperty('second', second));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoubleEntryTransactionImpl &&
            (identical(other.first, first) || other.first == first) &&
            (identical(other.second, second) || other.second == second));
  }

  @override
  int get hashCode => Object.hash(runtimeType, first, second);

  /// Create a copy of DoubleEntryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoubleEntryTransactionImplCopyWith<_$DoubleEntryTransactionImpl>
      get copyWith => __$$DoubleEntryTransactionImplCopyWithImpl<
          _$DoubleEntryTransactionImpl>(this, _$identity);
}

abstract class _DoubleEntryTransaction implements DoubleEntryTransaction {
  factory _DoubleEntryTransaction(final AccountTransactionPair first,
      final AccountTransactionPair second) = _$DoubleEntryTransactionImpl;

  @override
  AccountTransactionPair get first;
  @override
  AccountTransactionPair get second;

  /// Create a copy of DoubleEntryTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoubleEntryTransactionImplCopyWith<_$DoubleEntryTransactionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
