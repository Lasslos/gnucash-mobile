// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      date: DateTime.parse(json['date'] as String),
      id: json['id'] as String,
      description: json['description'] as String,
      notes: json['notes'] as String,
      commodityCurrency: json['commodityCurrency'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'id': instance.id,
      'description': instance.description,
      'notes': instance.notes,
      'commodityCurrency': instance.commodityCurrency,
      'amount': instance.amount,
    };
