part of 'employees_cubit.dart';

class EmployeeState extends Equatable {
  const EmployeeState({
    required this.status,
    required this.employees,
    required this.errorMessage,
    this.selectedEmployee,
  });


  factory EmployeeState.initial() => const EmployeeState(
        status: FormzSubmissionStatus.initial,
        employees: [],
        errorMessage: '',
      );

  final FormzSubmissionStatus status;
  final List<Employee> employees;
  final String errorMessage;
  final int? selectedEmployee;

  @override
  List<Object?> get props => [
        employees,
        status,
        errorMessage,
      ];

  EmployeeState copyWith({
    FormzSubmissionStatus? status,
    List<Employee>? employees,
    String? errorMessage,
    int? selectedEmployee,
    bool clearSelection = false,
  }) =>
      EmployeeState(
        selectedEmployee: clearSelection ? null : selectedEmployee ?? this.selectedEmployee,
        status: status ?? this.status,
        employees: employees ?? this.employees,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
