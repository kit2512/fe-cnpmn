import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_cnpmn/data/models/employee.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:formz/formz.dart';

part 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeeState> {
  EmployeesCubit({
    required this.employeeRepository,
  }) : super(
          EmployeeState.initial(),
        );

  final EmployeeRepository employeeRepository;

  Future<void> getEmployees({
    bool refresh = true,
  }) async {
    if (refresh) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      );
    }
    final failureOrResponse = await employeeRepository.getEmployees();
    failureOrResponse.fold(
      (failure) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: getErrorMessage(failure),
          ),
        );
      },
      (employees) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            employees: employees,
          ),
        );
      },
    );
  }
}
