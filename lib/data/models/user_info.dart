import 'package:fe_cnpmn/enums/user_role_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  const UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateCreated,
    required this.username,
    required this.role,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  final int id;
  final String firstName;
  final String lastName;
  final DateTime dateCreated;
  final String username;
  final UserRole role;

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
