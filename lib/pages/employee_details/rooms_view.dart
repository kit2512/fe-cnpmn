import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import 'package:fe_cnpmn/data/models/room.dart';

import '../room_details/room_details_page.dart';
import 'assign_room_dialog.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({
    super.key,
    required this.employeeId,
  });

  final int employeeId;

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  @override
  void initState() {
    _getRooms();
    super.initState();
  }

  final RoomRepository roomRepository = getIt<RoomRepository>();

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;
  late List<Room> _rooms;

  Future<void> _getRooms() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse =
        await roomRepository.getRooms(employeeId: widget.employeeId);
    failureOrResponse.fold(
      (l) => setState(() {
        _status = FormzSubmissionStatus.failure;
      }),
      (r) => setState(() {
        _status = FormzSubmissionStatus.success;
        _rooms = r;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_status.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to get rooms, please try again'),
            const SizedBox(
              height: 12.0,
            ),
            ElevatedButton(onPressed: _getRooms, child: const Text('Refresh'))
          ],
        ),
      );
    }
    if (_status.isSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: _getRooms,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
              ),
              TextButton.icon(
                onPressed: _assignRoomsToEmployee,
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text('Assign rooms'),
              ),
            ],
          ),
          Expanded(
            child: _rooms.isEmpty
                ? const Center(
                    child: Text('No Rooms'),
                  )
                : DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(
                        label: Text('ID'),
                      ),
                      DataColumn(
                        label: Text('Name'),
                      )
                    ],
                    rows: _rooms
                        .map(
                          (e) => DataRow(
                            onSelectChanged: (_) {
                              Navigator.of(context).push(
                                RoomDetailsPage.route(details: e),
                              );
                            },
                            cells: [
                              DataCell(Text(e.id.toString())),
                              DataCell(
                                Text(e.name),
                              ),
                            ],
                          ),
                        )
                        .toList(growable: false),
                  ),
          ),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Future<void> _assignRoomsToEmployee() async {
    final success = await showDialog<bool?>(
      context: context,
      builder: (context) => AssignRoomDialog(
        employeeId: widget.employeeId,
        currentAssignedRooms: _rooms,
      ),
    );
    if (success == true) {
      await _getRooms();
    }
  }
}
