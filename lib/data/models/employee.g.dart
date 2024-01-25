// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      checkinHistory: (json['checkin_history'] as List<dynamic>)
          .map((e) => CheckinHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      allowedRooms: (json['allowed_rooms'] as List<dynamic>)
          .map((e) => Room.fromJson(e as Map<String, dynamic>))
          .toList(),
      card: json['card'] == null
          ? null
          : RfidCard.fromJson(json['card'] as Map<String, dynamic>),
      salary: json['salary'] as int,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'card': instance.card,
      'id': instance.id,
      'user_id': instance.userId,
      'user': instance.user,
      'salary': instance.salary,
      'checkin_history': instance.checkinHistory,
      'allowed_rooms': instance.allowedRooms,
    };
