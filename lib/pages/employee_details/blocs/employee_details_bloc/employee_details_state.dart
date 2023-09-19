part of 'employee_details_cubit.dart';

class EmployeeDetailsState extends Equatable {
  const EmployeeDetailsState({
    required this.errorMessage,
    required this.detailsStatus,
    required this.deleteStatus,
    this.details,
    this.id,
  });

  factory EmployeeDetailsState.initial() =>
      const EmployeeDetailsState(
        errorMessage: '',
        detailsStatus: FormzSubmissionStatus.initial,
        deleteStatus: FormzSubmissionStatus.initial,
      );

  final FormzSubmissionStatus detailsStatus;
  final int? id;
  final FormzSubmissionStatus deleteStatus;
  final Employee? details;
  final String errorMessage;

  @override
  List<Object?> get props =>
      [
        detailsStatus,
        deleteStatus,
        details,
        errorMessage,
        id,
      ];

  EmployeeDetailsState copyWith({
    int? id,
    FormzSubmissionStatus? detailsStatus,
    FormzSubmissionStatus? deleteStatus,
    Employee? details,
    String? errorMessage,

  }) =>
      EmployeeDetailsState(
        id: id ?? this.id,
        errorMessage: errorMessage ?? this.errorMessage,
        detailsStatus: detailsStatus ?? this.detailsStatus,
        details: details ?? this.details,
        deleteStatus: deleteStatus ?? this.deleteStatus,
      );
}
