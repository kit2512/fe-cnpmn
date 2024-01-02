// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkDay _$WorkDayFromJson(Map<String, dynamic> json) => WorkDay(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      totalHours: json['total_hours'] as double,
      punishmentHours: json['punishment_hours'] as double,
    );

Map<String, dynamic> _$WorkDayToJson(WorkDay instance) => <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'total_hours': instance.totalHours,
      'punishment_hours': instance.punishmentHours,
    };
