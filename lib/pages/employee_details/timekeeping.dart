import 'package:fe_cnpmn/constants/constants.dart';
import 'package:fe_cnpmn/data/models/day_off_model.dart';
import 'package:fe_cnpmn/data/models/work_day.dart';
import 'package:fe_cnpmn/data/repositories/checkin_history_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'create_day_off_dialog.dart';

class Timekeeping extends StatefulWidget {
  const Timekeeping({
    Key? key,
    required this.employeeId,
  }) : super(key: key);
  final int employeeId;

  @override
  TimekeepingState createState() => TimekeepingState();
}

class TimekeepingState extends State<Timekeeping> {
  late DateTime currentDay;
  late DateTime focusedDay;
  late DateTime selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime firstDay = DateTime.utc(2010, 10, 16);
  DateTime lastDay = DateTime.utc(2030, 3, 14);
  WorkTime? currentWorkMonth;

  @override
  void initState() {
    super.initState();
    currentDay = DateTime.now();
    focusedDay = DateTime.now();
    selectedDay = DateTime.now();
    _getWorkMonth(
      DateTime.utc(currentDay.year, currentDay.month, 1),
      DateTime.utc(currentDay.year, currentDay.month + 1, 0),
    );
  }

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;

  Future<void> _getWorkMonth(DateTime startDate, DateTime endDate) async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final response = await checkinRepository.getWorkTime(
      startDate,
      endDate,
      widget.employeeId,
    );
    response.fold(
      (l) => setState(() {
        _status = FormzSubmissionStatus.failure;
      }),
      (r) => setState(() {
        _status = FormzSubmissionStatus.success;
        currentWorkMonth = r;
      }),
    );
  }

  final CheckinRepository checkinRepository = getIt<CheckinRepository>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Timekeeping'),
          actions: [
            FilledButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (context) => CreateDayOffDialog(
                    employeeId: widget.employeeId,
                  ),
                ).then((value) {
                  if (value == true) {
                    _getWorkMonth(
                      DateTime.utc(focusedDay.year, focusedDay.month, 1),
                      DateTime.utc(
                        focusedDay.year,
                        focusedDay.month + 1,
                        0,
                      ),
                    );
                  }
                });
              },
              child: Text('Tạo đơn nghỉ'),
            ),
            const SizedBox(
              width: 12,
            ),
            SendPaySlipButton(
              employeeId: widget.employeeId,
              startDate: DateTime.utc(currentDay.year, currentDay.month, 1),
              endDate: DateTime.utc(currentDay.year, currentDay.month + 1, 0),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: TableCalendar(
                firstDay: firstDay,
                lastDay: lastDay,
                focusedDay: focusedDay,
                rangeStartDay: rangeStart,
                rangeEndDay: rangeEnd,
                rowHeight: 100,
                calendarFormat: CalendarFormat.month,
                rangeSelectionMode: RangeSelectionMode.toggledOff,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  markerDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                  selectedDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  markerSize: 8,
                  rangeHighlightColor: Colors.orange.withOpacity(0.2),
                  outsideDaysVisible: true,
                  weekendTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  markersMaxCount: 1,
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.black54,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
                calendarBuilders: CalendarBuilders(markerBuilder: (context, day, events) {
                  // tìm ra event có ngày bằng với ngày hiện tại
                  final WorkDay? event = _getEventsForDay(day).firstOrNull;
                  if (event == null) {
                    return Container();
                  }
                  final hasSufficientWorkingHours = (event.totalHours) >= Constants.sufficientWorkingHours;

                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasSufficientWorkingHours ? Colors.blue : Colors.red,
                      ),
                      width: 8,
                      height: 8,
                    ),
                  );
                }),
                onDaySelected: onDaySelected,
                onPageChanged: onPageChanged,
                onFormatChanged: (format) {
                  if (format == CalendarFormat.month) {
                    setState(() {
                      firstDay = DateTime.utc(2010, 10, 16);
                      lastDay = DateTime.utc(2030, 3, 14);
                    });
                  } else {
                    setState(() {
                      firstDay = DateTime.utc(2010, 10, 16);
                      lastDay = DateTime.utc(2030, 3, 14);
                    });
                  }
                },
              ),
            ),
            _buildEventDetail(),
          ],
        ),
      );

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });
  }

  void onPageChanged(DateTime focusedDay) {
    _getWorkMonth(
      DateTime.utc(focusedDay.year, focusedDay.month, 1),
      DateTime.utc(
        focusedDay.year,
        focusedDay.month + 1,
        0,
      ),
    );

    setState(
      () {
        this.focusedDay = focusedDay;
      },
    );
  }

  List<WorkDay> _getEventsForDay(DateTime day) {
    final date = DateFormat('yyyy-MM-dd').format(day);
    final List<WorkDay> events = currentWorkMonth?.workDays ?? [];
    return events.where((event) => event.date == date).toList();
  }

  Widget _buildEventDetail() => Expanded(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildEventForMonth(),
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              Expanded(
                child: _buildEventForDay(),
              ),
            ],
          ),
        ),
      );

  Widget _buildEventForMonth() => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tháng ${DateFormat('MM/yyyy').format(focusedDay)}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'Tổng thời gian làm việc: ${currentWorkMonth?.totalHours ?? "0"} giờ',
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Tổng thời gian còn thiếu: ${currentWorkMonth?.punishmentHours ?? '0'} giờ',
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Lương: ${Constants.getSalary(currentWorkMonth?.paidAmount ?? 0)} VNĐ',
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Phạt: ${Constants.getPunishmentHours(currentWorkMonth?.punishmentHours ?? 0)} VND',
            ),
          ],
        ),
      );

  Widget _buildEventForDay() {
    final WorkDay? events = _getEventsForDay(selectedDay).firstOrNull;
    final String startTime = events?.startTime.split('T').last ?? '00:00';
    final String endTime = events?.endTime.split('T').last ?? '00:00';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chốt vân tay trong ngày ${DateFormat('dd/MM/yyyy').format(selectedDay)}",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Thời gian: ' '$startTime - $endTime',
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Tổng thời gian làm việc: ${events?.totalHours ?? '0'} giờ',
          ),
          if (events?.dayOff != null) ...[
            const SizedBox(
              height: 16,
            ),
            Text(
              'Thông tin nghỉ phép:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Loại nghỉ: ${events?.dayOff?.type.title ?? ''}',
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Lý do nghỉ: ${events?.dayOff?.reason ?? ''}',
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                FilledButton.tonal(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) => CreateDayOffDialog(
                        dayOff: events!.dayOff,
                      ),
                    ).then((value) {
                      if (value != null) {
                        _getWorkMonth(
                          DateTime.utc(focusedDay.year, focusedDay.month, 1),
                          DateTime.utc(
                            focusedDay.year,
                            focusedDay.month + 1,
                            0,
                          ),
                        );
                      }
                    });
                  },
                  child: Text('Chỉnh sửa'),
                ),
                const SizedBox(
                  width: 16,
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    final response = await checkinRepository.deleteDayOff(events!.dayOff!.id!);
                    response.fold(
                      (l) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Xóa đơn nghỉ không thành công'),
                        ),
                      ),
                      (r) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Xóa đơn nghỉ thành công'),
                          ),
                        );
                        _getWorkMonth(
                          DateTime.utc(focusedDay.year, focusedDay.month, 1),
                          DateTime.utc(
                            focusedDay.year,
                            focusedDay.month + 1,
                            0,
                          ),
                        );
                      },
                    );
                  },
                  child: Text('Xóa'),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class SendPaySlipButton extends StatefulWidget {
  const SendPaySlipButton({
    super.key,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
  });

  final int employeeId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  State<SendPaySlipButton> createState() => _SendPaySlipButtonState();
}

class _SendPaySlipButtonState extends State<SendPaySlipButton> {
  FormzSubmissionStatus status = FormzSubmissionStatus.initial;
  String? errorMessage;

  final CheckinRepository checkinRepository = getIt<CheckinRepository>();

  Future<void> sendPayslipEmail() async {
    setState(() {
      status = FormzSubmissionStatus.inProgress;
      errorMessage = null;
    });
    final failureOrResponse = await checkinRepository.sendSalaryEmail(
      widget.employeeId,
      widget.startDate,
      widget.endDate,
    );
    failureOrResponse.fold(
      (l) {
        setState(() {
          status = FormzSubmissionStatus.failure;
          errorMessage = l.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? 'Something went wrong'),
              backgroundColor: Colors.red,
            ),
          );
        });
      },
      (r) => setState(() {
        status = FormzSubmissionStatus.success;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gửi phiếu lương thành công'),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) => FilledButton.tonal(
        onPressed: status.isInProgress ? null : sendPayslipEmail,
        child: status.isInProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const Text('Gửi phiếu lương'),
      );
}
