part of 'rooms_cubit.dart';

class RoomsState extends Equatable {
  const RoomsState({
    required this.status,
    required this.rooms,
    required this.errorMessage,
    this.selectedEmployee,
  });

  factory RoomsState.initial() => const RoomsState(
        status: FormzSubmissionStatus.initial,
        rooms: [],
        errorMessage: '',
      );

  final FormzSubmissionStatus status;
  final List<Room> rooms;
  final String errorMessage;
  final int? selectedEmployee;

  @override
  List<Object?> get props => [
        rooms,
        status,
        errorMessage,
      ];

  RoomsState copyWith({
    FormzSubmissionStatus? status,
    List<Room>? rooms,
    String? errorMessage,
    int? selectedEmployee,
    bool clearSelection = false,
  }) =>
      RoomsState(
        selectedEmployee: clearSelection ? null : selectedEmployee ?? this.selectedEmployee,
        status: status ?? this.status,
        rooms: rooms ?? this.rooms,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
