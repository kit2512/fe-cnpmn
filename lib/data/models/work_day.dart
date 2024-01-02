import 'package:json_annotation/json_annotation.dart';

part 'work_day.g.dart';

@JsonSerializable()
class WorkDay {
  const WorkDay({
    required this.startTime,
    required this.endTime,
    required this.totalHours,
    required this.punishmentHours,
  });

  factory WorkDay.fromJson(Map<String, dynamic> json) =>
      _$WorkDayFromJson(json);

  final String startTime;
  final String endTime;
  final double totalHours;
  final double punishmentHours;

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
        punishmentHours: punishmentHours ?? this.punishmentHours,
      );
}
