import 'package:json_annotation/json_annotation.dart';

part 'checkin_history.g.dart';

@JsonSerializable()
class CheckinHistory {
  const CheckinHistory({
    required this.id,
  });

  factory CheckinHistory.fromJson(Map<String, dynamic> json) => _$CheckinHistoryFromJson(json);

  final int id;

  Map<String, dynamic> toJson() => _$CheckinHistoryToJson(this);
}
