
import 'package:fe_cnpmn/enums/day_off_type_enum.dart';
import 'package:flutter/material.dart';

class DayOffModel {

  DayOffModel({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.employeeId,
    required this.type,
  });

  factory DayOffModel.fromJson(Map<String, dynamic> json) => DayOffModel(
    id: json['id'] as int?,
    startDate: DateTime.parse(json['start_date'] as String),
    endDate: DateTime.parse(json['end_date'] as String),
    reason: json['reason'] as String,
    employeeId: json['employee_id'] as int,
    type: DayOffType.values.firstWhere((element) => element.name == json['type'] as String),
  );
  final int? id;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final int employeeId;
  final DayOffType type;


  Map<String, dynamic> toJson() => {
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'reason': reason,
    'employee_id': employeeId,
    'type': type.name,
    'id': id,
  };

  DateTimeRange get dateRange => DateTimeRange(
    start: startDate,
    end: endDate,
  );

  DayOffModel copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    int? employeeId,
    DayOffType? type,
  }) => DayOffModel(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    reason: reason ?? this.reason,
    employeeId: employeeId ?? this.employeeId,
    type: type ?? this.type,
  );

  bool get isValid => (startDate.isAtSameMomentAs(endDate) || startDate.isBefore(endDate)) && reason.isNotEmpty;
}