import 'package:fe_cnpmn/data/models/checkin_history.dart';
import 'package:fe_cnpmn/data/repositories/checkin_history_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class CheckinHistoryListView extends StatefulWidget {
  const CheckinHistoryListView({
    super.key,
    this.employeeId,
    this.roomId,
    this.rfidId,
    this.cardId,
    this.showEmployeeId = true,
    this.showCardId = true,
    this.showRoomId = true,
    this.showRfidMachineId = true,
  });

  final int? employeeId;
  final int? roomId;
  final int? rfidId;
  final String? cardId;

  final bool showEmployeeId;
  final bool showCardId;
  final bool showRoomId;
  final bool showRfidMachineId;

  @override
  State<CheckinHistoryListView> createState() => _CheckinHistoryListViewState();
}

class _CheckinHistoryListViewState extends State<CheckinHistoryListView> {
  @override
  void initState() {
    _getCheckinHistory();
    super.initState();
  }

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;
  List<CheckinHistory>? _history;

  Future<void> _getCheckinHistory() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await checkinRepository.getCheckinHistory(
      employeeId: widget.employeeId,
      rfidId: widget.rfidId,
      roomId: widget.roomId,
      cardId: widget.cardId,
    );
    failureOrResponse.fold(
      (l) => setState(() {
        _status = FormzSubmissionStatus.failure;
      }),
      (r) => setState(() {
        _status = FormzSubmissionStatus.success;
        _history = r;
      }),
    );
  }

  final CheckinRepository checkinRepository = getIt<CheckinRepository>();

  @override
  Widget build(BuildContext context) {
    if (_status.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to get checkin history, please try again.'),
            const SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              onPressed: _getCheckinHistory,
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    }
    if (_status.isSuccess && _history != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _getCheckinHistory,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ),
          Expanded(
            child: _history!.isEmpty
                ? const Center(
                    child: Text('No checkin history'),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        const DataColumn(
                          label: Text('ID'),
                        ),
                        const DataColumn(
                          label: Text(
                            'Date created',
                          ),
                        ),
                        if (widget.showEmployeeId)
                          const DataColumn(
                            label: Text('Employee ID'),
                          ),
                        if (widget.showCardId)
                          const DataColumn(
                            label: Text('Card ID'),
                          ),
                        if (widget.showRoomId)
                          const DataColumn(
                            label: Text('Room ID'),
                          ),
                        if (widget.showRfidMachineId)
                          const DataColumn(
                            label: Text('RFID Machine ID'),
                          ),
                      ],
                      rows: _history!
                          .map(
                            (item) => DataRow(
                              onSelectChanged: (_) {},
                              cells: [
                                DataCell(
                                  Text(
                                    item.id.toString(),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    DateFormat(
                                      'dd-MM-yyyy hh:mm:ss',
                                    ).format(item.dateCreated),
                                  ),
                                ),
                                if (widget.showEmployeeId)
                                  DataCell(
                                    Text(
                                      item.employeeId.toString(),
                                    ),
                                  ),
                                if (widget.showCardId)
                                  DataCell(
                                    Text(
                                      item.cardId.toString(),
                                    ),
                                  ),
                                if (widget.showRoomId)
                                  DataCell(
                                    Text(
                                      item.roomId.toString(),
                                    ),
                                  ),
                                if (widget.showRfidMachineId)
                                  DataCell(
                                    Text(item.rfidMachineId.toString()),
                                  ),
                              ],
                            ),
                          )
                          .toList(
                            growable: false,
                          ),
                    ),
                  ),
          ),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
