// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkDay _$WorkDayFromJson(Map<String, dynamic> json) => WorkDay(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      totalHours: (json['total_hours'] as num).toDouble(),
      date: json['date'] as String,
      dayOff: json['day_off'] == null
          ? null
          : DayOffModel.fromJson(json['day_off'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkDayToJson(WorkDay instance) => <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'total_hours': instance.totalHours,
      'date': instance.date,
      'day_off': instance.dayOff,
    };

WorkTime _$WorkTimeFromJson(Map<String, dynamic> json) => WorkTime(
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      totalHours: (json['total_hours'] as num).toDouble(),
      punishmentHours: (json['punishment_hours'] as num).toDouble(),
      workDays: (json['work_days'] as List<dynamic>)
          .map((e) => WorkDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      paidAmount: json['paid_amount'] as int,
    );

Map<String, dynamic> _$WorkTimeToJson(WorkTime instance) => <String, dynamic>{
      'paid_amount': instance.paidAmount,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'total_hours': instance.totalHours,
      'punishment_hours': instance.punishmentHours,
      'work_days': instance.workDays,
    };
