import 'package:fe_cnpmn/data/models/day_off_model.dart';
import 'package:fe_cnpmn/data/repositories/days_off_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/enums/day_off_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class CreateDayOffDialog extends StatefulWidget {
  const CreateDayOffDialog({super.key, this.employeeId, this.dayOff})
      : assert(
  employeeId != null && dayOff == null || employeeId == null && dayOff != null,
  'Either employeeId or dayOff must be provided',
  );

  final int? employeeId;
  final DayOffModel? dayOff;

  @override
  State<CreateDayOffDialog> createState() => _CreateDayOffDialogState();
}

class _CreateDayOffDialogState extends State<CreateDayOffDialog> {
  final DaysOffRepository _repository = getIt<DaysOffRepository>();

  FormzSubmissionStatus status = FormzSubmissionStatus.initial;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.dayOff != null) {
      dayOff = widget.dayOff!;
    } else {
      dayOff = DayOffModel(
        employeeId: widget.employeeId!,
        reason: '',
        startDate: DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .now()
              .month,
          DateTime
              .now()
              .day,
        ),
        endDate: DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .now()
              .month,
          DateTime
              .now()
              .day,
        ),
        type: DayOffType.unpaid,
      );
    }
  }

  late DayOffModel dayOff;

  Future<void> _createDayOff() async {
    setState(() {
      status = FormzSubmissionStatus.inProgress;
      errorMessage = null;
    });
    try {
      final result = await _repository.createDayOff(
        dayOff,
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        status = FormzSubmissionStatus.failure;
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Có lỗi xảy ra, vui lòng thử lại'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateDayOff() async {
    setState(() {
      status = FormzSubmissionStatus.inProgress;
      errorMessage = null;
    });
    try {
      final result = await _repository.updateDayOff(
        dayOff,
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        status = FormzSubmissionStatus.failure;
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onPressed() {
    if (widget.dayOff != null) {
      _updateDayOff();
    } else {
      _createDayOff();
    }
  }

  @override
  Widget build(BuildContext context) =>
      AlertDialog(
        title: Text('${widget.dayOff != null ? 'Sửa' : 'Tạo'} Đơn nghỉ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'From: ${dayOff.dateRange.start.day}/${dayOff.dateRange.start.month}/${dayOff.dateRange.start
                              .year}',
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          'To: ${dayOff.dateRange.end.day}/${dayOff.dateRange.end.month}/${dayOff.dateRange.end.year}',
                        ),
                      ),
                      IconButton(
                        onPressed: status.isInProgress
                            ? null
                            : () =>
                            showDateRangePicker(
                              context: context,
                              initialDateRange: dayOff.dateRange,
                              firstDate: DateTime(
                                DateTime
                                    .now()
                                    .year,
                                DateTime
                                    .now()
                                    .month,
                                DateTime
                                    .now()
                                    .day,
                              ),
                              lastDate: DateTime(
                                DateTime
                                    .now()
                                    .year,
                                DateTime
                                    .now()
                                    .month,
                                DateTime
                                    .now()
                                    .day,
                              ).add(
                                const Duration(days: 365),
                              ),
                            ).then(
                                  (value) {
                                if (value != null) {
                                  setState(() {
                                    dayOff = dayOff.copyWith(
                                      startDate: DateTime(
                                        value.start.year,
                                        value.start.month,
                                        value.start.day,
                                      ),
                                      endDate: DateTime(
                                        value.end.year,
                                        value.end.month,
                                        value.end.day,
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              initialValue: dayOff.reason,
              enabled: !status.isInProgress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lí do không được để trống';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  dayOff = dayOff.copyWith(reason: value);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Lí do',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text('Select type'),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: DropdownMenu<DayOffType>(
                    initialSelection: dayOff.type,
                    dropdownMenuEntries: DayOffType.values
                        .map(
                          (e) => DropdownMenuEntry<DayOffType>(value: e, label: e.title),
                    )
                        .toList(),
                    onSelected: (value) {
                      setState(() {
                        dayOff = dayOff.copyWith(type: value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (status.isInProgress)
            const CircularProgressIndicator()
          else
            FilledButton(
              onPressed: (!dayOff.isValid) ? null : _onPressed,
              child: Text(widget.dayOff != null ? 'Cập nhật' : 'Tạo'),
            ),
          OutlinedButton(
            onPressed: Navigator
                .of(context)
                .pop,
            child: const Text('Huỷ'),
          ),
        ],
      );
}
