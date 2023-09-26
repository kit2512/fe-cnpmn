part of 'room_details_cubit.dart';

class RoomDetailsState extends Equatable {
  const RoomDetailsState({
    required this.detailStatus,
    required this.errorMessage,
    this.room,
  });

  factory RoomDetailsState.initial() => const RoomDetailsState(
        detailStatus: FormzSubmissionStatus.initial,
        errorMessage: '',
      );

  @override
  List<Object?> get props => [
        detailStatus,
        errorMessage,
        room,
      ];

  final FormzSubmissionStatus detailStatus;
  final Room? room;
  final String errorMessage;

  RoomDetailsState copyWith({
    FormzSubmissionStatus? detailStatus,
    Room? room,
    String? errorMessage,
  }) =>
      RoomDetailsState(
        detailStatus: detailStatus ?? this.detailStatus,
        room: room ?? this.room,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
