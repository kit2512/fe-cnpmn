import 'package:fe_cnpmn/data/models/room.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkin_history.g.dart';

@JsonSerializable()
class CheckinHistory {
  const CheckinHistory({
    required this.id,
    required this.rfidMachineId,
    required this.roomId,
    required this.employeeId,
    required this.dateCreated,
    this.cardId,
    this.room
  });

  factory CheckinHistory.fromJson(Map<String, dynamic> json) => _$CheckinHistoryFromJson(json);

  final int id;
  final int rfidMachineId;
  final DateTime dateCreated;
  final int roomId;
  final int employeeId;

  final Room? room;

  final String? cardId;


  Map<String, dynamic> toJson() => _$CheckinHistoryToJson(this);
}
