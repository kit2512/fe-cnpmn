// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckinHistory _$CheckinHistoryFromJson(Map<String, dynamic> json) =>
    CheckinHistory(
      id: json['id'] as int,
      rfidMachineId: json['rfid_machine_id'] as int,
      roomId: json['room_id'] as int,
      employeeId: json['employee_id'] as int,
      dateCreated: DateTime.parse(json['date_created'] as String),
      cardId: json['card_id'] as String?,
      room: json['room'] == null
          ? null
          : Room.fromJson(json['room'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckinHistoryToJson(CheckinHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rfid_machine_id': instance.rfidMachineId,
      'date_created': instance.dateCreated.toIso8601String(),
      'room_id': instance.roomId,
      'employee_id': instance.employeeId,
      'room': instance.room,
      'card_id': instance.cardId,
    };
