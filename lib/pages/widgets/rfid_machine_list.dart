import 'package:another_flushbar/flushbar.dart';
import 'package:fe_cnpmn/data/models/form/name.dart';
import 'package:fe_cnpmn/data/models/rfid_machine.dart';
import 'package:fe_cnpmn/data/models/room.dart';
import 'package:fe_cnpmn/data/repositories/rfid_repository.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:fe_cnpmn/pages/rfid_details_page/rfid_details_page.dart';
import 'package:fe_cnpmn/pages/widgets/name_input.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class RfidMachineListView extends StatefulWidget {
  const RfidMachineListView({
    super.key,
    this.roomId,
    this.showRoomId = true,
    this.showAppBar = false,
    this.showRefreshInTable = true,
    this.enableSelection = false,
    this.enableOnTap = false,
    this.showHeadingColor = false,
  });

  final bool showHeadingColor;

  final int? roomId;
  final bool showRoomId;
  final bool showAppBar;
  final bool showRefreshInTable;
  final bool enableSelection;
  final bool enableOnTap;

  @override
  State<RfidMachineListView> createState() => _RfidMachineListViewState();
}

class _RfidMachineListViewState extends State<RfidMachineListView> {
  @override
  void initState() {
    _getRfids();
    super.initState();
  }

  final RfidRepository rfidRepository = getIt<RfidRepository>();

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;
  late List<RfidMachine> _rfids;

  Future<void> _getRfids() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await rfidRepository.getRfids(roomId: widget.roomId);
    failureOrResponse.fold(
      (l) => setState(() {
        _status = FormzSubmissionStatus.failure;
      }),
      (r) {
        setState(() {
          _status = FormzSubmissionStatus.success;
          _rfids = r;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                title: const Text('Manage RFID machines'),
                actions: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog<bool?>(
                        context: context,
                        builder: (context) => const AddRfidDialog(),
                      ).then(
                        (result) {
                          if (result == true) {
                            Flushbar<void>(
                              message: 'Successfully create RFID machine',
                              title: 'Success',
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ).show(context);
                            _getRfids();
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _getRfids,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Refresh'),
                  ),
                ],
              )
            : null,
        body: buildBody(),
      );

  Widget buildBody() {
    if (_status.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to get data, please try again'),
            const SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              onPressed: _getRfids,
              child: const Text('Refresh'),
            )
          ],
        ),
      );
    }
    if (_status.isSuccess) {
      if (_rfids.isEmpty) {
        return const Center(
          child: Text('No RFID machine'),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showRefreshInTable)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
                onPressed: _getRfids,
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowColor: widget.showHeadingColor ? MaterialStatePropertyAll<Color>(Colors.blue[200]!) : null,
                showCheckboxColumn: widget.enableSelection,
                onSelectAll: widget.enableSelection ? (selectAll) {} : null,
                columns: [
                  const DataColumn(
                    label: Text('ID'),
                  ),
                  if (widget.showRoomId)
                    const DataColumn(
                      label: Text('Room ID'),
                    ),
                  const DataColumn(
                    label: Text(
                      'Name',
                    ),
                  ),
                  const DataColumn(
                    label: Text(
                      'Date created',
                    ),
                  ),
                  const DataColumn(
                    label: Text(
                      'Allow checkin',
                    ),
                  )
                ],
                rows: _rfids
                    .map((rfid) => DataRow(
                          onSelectChanged: widget.enableOnTap
                              ? (_) {
                                  Navigator.of(context).push(RfidDetailsPage.route(details: rfid)).then((shouldUpdate) {
                                    if (shouldUpdate == true) {
                                      _getRfids();
                                    }
                                  });
                                }
                              : null,
                          cells: [
                            DataCell(
                              Text(
                                rfid.id.toString(),
                              ),
                            ),
                            if (widget.showRoomId)
                              DataCell(
                                Text(
                                  rfid.roomId.toString(),
                                ),
                              ),
                            DataCell(
                              Text(
                                rfid.name,
                              ),
                            ),
                            DataCell(
                              Text(
                                DateFormat('dd-MM-yyyy hh:mm:ss').format(rfid.dateCreated),
                              ),
                            ),
                            DataCell(
                              Text(
                                rfid.allowCheckin ? 'Yes' : 'No',
                              ),
                            ),
                          ],
                        ))
                    .toList(growable: false),
              ),
            ),
          )
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class AddRfidDialog extends StatefulWidget {
  const AddRfidDialog({super.key});

  @override
  State<AddRfidDialog> createState() => _AddRfidDialogState();
}

class _AddRfidDialogState extends State<AddRfidDialog> {
  @override
  void initState() {
    _getRooms();
    super.initState();
  }

  final RfidRepository rfidRepository = getIt<RfidRepository>();

  final RoomRepository roomRepository = getIt<RoomRepository>();

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;

  FormzSubmissionStatus _submitStatus = FormzSubmissionStatus.initial;

  int? _selectedRoomId;

  bool _allowCheckin = false;

  Name _name = const Name.pure();

  late List<Room> _rooms;

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

  void setSelectedRoom(int roomId) {
    setState(() {
      _selectedRoomId = roomId;
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add RFID machine'),
        content: buildContent(),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: !_submitStatus.isInProgress && _valid ? _create : null,
            child: _status.isInProgress ? const CircularProgressIndicator.adaptive() : const Text('OK'),
          ),
        ],
      );

  Future<void> _create() async {
    setState(() {
      _submitStatus = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await rfidRepository.createRfidMachine(
      roomId: _selectedRoomId!,
      name: _name.value,
    );
    failureOrResponse.fold(
      (l) {
        setState(() {
          _submitStatus = FormzSubmissionStatus.failure;
        });
        Flushbar<void>(
          message: getErrorMessage(l),
          title: 'Failed',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ).show(context);
      },
      (r) {
        Navigator.of(context).pop(true);
      },
    );
  }

  bool get _valid => _selectedRoomId != null && _name.isValid;

  Widget buildContent() {
    if (_status.isSuccess) {
      return SizedBox(
        height: 400.0,
        width: 400.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NameInput(
              validator: (_) => (_name.isNotValid && _name.error != null) ? Name.getError(_name.error!) : null,
              labelText: 'Name',
              onChanged: (value) => setState(() {
                _name = Name.dirty(value);
              }),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                const Text('Allow check in'),
                Checkbox(
                  value: _allowCheckin,
                  onChanged: (value) => setState(() => _allowCheckin = value!),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            const Align(
              alignment: Alignment.center,
              child: Text('Choose a room'),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  showCheckboxColumn: true,
                  onSelectAll: null,
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
                          selected: e.id == _selectedRoomId,
                          onSelectChanged: (selected) {
                            setState(() {
                              if (selected != null) {
                                if (selected) {
                                  _selectedRoomId = e.id;
                                } else {
                                  _selectedRoomId = null;
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
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_status.isFailure) {
      return Center(
        child: Column(
          children: [
            const Text('Unable to get rooms, pleas try again'),
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
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
