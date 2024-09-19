// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  String get date => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  int? get number => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get commodityCurrency => throw _privateConstructorUsedError;
  String get voidReason => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  String get fullAccountName => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get amountWithSymbol => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  String get reconcile => throw _privateConstructorUsedError;
  String get reconcileDate => throw _privateConstructorUsedError;
  int? get ratePrice => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {String date,
      String id,
      int? number,
      String description,
      String notes,
      String commodityCurrency,
      String voidReason,
      String action,
      String memo,
      String fullAccountName,
      String accountName,
      String amountWithSymbol,
      double? amount,
      String reconcile,
      String reconcileDate,
      int? ratePrice});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? id = null,
    Object? number = freezed,
    Object? description = null,
    Object? notes = null,
    Object? commodityCurrency = null,
    Object? voidReason = null,
    Object? action = null,
    Object? memo = null,
    Object? fullAccountName = null,
    Object? accountName = null,
    Object? amountWithSymbol = null,
    Object? amount = freezed,
    Object? reconcile = null,
    Object? reconcileDate = null,
    Object? ratePrice = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      commodityCurrency: null == commodityCurrency
          ? _value.commodityCurrency
          : commodityCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      voidReason: null == voidReason
          ? _value.voidReason
          : voidReason // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      fullAccountName: null == fullAccountName
          ? _value.fullAccountName
          : fullAccountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      amountWithSymbol: null == amountWithSymbol
          ? _value.amountWithSymbol
          : amountWithSymbol // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      reconcile: null == reconcile
          ? _value.reconcile
          : reconcile // ignore: cast_nullable_to_non_nullable
              as String,
      reconcileDate: null == reconcileDate
          ? _value.reconcileDate
          : reconcileDate // ignore: cast_nullable_to_non_nullable
              as String,
      ratePrice: freezed == ratePrice
          ? _value.ratePrice
          : ratePrice // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      String id,
      int? number,
      String description,
      String notes,
      String commodityCurrency,
      String voidReason,
      String action,
      String memo,
      String fullAccountName,
      String accountName,
      String amountWithSymbol,
      double? amount,
      String reconcile,
      String reconcileDate,
      int? ratePrice});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? id = null,
    Object? number = freezed,
    Object? description = null,
    Object? notes = null,
    Object? commodityCurrency = null,
    Object? voidReason = null,
    Object? action = null,
    Object? memo = null,
    Object? fullAccountName = null,
    Object? accountName = null,
    Object? amountWithSymbol = null,
    Object? amount = freezed,
    Object? reconcile = null,
    Object? reconcileDate = null,
    Object? ratePrice = freezed,
  }) {
    return _then(_$TransactionImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      commodityCurrency: null == commodityCurrency
          ? _value.commodityCurrency
          : commodityCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      voidReason: null == voidReason
          ? _value.voidReason
          : voidReason // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      fullAccountName: null == fullAccountName
          ? _value.fullAccountName
          : fullAccountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      amountWithSymbol: null == amountWithSymbol
          ? _value.amountWithSymbol
          : amountWithSymbol // ignore: cast_nullable_to_non_nullable
              as String,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      reconcile: null == reconcile
          ? _value.reconcile
          : reconcile // ignore: cast_nullable_to_non_nullable
              as String,
      reconcileDate: null == reconcileDate
          ? _value.reconcileDate
          : reconcileDate // ignore: cast_nullable_to_non_nullable
              as String,
      ratePrice: freezed == ratePrice
          ? _value.ratePrice
          : ratePrice // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl extends _Transaction with DiagnosticableTreeMixin {
  const _$TransactionImpl(
      {required this.date,
      required this.id,
      required this.number,
      required this.description,
      required this.notes,
      required this.commodityCurrency,
      required this.voidReason,
      required this.action,
      required this.memo,
      required this.fullAccountName,
      required this.accountName,
      required this.amountWithSymbol,
      required this.amount,
      required this.reconcile,
      required this.reconcileDate,
      required this.ratePrice})
      : super._();

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final String date;
  @override
  final String id;
  @override
  final int? number;
  @override
  final String description;
  @override
  final String notes;
  @override
  final String commodityCurrency;
  @override
  final String voidReason;
  @override
  final String action;
  @override
  final String memo;
  @override
  final String fullAccountName;
  @override
  final String accountName;
  @override
  final String amountWithSymbol;
  @override
  final double? amount;
  @override
  final String reconcile;
  @override
  final String reconcileDate;
  @override
  final int? ratePrice;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Transaction(date: $date, id: $id, number: $number, description: $description, notes: $notes, commodityCurrency: $commodityCurrency, voidReason: $voidReason, action: $action, memo: $memo, fullAccountName: $fullAccountName, accountName: $accountName, amountWithSymbol: $amountWithSymbol, amount: $amount, reconcile: $reconcile, reconcileDate: $reconcileDate, ratePrice: $ratePrice)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Transaction'))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('number', number))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('commodityCurrency', commodityCurrency))
      ..add(DiagnosticsProperty('voidReason', voidReason))
      ..add(DiagnosticsProperty('action', action))
      ..add(DiagnosticsProperty('memo', memo))
      ..add(DiagnosticsProperty('fullAccountName', fullAccountName))
      ..add(DiagnosticsProperty('accountName', accountName))
      ..add(DiagnosticsProperty('amountWithSymbol', amountWithSymbol))
      ..add(DiagnosticsProperty('amount', amount))
      ..add(DiagnosticsProperty('reconcile', reconcile))
      ..add(DiagnosticsProperty('reconcileDate', reconcileDate))
      ..add(DiagnosticsProperty('ratePrice', ratePrice));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.commodityCurrency, commodityCurrency) ||
                other.commodityCurrency == commodityCurrency) &&
            (identical(other.voidReason, voidReason) ||
                other.voidReason == voidReason) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.fullAccountName, fullAccountName) ||
                other.fullAccountName == fullAccountName) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.amountWithSymbol, amountWithSymbol) ||
                other.amountWithSymbol == amountWithSymbol) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.reconcile, reconcile) ||
                other.reconcile == reconcile) &&
            (identical(other.reconcileDate, reconcileDate) ||
                other.reconcileDate == reconcileDate) &&
            (identical(other.ratePrice, ratePrice) ||
                other.ratePrice == ratePrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      id,
      number,
      description,
      notes,
      commodityCurrency,
      voidReason,
      action,
      memo,
      fullAccountName,
      accountName,
      amountWithSymbol,
      amount,
      reconcile,
      reconcileDate,
      ratePrice);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction extends Transaction {
  const factory _Transaction(
      {required final String date,
      required final String id,
      required final int? number,
      required final String description,
      required final String notes,
      required final String commodityCurrency,
      required final String voidReason,
      required final String action,
      required final String memo,
      required final String fullAccountName,
      required final String accountName,
      required final String amountWithSymbol,
      required final double? amount,
      required final String reconcile,
      required final String reconcileDate,
      required final int? ratePrice}) = _$TransactionImpl;
  const _Transaction._() : super._();

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  String get date;
  @override
  String get id;
  @override
  int? get number;
  @override
  String get description;
  @override
  String get notes;
  @override
  String get commodityCurrency;
  @override
  String get voidReason;
  @override
  String get action;
  @override
  String get memo;
  @override
  String get fullAccountName;
  @override
  String get accountName;
  @override
  String get amountWithSymbol;
  @override
  double? get amount;
  @override
  String get reconcile;
  @override
  String get reconcileDate;
  @override
  int? get ratePrice;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
