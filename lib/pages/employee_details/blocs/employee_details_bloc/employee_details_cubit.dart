import 'package:equatable/equatable.dart';
import 'package:fe_cnpmn/data/models/employee.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'employee_details_state.dart';

class EmployeeDetailsCubit extends Cubit<EmployeeDetailsState> {
  EmployeeDetailsCubit({
    required this.employeeRepository,
  }) : super(
          EmployeeDetailsState.initial(),
        );

  final EmployeeRepository employeeRepository;

  Future<void> getDetails(int id) async {
    emit(
      state.copyWith(
        id: id,
        detailsStatus: FormzSubmissionStatus.inProgress,
      ),
    );
    final failureOrResponse = await employeeRepository.getEmployeeDetails(id: id);
    failureOrResponse.fold(
      (failure) =>
          emit(state.copyWith(detailsStatus: FormzSubmissionStatus.failure, errorMessage: getErrorMessage(failure))),
      (details) => emit(
        state.copyWith(
          detailsStatus: FormzSubmissionStatus.success,
          details: details,
        ),
      ),
    );
  }

  Future<void> deleteEmployee() async {
    if (state.details == null) return;
    emit(
      state.copyWith(
        deleteStatus: FormzSubmissionStatus.inProgress,
      ),
    );
    final failureOrResponse = await employeeRepository.deleteEmployee(
      id: state.details!.id,
    );
    failureOrResponse.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: getErrorMessage(failure),
          deleteStatus: FormzSubmissionStatus.failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteStatus: FormzSubmissionStatus.success,
        ),
      ),
    );
  }
}
