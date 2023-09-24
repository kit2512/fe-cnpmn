// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rfid_machine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RfidMachine _$RfidMachineFromJson(Map<String, dynamic> json) => RfidMachine(
      id: json['id'] as String,
      roomId: json['room_id'] as int,
      room: json['room'] == null
          ? null
          : Room.fromJson(json['room'] as Map<String, dynamic>),
      checkinHistory: (json['checkin_history'] as List<dynamic>?)
          ?.map((e) => CheckinHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RfidMachineToJson(RfidMachine instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'room': instance.room,
      'checkin_history': instance.checkinHistory,
    };
