part of 'add_room_cubit.dart';

class AddRoomState extends Equatable with FormzMixin {
  const AddRoomState({
    required this.status,
    required this.name,
    required this.errorMessage,
  });

  factory AddRoomState.initial() => const AddRoomState(
        status: FormzSubmissionStatus.initial,
        name: Name.pure(),
    errorMessage: ''
      );

  final Name name;
  final FormzSubmissionStatus status;
  final String errorMessage;

  AddRoomState copyWith({
    FormzSubmissionStatus? status,
    Name? name,
    String? errorMessage,
  }) =>
      AddRoomState(
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        name: name ?? this.name,
      );

  @override
  List<FormzInput> get inputs => [name];

  @override
  List<Object?> get props => [status, name, errorMessage];
}
