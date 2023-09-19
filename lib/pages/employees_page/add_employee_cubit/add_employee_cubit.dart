import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_cnpmn/data/models/form/name.dart';
import 'package:fe_cnpmn/data/models/form/password_model.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/enums/user_role_enum.dart';
import 'package:fe_cnpmn/helpers/exception_helper.dart';
import 'package:formz/formz.dart';

part 'add_employee_state.dart';

class AddEmployeeCubit extends Cubit<AddEmployeeState> {
  AddEmployeeCubit({
    required this.employeeRepository,
  }) : super(
          AddEmployeeState.initial(),
        );

  final EmployeeRepository employeeRepository;

  Future<void> createEmployee() async {
    emit(
      state.copyWith(
        creationStatus: FormzSubmissionStatus.inProgress,
      ),
    );

    final failureOrResponse = await employeeRepository.createEmployee(
      firstName: state.firstName.value,
      lastName: state.lastName.value,
      username: state.username.value,
      password: state.password.value,
      role: state.role,
    );
    failureOrResponse.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: getErrorMessage(failure),
          creationStatus: FormzSubmissionStatus.failure,
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            creationStatus: FormzSubmissionStatus.success,
          ),
        );
      },
    );
  }

  void firstNameChanged(String value) => emit(
        state.copyWith(
          firstName: Name.dirty(value),
        ),
      );

  void lastNameChanged(String value) => emit(
        state.copyWith(
          lastName: Name.dirty(value),
        ),
      );

  void passwordChanged(String value) => emit(
        state.copyWith(
          password: Password.dirty(null, value),
        ),
      );

  void usernameChanged(String value) => emit(
        state.copyWith(
          username: Name.dirty(value),
        ),
      );

  void roleChanged(UserRole? value) => emit(
        state.copyWith(
          role: value,
        ),
      );
}
