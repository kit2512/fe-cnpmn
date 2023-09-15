// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userInfo: UserInfo.fromJson(json['user_info'] as Map<String, dynamic>),
      checkinHistory: (json['checkin_history'] as List<dynamic>)
          .map((e) => CheckinHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowedRooms: (json['allowed_rooms'] as List<dynamic>)
          .map((e) => Room.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'user_info': instance.userInfo,
      'checkin_history': instance.checkinHistory,
      'allowed_rooms': instance.allowedRooms,
    };
