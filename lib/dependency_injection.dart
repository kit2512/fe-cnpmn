import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/datasources/employee_datasource.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/pages/employees_page/cubit/employees_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() async {
  getIt
    ..registerLazySingleton<DioClient>(
      DioClient.new,
    )
    ..registerLazySingleton<EmployeeDataSource>(
      () => EmployeeDataSource(
        dio: getIt<DioClient>(),
      ),
    )
    ..registerLazySingleton<EmployeeRepository>(
      () => EmployeeRepository(
        employeeDatasource: getIt<EmployeeDataSource>(),
      ),
    )
    ..registerLazySingleton<EmployeesCubit>(
      () => EmployeesCubit(
        employeeRepository: getIt<EmployeeRepository>(),
      ),
    );
}
