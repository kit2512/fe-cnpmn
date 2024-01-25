import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/errors/failure.dart';
import 'package:fe_cnpmn/config/errors/network_exception.dart';
import 'package:fe_cnpmn/data/datasources/employee_datasource.dart';
import 'package:fe_cnpmn/data/models/employee.dart';
import 'package:fe_cnpmn/enums/user_role_enum.dart';

class EmployeeRepository {
  EmployeeRepository({
    required this.employeeDatasource,
  });

  final EmployeeDataSource employeeDatasource;

  Future<Either<Failure, List<Employee>>> getEmployees({
    int? roomId,
  }) async {
    try {
      final result = await employeeDatasource.getEmployees(roomId: roomId);
      return Right(result);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, Employee>> createEmployee({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required UserRole role,
    required int salary,
    required String email,
  }) async {
    try {
      final result = await employeeDatasource.createEmployee(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        role: role,
        salary: salary,
        email: email,
      );
      return Right(result);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, Employee>> getEmployeeDetails({
    required int id,
  }) async {
    try {
      final result = await employeeDatasource.getEmployeeDetails(
        id: id,
      );
      return Right(result);
    } on DioException catch (e) {
      rethrow;
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      rethrow;
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, bool>> deleteEmployee({required int id}) async {
    try {
      final result = await employeeDatasource.deleteEmployee(
        id: id,
      );
      return Right(result);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, bool>> assignRooms({
    required int employeeId,
    required List<int> roomIds,
  }) async {
    try {
      final result = await employeeDatasource.assignRooms(
        employeeId: employeeId,
        roomIds: roomIds,
      );
      return Right(result);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }
}
