import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ErrorModel {
  ErrorModel({
    this.type,
    this.errors,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);

  final String? type;
  final List<ErrorDetail>? errors;

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ErrorDetail {
  ErrorDetail({
    required this.code,
    required this.detail,
    required this.attr,
  });

  factory ErrorDetail.fromJson(Map<String, dynamic> json) => _$ErrorDetailFromJson(json);

  final String? code;
  final String? detail;
  final String? attr;
}
