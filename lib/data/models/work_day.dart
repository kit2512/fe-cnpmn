import 'package:json_annotation/json_annotation.dart';

part 'work_day.g.dart';

@JsonSerializable()
class WorkDay {
  const WorkDay({
    required this.startTime,
    required this.endTime,
    required this.totalHours,
    required this.date,
  });

  factory WorkDay.fromJson(Map<String, dynamic> json) =>
      _$WorkDayFromJson(json);

  final String startTime;
  final String endTime;
  final double totalHours;
  final String date;

  WorkDay copyWith({
    String? startTime,
    String? endTime,
    double? totalHours,
    double? punishmentHours,
  }) =>
      WorkDay(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        totalHours: totalHours ?? this.totalHours,
        date: date,
      );
}

@JsonSerializable()
class WorkTime {
  const WorkTime({
    required this.startDate,
    required this.endDate,
    required this.totalHours,
    required this.punishmentHours,
    required this.workDays,
    required this.paidAmount,
  });

  factory WorkTime.fromJson(Map<String, dynamic> json) =>
      _$WorkTimeFromJson(json);
  final int paidAmount;
  final String startDate;
  final String endDate;
  final double totalHours;
  final double punishmentHours;
  final List<WorkDay> workDays;
}
