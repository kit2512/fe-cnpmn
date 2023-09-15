import 'package:fe_cnpmn/data/datasources/employee_datasource.dart';

class EmployeeRepository {
  EmployeeRepository({
    required this.employeeDatasource,
  });

  final EmployeeDataSource employeeDatasource;
}
