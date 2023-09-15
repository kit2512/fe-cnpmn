import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_cnpmn/data/models/employee.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:formz/formz.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeeState> {
  EmployeesCubit({
    required this.employeeRepository,
  }) : super(
          EmployeeState.initial(),
        );

  final EmployeeRepository employeeRepository;
}
