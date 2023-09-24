import 'package:equatable/equatable.dart';
import 'package:fe_cnpmn/data/models/room.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit({
    required this.roomRepository,
  }) : super(
          RoomsState.initial(),
        );

  final RoomRepository roomRepository;

  Future<void> getRooms({
    bool refresh = true,
  }) async {
    if (refresh) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
    }
    final failureOrResponse = await roomRepository.getRooms();
    failureOrResponse.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: getErrorMessage(failure),
          ),
        );
      },
      (rooms) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            rooms: rooms,
          ),
        );
      },
    );
  }
}
