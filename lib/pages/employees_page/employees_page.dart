import 'package:fe_cnpmn/constants/constants.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/enums/user_role_enum.dart';
import 'package:fe_cnpmn/pages/employee_details/employee_details_page.dart';
import 'package:fe_cnpmn/pages/employees_page/add_employees_dialog.dart';
import 'package:fe_cnpmn/pages/employees_page/cubit/employees_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  static const String routeName = 'employees';

  MaterialPageRoute<void> route() => MaterialPageRoute(
        builder: (context) => const EmployeesPage(),
      );

  @override
  Widget build(BuildContext context) => BlocProvider<EmployeesCubit>.value(
        value: getIt<EmployeesCubit>()..getEmployees(),
        child: const _EmployeesPageView(),
      );
}

class _EmployeesPageView extends StatelessWidget {
  const _EmployeesPageView();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Manage Employees'),
          actions: [
            ElevatedButton.icon(
              onPressed: () => showDialog<bool?>(
                context: context,
                builder: (context) => const AddEmployeeDialog(),
              ).then((value) {
                if (value == true) {
                  context.read<EmployeesCubit>().getEmployees();
                }
              }),
              icon: const Icon(
                Icons.add_rounded,
              ),
              label: const Text(
                'Add',
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => context.read<EmployeesCubit>().getEmployees(refresh: true),
              label: const Text(
                'Refresh',
              ),
              icon: const Icon(
                Icons.refresh,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
              icon: Icon(Icons.logout_rounded),
              label: Text('Log out'),
            ),
          ],
        ),
        body: BlocBuilder<EmployeesCubit, EmployeeState>(
          builder: (context, state) {
            if (state.status.isFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Unable to get employees'),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: context.read<EmployeesCubit>().getEmployees,
                      child: const Text('Refresh'),
                    )
                  ],
                ),
              );
            }
            if (state.status.isInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.employees.isEmpty) {
              return const Center(
                child: Text('No employee, please create one'),
              );
            }
            return SizedBox(
              width: double.infinity,
              child: DataTable(
                showCheckboxColumn: false,
                showBottomBorder: true,
                headingRowColor: MaterialStatePropertyAll<Color>(Colors.blue[200]!),
                columns: const [
                  DataColumn(
                    label: Text('ID'),
                  ),
                  DataColumn(
                    label: Text('Username'),
                  ),
                  DataColumn(
                    label: Text('First name'),
                  ),
                  DataColumn(
                    label: Text('Last name'),
                  ),
                  DataColumn(
                    label: Text('Salary'),
                  ),
                  DataColumn(
                    label: Text('Role'),
                  ),
                  DataColumn(
                    label: Text('Date created'),
                  ),
                ],
                rows: state.employees
                    .map(
                      (emp) => DataRow(
                        onSelectChanged: (_) => Navigator.of(context).push(
                          EmployeeDetailsPage.route(
                            id: emp.id,
                          ),
                        ),
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
                            Text(
                              '${Constants.getSalary(emp.salary)} VND',
                            ),
                          ),
                          DataCell(
                            Text(emp.user.role.translationName),
                          ),
                          DataCell(
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
              ),
            );
          },
        ),
      );
}
