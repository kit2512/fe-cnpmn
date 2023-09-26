import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_cnpmn/data/models/room.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:formz/formz.dart';

part 'room_details_state.dart';

class RoomDetailsCubit extends Cubit<RoomDetailsState> {
  RoomDetailsCubit({
    required Room details,
    required this.roomRepository,
  }) : super(
          RoomDetailsState.initial().copyWith(
            room: details,
          ),
        );

  final RoomRepository roomRepository;
}
