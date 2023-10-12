// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RfidCard _$RfidCardFromJson(Map<String, dynamic> json) => RfidCard(
      id: json['id'] as String,
      dateCreated: DateTime.parse(json['date_created'] as String),
      employeeId: json['employee_id'] as int?,
    );

Map<String, dynamic> _$RfidCardToJson(RfidCard instance) => <String, dynamic>{
      'date_created': instance.dateCreated.toIso8601String(),
      'employee_id': instance.employeeId,
      'id': instance.id,
    };
