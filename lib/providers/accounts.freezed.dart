// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounts.dart';

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
  String get type => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get commodityM => throw _privateConstructorUsedError;
  String get commodityN => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;
  bool get tax => throw _privateConstructorUsedError;
  bool get placeholder => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  List<Account> get children => throw _privateConstructorUsedError;
  String? get parentFullName => throw _privateConstructorUsedError;

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
      {String type,
      String fullName,
      String name,
      String code,
      String description,
      String color,
      String notes,
      String commodityM,
      String commodityN,
      bool hidden,
      bool tax,
      bool placeholder,
      double balance,
      List<Account> children,
      String? parentFullName});
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
    Object? code = null,
    Object? description = null,
    Object? color = null,
    Object? notes = null,
    Object? commodityM = null,
    Object? commodityN = null,
    Object? hidden = null,
    Object? tax = null,
    Object? placeholder = null,
    Object? balance = null,
    Object? children = null,
    Object? parentFullName = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      commodityM: null == commodityM
          ? _value.commodityM
          : commodityM // ignore: cast_nullable_to_non_nullable
              as String,
      commodityN: null == commodityN
          ? _value.commodityN
          : commodityN // ignore: cast_nullable_to_non_nullable
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
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<Account>,
      parentFullName: freezed == parentFullName
          ? _value.parentFullName
          : parentFullName // ignore: cast_nullable_to_non_nullable
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
      {String type,
      String fullName,
      String name,
      String code,
      String description,
      String color,
      String notes,
      String commodityM,
      String commodityN,
      bool hidden,
      bool tax,
      bool placeholder,
      double balance,
      List<Account> children,
      String? parentFullName});
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
    Object? code = null,
    Object? description = null,
    Object? color = null,
    Object? notes = null,
    Object? commodityM = null,
    Object? commodityN = null,
    Object? hidden = null,
    Object? tax = null,
    Object? placeholder = null,
    Object? balance = null,
    Object? children = null,
    Object? parentFullName = freezed,
  }) {
    return _then(_$AccountImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      commodityM: null == commodityM
          ? _value.commodityM
          : commodityM // ignore: cast_nullable_to_non_nullable
              as String,
      commodityN: null == commodityN
          ? _value.commodityN
          : commodityN // ignore: cast_nullable_to_non_nullable
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
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<Account>,
      parentFullName: freezed == parentFullName
          ? _value.parentFullName
          : parentFullName // ignore: cast_nullable_to_non_nullable
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
      required this.code,
      required this.description,
      required this.color,
      required this.notes,
      required this.commodityM,
      required this.commodityN,
      required this.hidden,
      required this.tax,
      required this.placeholder,
      this.balance = 0,
      this.children = const [],
      this.parentFullName})
      : super._();

  factory _$AccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountImplFromJson(json);

  @override
  final String type;
  @override
  final String fullName;
  @override
  final String name;
  @override
  final String code;
  @override
  final String description;
  @override
  final String color;
  @override
  final String notes;
  @override
  final String commodityM;
  @override
  final String commodityN;
  @override
  final bool hidden;
  @override
  final bool tax;
  @override
  final bool placeholder;
  @override
  @JsonKey()
  final double balance;
  @override
  @JsonKey()
  final List<Account> children;
  @override
  final String? parentFullName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Account(type: $type, fullName: $fullName, name: $name, code: $code, description: $description, color: $color, notes: $notes, commodityM: $commodityM, commodityN: $commodityN, hidden: $hidden, tax: $tax, placeholder: $placeholder, balance: $balance, children: $children, parentFullName: $parentFullName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Account'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('fullName', fullName))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('commodityM', commodityM))
      ..add(DiagnosticsProperty('commodityN', commodityN))
      ..add(DiagnosticsProperty('hidden', hidden))
      ..add(DiagnosticsProperty('tax', tax))
      ..add(DiagnosticsProperty('placeholder', placeholder))
      ..add(DiagnosticsProperty('balance', balance))
      ..add(DiagnosticsProperty('children', children))
      ..add(DiagnosticsProperty('parentFullName', parentFullName));
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
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.commodityM, commodityM) ||
                other.commodityM == commodityM) &&
            (identical(other.commodityN, commodityN) ||
                other.commodityN == commodityN) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.placeholder, placeholder) ||
                other.placeholder == placeholder) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            const DeepCollectionEquality().equals(other.children, children) &&
            (identical(other.parentFullName, parentFullName) ||
                other.parentFullName == parentFullName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      fullName,
      name,
      code,
      description,
      color,
      notes,
      commodityM,
      commodityN,
      hidden,
      tax,
      placeholder,
      balance,
      const DeepCollectionEquality().hash(children),
      parentFullName);

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
      {required final String type,
      required final String fullName,
      required final String name,
      required final String code,
      required final String description,
      required final String color,
      required final String notes,
      required final String commodityM,
      required final String commodityN,
      required final bool hidden,
      required final bool tax,
      required final bool placeholder,
      final double balance,
      final List<Account> children,
      final String? parentFullName}) = _$AccountImpl;
  const _Account._() : super._();

  factory _Account.fromJson(Map<String, dynamic> json) = _$AccountImpl.fromJson;

  @override
  String get type;
  @override
  String get fullName;
  @override
  String get name;
  @override
  String get code;
  @override
  String get description;
  @override
  String get color;
  @override
  String get notes;
  @override
  String get commodityM;
  @override
  String get commodityN;
  @override
  bool get hidden;
  @override
  bool get tax;
  @override
  bool get placeholder;
  @override
  double get balance;
  @override
  List<Account> get children;
  @override
  String? get parentFullName;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
