// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      type: AccountType.fromJson(json['type'] as String),
      fullName: json['fullName'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      namespace: json['namespace'] as String,
      hidden: json['hidden'] as bool,
      tax: json['tax'] as bool,
      placeholder: json['placeholder'] as bool,
      code: json['code'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'fullName': instance.fullName,
      'name': instance.name,
      'symbol': instance.symbol,
      'namespace': instance.namespace,
      'hidden': instance.hidden,
      'tax': instance.tax,
      'placeholder': instance.placeholder,
      'code': instance.code,
      'description': instance.description,
      'color': instance.color,
      'notes': instance.notes,
    };
