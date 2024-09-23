// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccountNode _$AccountNodeFromJson(Map<String, dynamic> json) {
  return _AccountNode.fromJson(json);
}

/// @nodoc
mixin _$AccountNode {
  Account get account => throw _privateConstructorUsedError;
  List<AccountNode> get children => throw _privateConstructorUsedError;

  /// Serializes this AccountNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountNodeCopyWith<AccountNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountNodeCopyWith<$Res> {
  factory $AccountNodeCopyWith(
          AccountNode value, $Res Function(AccountNode) then) =
      _$AccountNodeCopyWithImpl<$Res, AccountNode>;
  @useResult
  $Res call({Account account, List<AccountNode> children});

  $AccountCopyWith<$Res> get account;
}

/// @nodoc
class _$AccountNodeCopyWithImpl<$Res, $Val extends AccountNode>
    implements $AccountNodeCopyWith<$Res> {
  _$AccountNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? children = null,
  }) {
    return _then(_value.copyWith(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<AccountNode>,
    ) as $Val);
  }

  /// Create a copy of AccountNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountCopyWith<$Res> get account {
    return $AccountCopyWith<$Res>(_value.account, (value) {
      return _then(_value.copyWith(account: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountNodeImplCopyWith<$Res>
    implements $AccountNodeCopyWith<$Res> {
  factory _$$AccountNodeImplCopyWith(
          _$AccountNodeImpl value, $Res Function(_$AccountNodeImpl) then) =
      __$$AccountNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Account account, List<AccountNode> children});

  @override
  $AccountCopyWith<$Res> get account;
}

/// @nodoc
class __$$AccountNodeImplCopyWithImpl<$Res>
    extends _$AccountNodeCopyWithImpl<$Res, _$AccountNodeImpl>
    implements _$$AccountNodeImplCopyWith<$Res> {
  __$$AccountNodeImplCopyWithImpl(
      _$AccountNodeImpl _value, $Res Function(_$AccountNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
    Object? children = null,
  }) {
    return _then(_$AccountNodeImpl(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<AccountNode>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountNodeImpl extends _AccountNode with DiagnosticableTreeMixin {
  const _$AccountNodeImpl({required this.account, required this.children})
      : super._();

  factory _$AccountNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountNodeImplFromJson(json);

  @override
  final Account account;
  @override
  final List<AccountNode> children;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountNode(account: $account, children: $children)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AccountNode'))
      ..add(DiagnosticsProperty('account', account))
      ..add(DiagnosticsProperty('children', children));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountNodeImpl &&
            (identical(other.account, account) || other.account == account) &&
            const DeepCollectionEquality().equals(other.children, children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, account, const DeepCollectionEquality().hash(children));

  /// Create a copy of AccountNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountNodeImplCopyWith<_$AccountNodeImpl> get copyWith =>
      __$$AccountNodeImplCopyWithImpl<_$AccountNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountNodeImplToJson(
      this,
    );
  }
}

abstract class _AccountNode extends AccountNode {
  const factory _AccountNode(
      {required final Account account,
      required final List<AccountNode> children}) = _$AccountNodeImpl;
  const _AccountNode._() : super._();

  factory _AccountNode.fromJson(Map<String, dynamic> json) =
      _$AccountNodeImpl.fromJson;

  @override
  Account get account;
  @override
  List<AccountNode> get children;

  /// Create a copy of AccountNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountNodeImplCopyWith<_$AccountNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
