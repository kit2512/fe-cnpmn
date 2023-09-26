import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_cnpmn/data/models/form/name.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:formz/formz.dart';

part 'add_room_state.dart';

class AddRoomCubit extends Cubit<AddRoomState> {
  final RoomRepository roomRepository;

  AddRoomCubit({
    required this.roomRepository,
  }) : super(
          AddRoomState.initial(),
        );

  void onNameChanged(String? value) {
    if (value == null) return;
    emit(
      state.copyWith(name: Name.dirty(value)),
    );
  }

  Future<void> createRoom() async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
    ));
    final failureOrResponse = await roomRepository.createRoom(name: state.name.value);
    failureOrResponse.fold(
      (l) => emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: getErrorMessage(l),
        ),
      ),
      (room) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        );
      },
    );
  }
}
