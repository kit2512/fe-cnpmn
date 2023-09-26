import 'package:another_flushbar/flushbar.dart';
import 'package:fe_cnpmn/data/models/form/name.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/pages/rooms_page/cubit/add_room_cubit/add_room_cubit.dart';
import 'package:fe_cnpmn/pages/widgets/name_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class AddRoomDialog extends StatelessWidget {
  const AddRoomDialog({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<AddRoomCubit>(
        create: (context) => AddRoomCubit(
          roomRepository: getIt<RoomRepository>(),
        ),
        child: const _AddRoomDialogView(),
      );
}

class _AddRoomDialogView extends StatelessWidget {
  const _AddRoomDialogView({super.key});

  @override
  Widget build(BuildContext context) => BlocConsumer<AddRoomCubit, AddRoomState>(
        listenWhen: (prev, current) => current.status != prev.status,
        listener: (context, state) {
          if (state.status.isFailure) {
            Flushbar<void>(
              backgroundColor: Colors.red,
              title: 'Error',
              message: state.errorMessage,
              duration: const Duration(seconds: 3),
            ).show(context);
          }
          if (state.status.isSuccess) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) => AlertDialog(
          title: const Text('Add Room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NameInput(
                validator: (_) =>
                    (state.name.isNotValid && state.name.error != null) ? Name.getError(state.name.error!) : null,
                onChanged: context.read<AddRoomCubit>().onNameChanged,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: (state.isValid && !state.status.isInProgress) ? context.read<AddRoomCubit>().createRoom : null,
              child: state.status.isInProgress ? const CircularProgressIndicator.adaptive() : const Text('Add'),
            ),
          ],
        ),
      );
}
