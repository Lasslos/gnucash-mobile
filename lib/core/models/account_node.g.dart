// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountNodeImpl _$$AccountNodeImplFromJson(Map<String, dynamic> json) =>
    _$AccountNodeImpl(
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>)
          .map((e) => AccountNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountNodeImplToJson(_$AccountNodeImpl instance) =>
    <String, dynamic>{
      'account': instance.account,
      'children': instance.children,
    };
