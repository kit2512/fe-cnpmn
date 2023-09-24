import 'package:fe_cnpmn/data/models/rfid_machine.dart';
import 'package:json_annotation/json_annotation.dart';

import 'checkin_history.dart';
import 'employee.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  const Room({
    required this.id,
    required this.name,
    required this.dateCreated,
    this.allowedEmployees,
    this.rfidMachines,

  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  final int id;
  final String name;
  final List<Employee>? allowedEmployees;
  final List<RfidMachine>? rfidMachines;
  final DateTime dateCreated;

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
