part of 'employees_cubit.dart';

class EmployeeState extends Equatable {
  const EmployeeState({
    required this.status,
    required this.employees,
  });

  factory EmployeeState.initial() => const EmployeeState(
        status: FormzSubmissionStatus.initial,
        employees: [],
      );

  final FormzSubmissionStatus status;
  final List<Employee> employees;

  @override
  List<Object?> get props => [
        employees,
        status,
      ];

  EmployeeState copyWith({
    FormzSubmissionStatus? status,
    List<Employee>? employees,
  }) =>
      EmployeeState(
        status: status ?? this.status,
        employees: employees ?? this.employees,
      );
}
