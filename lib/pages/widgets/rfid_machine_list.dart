import 'package:fe_cnpmn/data/models/rfid_machine.dart';
import 'package:fe_cnpmn/data/repositories/rfid_repository.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

import '../../dependency_injection.dart';

class RfidMachineListView extends StatefulWidget {
  const RfidMachineListView({
    super.key,
    this.roomId,
    this.showRoomId = true,
  });

  final int? roomId;
  final bool showRoomId;

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
  Widget build(BuildContext context) {
    if (_status.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Unable to get data, please try again'),
            const SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              onPressed: _getRfids,
              child: Text('Refresh'),
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: Icon(Icons.refresh_rounded),
              label: Text('Refresh'),
              onPressed: _getRfids,
            ),
          ),
          DataTable(
            columns: [
              DataColumn(
                label: Text('ID'),
              ),
              if (widget.showRoomId)
                DataColumn(
                  label: Text('Room ID'),
                ),
              DataColumn(label: Text('Date created'))
            ],
            rows: _rfids
                .map((rfid) => DataRow(
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
                            DateFormat('dd-MM-yyyy hh:mm:ss').format(rfid.dateCreated),
                          ),
                        ),
                      ],
                    ))
                .toList(growable: false),
          )
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
