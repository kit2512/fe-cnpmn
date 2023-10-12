import 'package:another_flushbar/flushbar.dart';
import 'package:fe_cnpmn/data/models/room.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class AssignRoomDialog extends StatefulWidget {
  const AssignRoomDialog({
    super.key,
    required this.employeeId,
    required this.currentAssignedRooms,
  });

  final List<Room> currentAssignedRooms;
  final int employeeId;

  @override
  State<AssignRoomDialog> createState() => _AssignRoomDialogState();
}

class _AssignRoomDialogState extends State<AssignRoomDialog> {
  @override
  void initState() {
    _assignedRooms = [...widget.currentAssignedRooms];
    _getRooms();
    super.initState();
  }

  final RoomRepository roomRepository = getIt<RoomRepository>();
  final EmployeeRepository employeeRepository = getIt<EmployeeRepository>();

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;
  FormzSubmissionStatus _submitStatus = FormzSubmissionStatus.initial;

  late List<Room> _rooms;
  late List<Room> _assignedRooms;

  Future<void> _getRooms() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await roomRepository.getRooms();
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
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Assign rooms'),
        content: buildContent(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          if (_submitStatus.isInProgress)
            const CircularProgressIndicator.adaptive()
          else
            ElevatedButton(
              onPressed: !_submitStatus.isInProgress || !_status.isFailure ? _assign : null,
              child: const Text('OK'),
            ),
        ],
      );

  Widget buildContent() {
    if (_status.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to get rooms'),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: _getRooms,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }
    if (_status.isSuccess) {
      if (_rooms.isEmpty) {
        return Center(
          child: Column(
            children: [
              const Text('No available rooms'),
              const SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                onPressed: _getRooms,
                child: const Text('Refresh'),
              ),
            ],
          ),
        );
      }
      return DataTable(
        showCheckboxColumn: true,
        onSelectAll: (selectAll) {
          setState(() {
            if (selectAll == true) {
              _assignedRooms = [..._rooms];
            }
          });
        },
        columns: const [
          DataColumn(
            label: Text('ID'),
          ),
          DataColumn(
            label: Text('Name'),
          ),
        ],
        rows: _rooms
            .map(
              (e) => DataRow(
                selected: _assignedRooms.where((element) => element.id == e.id).isNotEmpty,
                onSelectChanged: (selected) {
                  setState(() {
                    if (selected != null) {
                      if (selected) {
                        _assignedRooms.add(e);
                      } else {
                        _assignedRooms.removeWhere((element) => element.id == e.id);
                      }
                    }
                  });
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
      );
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Future<void> _assign() async {
    setState(() {
      _submitStatus = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await employeeRepository.assignRooms(
        employeeId: widget.employeeId, roomIds: _assignedRooms.map((e) => e.id).toList());
    failureOrResponse.fold(
      (l) {
        _submitStatus = FormzSubmissionStatus.failure;
        Flushbar<void>(
          message: getErrorMessage(l),
          title: 'Error',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ).show(context);
      },
      (r) {
        _submitStatus = FormzSubmissionStatus.success;
        Navigator.of(context).pop(true);
      },
    );
  }
}
