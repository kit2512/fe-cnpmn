// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as int,
      name: json['name'] as String,
      dateCreated: DateTime.parse(json['date_created'] as String),
      allowedEmployees: (json['allowed_employees'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList(),
      rfidMachines: (json['rfid_machines'] as List<dynamic>?)
          ?.map((e) => RfidMachine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'allowed_employees': instance.allowedEmployees,
      'rfid_machines': instance.rfidMachines,
      'date_created': instance.dateCreated.toIso8601String(),
    };
