import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class RfidCard {
  const RfidCard({
    required this.id,
    required this.dateCreated,
    this.employeeId,
  });

  factory RfidCard.fromJson(Map<String, dynamic> json) => _$RfidCardFromJson(json);

  final DateTime dateCreated;
  final int? employeeId;
  final String id;

  Map<String, dynamic> toJson() => _$RfidCardToJson(this);
}
