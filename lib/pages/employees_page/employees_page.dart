import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/dependency_injection.dart';
import 'package:fe_cnpmn/pages/employees_page/cubit/employees_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesPage extends StatelessWidget {
  static const String routeName = 'employees';

  const EmployeesPage({super.key});

  MaterialPageRoute<void> route() => MaterialPageRoute(
        builder: (context) => const EmployeesPage(),
      );

  @override
  Widget build(BuildContext context) => BlocProvider<EmployeesCubit>(
    create: (context) => EmployeesCubit(
      employeeRepository: getIt<EmployeeRepository>(),
    ),
    child: const _EmployeesPageView(),
  );
}

class _EmployeesPageView extends StatelessWidget {
  const _EmployeesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

