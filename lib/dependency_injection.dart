import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/datasources/card_datasource.dart';
import 'package:fe_cnpmn/data/datasources/checkin_datasource.dart';
import 'package:fe_cnpmn/data/datasources/employee_datasource.dart';
import 'package:fe_cnpmn/data/datasources/rfid_datasource.dart';
import 'package:fe_cnpmn/data/datasources/room_datasource.dart';
import 'package:fe_cnpmn/data/repositories/card_repository.dart';
import 'package:fe_cnpmn/data/repositories/checkin_history_repository.dart';
import 'package:fe_cnpmn/data/repositories/days_off_repository.dart';
import 'package:fe_cnpmn/data/repositories/employee_repository.dart';
import 'package:fe_cnpmn/data/repositories/rfid_repository.dart';
import 'package:fe_cnpmn/data/repositories/rooms_repository.dart';
import 'package:fe_cnpmn/pages/employees_page/cubit/employees_cubit.dart';
import 'package:fe_cnpmn/pages/rooms_page/cubit/rooms_cubit/rooms_cubit.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/days_off_datasource.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt
    ..registerLazySingleton<DioClient>(
      DioClient.new,
    )
    ..registerLazySingleton(
      () => DaysOffDataSource(
        getIt<DioClient>(),
      ),
    )
    ..registerLazySingleton<EmployeeDataSource>(
      () => EmployeeDataSource(
        dio: getIt<DioClient>(),
      ),
    )
    ..registerLazySingleton<CardDatasource>(
      () => CardDatasource(
        dioClient: getIt<DioClient>(),
      ),
    )
    ..registerLazySingleton<RfidDatasource>(
      () => RfidDatasource(
        dioClient: getIt<DioClient>(),
      ),
    )
    ..registerLazySingleton<RoomDatasource>(
      () => RoomDatasource(dioClient: getIt<DioClient>()),
    )
    ..registerLazySingleton<CheckinDatasource>(
      () => CheckinDatasource(
        dioClient: getIt<DioClient>(),
      ),
    )
    ..registerLazySingleton(
      () => DaysOffRepository(
        getIt<DaysOffDataSource>(),
      ),
    )
    ..registerLazySingleton<RfidRepository>(
      () => RfidRepository(
        rfidDatasource: getIt<RfidDatasource>(),
      ),
    )
    ..registerLazySingleton<CardRepository>(
      () => CardRepository(
        cardDataSource: getIt<CardDatasource>(),
      ),
    )
    ..registerLazySingleton<EmployeeRepository>(
      () => EmployeeRepository(
        employeeDatasource: getIt<EmployeeDataSource>(),
      ),
    )
    ..registerLazySingleton<RoomRepository>(
      () => RoomRepository(
        roomDatasource: getIt<RoomDatasource>(),
      ),
    )
    ..registerLazySingleton<EmployeesCubit>(
      () => EmployeesCubit(
        employeeRepository: getIt<EmployeeRepository>(),
      ),
    )
    ..registerLazySingleton<CheckinRepository>(
      () => CheckinRepository(
        checkinDatasource: getIt<CheckinDatasource>(),
      ),
    )
    ..registerLazySingleton<RoomsCubit>(
      () => RoomsCubit(
        roomRepository: getIt<RoomRepository>(),
      ),
    );
}
