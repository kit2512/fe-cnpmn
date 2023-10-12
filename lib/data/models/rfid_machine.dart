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
    required this.name,
    required this.allowCheckin,
    this.room,
    this.checkinHistory,
  });

  factory RfidMachine.fromJson(Map<String, dynamic> json) => _$RfidMachineFromJson(json);

  final int id;
  final int roomId;
  final Room? room;

  final String name;
  final List<CheckinHistory>? checkinHistory;
  final DateTime dateCreated;

  final bool allowCheckin;



  Map<String, dynamic> toJson() => _$RfidMachineToJson(this);
}
