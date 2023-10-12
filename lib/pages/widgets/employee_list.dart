import 'package:another_flushbar/flushbar.dart';
import 'package:fe_cnpmn/data/models/employee.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/enums/user_role_enum.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:fe_cnpmn/pages/employee_details/employee_details_page.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class EmployeeListView extends StatefulWidget {
  const EmployeeListView({
    super.key,
    this.roomId,
    this.selectable = false,
    this.enableOnTap = false,
    this.onSelect,
    this.showDateCreated = true,
  });

  final bool showDateCreated;

  final int? roomId;
  final bool selectable;
  final bool enableOnTap;
  final void Function(Employee)? onSelect;

  @override
  State<EmployeeListView> createState() => _EmployeeListViewState();
}

class _EmployeeListViewState extends State<EmployeeListView> {
  @override
  void initState() {
    _getEmployees();
    super.initState();
  }

  final EmployeeRepository employeeRepository = getIt<EmployeeRepository>();

  Future<void> _getEmployees() async {
    final failureOrResponse = await employeeRepository.getEmployees(
      roomId: widget.roomId,
    );
    failureOrResponse.fold((l) {
      setState(() {
        _status = FormzSubmissionStatus.failure;
        _errorMessage = getErrorMessage(l);
      });
    }, (employees) {
      setState(() {
        _status = FormzSubmissionStatus.success;
        _employees = employees;
      });
    });
  }

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;
  String? _errorMessage;
  late List<Employee> _employees;

  int? selectedId;

  void _onTap(Employee employee) {
    setState(() {
      selectedId = employee.id;
    });
    if (widget.onSelect != null) {
      widget.onSelect!(employee);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              onPressed: _getEmployees,
              child: const Text('Refresh'),
            ),
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
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
                onPressed: _getEmployees,
              ),
              if (widget.roomId != null)
                TextButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Assign employee'),
                  onPressed: _assignEmployees,
                ),
            ],
          ),
          if (_employees.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No employee'),
              ),
            )
          else
            DataTable(
              showCheckboxColumn: widget.selectable,
              showBottomBorder: true,
              columns:  [
                const DataColumn(
                  label: Text('ID'),
                ),
                const DataColumn(
                  label: Text('Username'),
                ),
                const DataColumn(
                  label: Text('First name'),
                ),
                const DataColumn(
                  label: Text('Last name'),
                ),
                const DataColumn(
                  label: Text('Role'),
                ),
                if (widget.showDateCreated) const DataColumn(
                  label: Text('Date created'),
                ),
              ],
              rows: _employees
                  .map(
                    (emp) => DataRow(
                      selected: selectedId == emp.id,
                      onSelectChanged: (_) {
                        if (widget.enableOnTap) {
                          Navigator.of(context).push(
                            EmployeeDetailsPage.route(
                              id: emp.id,
                            ),
                          );
                        }
                        if (widget.selectable) {
                          _onTap(emp);
                        }
                      },
                      cells: [
                        DataCell(
                          Text(emp.id.toString()),
                        ),
                        DataCell(
                          Text(emp.user.username),
                        ),
                        DataCell(
                          Text(emp.user.firstName),
                        ),
                        DataCell(
                          Text(emp.user.lastName),
                        ),
                        DataCell(
                          Text(emp.user.role.translationName),
                        ),
                        if (widget.showDateCreated) DataCell(
                          Text(
                            DateFormat('dd-MM-yyyy').format(
                              emp.user.dateCreated,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            )
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  void _assignEmployees() {
    showDialog<bool>(
      context: context,
      builder: (context) => AssignEmployeesDialog(
        roomId: widget.roomId!,
        currentEmployees: _employees,
      ),
    ).then((result) {
      if (result == true) {
        Flushbar<void>(
          message: 'Successfully assign employees!',
          title: 'Success',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ).show(context);
        _getEmployees();
      }
    });
  }
}

class AssignEmployeesDialog extends StatefulWidget {
  const AssignEmployeesDialog({
    super.key,
    required this.roomId,
    required this.currentEmployees,
  });

  final int roomId;
  final List<Employee> currentEmployees;

  @override
  State<AssignEmployeesDialog> createState() => _AssignEmployeesDialogState();
}

class _AssignEmployeesDialogState extends State<AssignEmployeesDialog> {
  @override
  void initState() {
    _getEmployees();
    _assignedEmployees = [...widget.currentEmployees];
    super.initState();
  }

  final EmployeeRepository employeeRepository = getIt<EmployeeRepository>();
  final RoomRepository roomRepository = getIt<RoomRepository>();

  late List<Employee> _assignedEmployees;
  late List<Employee> _employees;

  FormzSubmissionStatus _employeeStatus = FormzSubmissionStatus.initial;
  FormzSubmissionStatus _submitStatus = FormzSubmissionStatus.initial;

  Future<void> _getEmployees() async {
    _employeeStatus = FormzSubmissionStatus.inProgress;
    final failureOrResponse = await employeeRepository.getEmployees();
    failureOrResponse.fold((l) {
      setState(() {
        _employeeStatus = FormzSubmissionStatus.failure;
      });
    }, (employees) {
      setState(() {
        _employeeStatus = FormzSubmissionStatus.success;
        _employees = employees;
      });
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Assign employees'),
        content: buildContent(),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: !_submitStatus.isInProgress || !_employeeStatus.isFailure ? _assign : null,
            child: const Text('OK'),
          ),
        ],
      );

  void _assign() async {
    setState(() {
      _submitStatus = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await roomRepository.assignEmployee(
      roomId: widget.roomId,
      employeeIds: _assignedEmployees.map((e) => e.id).toSet().toList(),
    );
    failureOrResponse.fold(
      (l) => setState(
        () {
          _submitStatus = FormzSubmissionStatus.failure;
          Flushbar<void>(
            message: 'Unable to assign room, please try again',
            title: 'Error',
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ).show(context);
        },
      ),
      (r) {
        Navigator.of(context).pop(true);
      },
    );
  }

  Widget buildContent() {
    if (_employeeStatus.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to get employees, please try again'),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: _getEmployees,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }
    if (_employeeStatus.isSuccess) {
      if (_employees.isEmpty) {
        return const Center(child: Text('No available rooms'));
      }
      return DataTable(
        showCheckboxColumn: true,
        onSelectAll: (select) {
          setState(() {
            if (select == true) {
              _assignedEmployees = _employees;
            } else {
              _assignedEmployees.clear();
            }
          });
        },
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(
            label: Text('Role'),
          ),
        ],
        rows: _employees
            .map(
              (e) => DataRow(
                selected: _assignedEmployees.where((element) => element.id == e.id).isNotEmpty,
                onSelectChanged: (select) {
                  setState(() {
                    if (select == true) {
                      _assignedEmployees.add(e);
                    }
                    if (select == false) {
                      _assignedEmployees.removeWhere(
                        (element) => element.id == e.id,
                      );
                    }
                  });
                },
                cells: [
                  DataCell(
                    Text(
                      e.id.toString(),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.user.fullName,
                    ),
                  ),
                  DataCell(
                    Text(
                      e.user.role.translationName,
                    ),
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
}
