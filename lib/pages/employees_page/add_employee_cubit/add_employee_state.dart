part of 'add_employee_cubit.dart';

class AddEmployeeState extends Equatable with FormzMixin {
  const AddEmployeeState({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.role,
    required this.salary,
    required this.creationStatus,
    required this.errorMessage,
  });

  factory AddEmployeeState.initial() => const AddEmployeeState(
        firstName: Name.pure(),
        lastName: Name.pure(),
        username: Name.pure(),
        password: Password.pure(),
        role: UserRole.employee,
        salary: 0,
        creationStatus: FormzSubmissionStatus.initial,
        errorMessage: '',
      );

  final Name firstName;
  final Name lastName;
  final Name username;
  final Password password;
  final UserRole role;
  final FormzSubmissionStatus creationStatus;
  final String? errorMessage;
  final int salary;

  AddEmployeeState copyWith({
    Name? firstName,
    Name? lastName,
    Name? username,
    Password? password,
    UserRole? role,
    int? salary,
    FormzSubmissionStatus? creationStatus,
    String? errorMessage,
  }) =>
      AddEmployeeState(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        password: password ?? this.password,
        role: role ?? this.role,
        salary: salary ?? this.salary,
        creationStatus: creationStatus ?? this.creationStatus,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        role,
        username,
        password,
        creationStatus,
        errorMessage,
        salary,
      ];

  @override
  List<FormzInput> get inputs => [
        firstName,
        lastName,
        username,
        password,
      ];
}
