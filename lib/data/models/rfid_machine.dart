import 'package:fe_cnpmn/data/models/checkin_history.dart';
import 'package:fe_cnpmn/data/models/room.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rfid_machine.g.dart';

@JsonSerializable()
class RfidMachine {
  const RfidMachine({
    required this.id,
    required this.roomId,
    required this.dateCreated,
    this.room,
    this.checkinHistory,
  });

  final int id;
  final int roomId;
  final Room? room;
  final List<CheckinHistory>? checkinHistory;
  final DateTime dateCreated;

  factory RfidMachine.fromJson(Map<String, dynamic> json) => _$RfidMachineFromJson(json);

  Map<String, dynamic> toJson() => _$RfidMachineToJson(this);
}
