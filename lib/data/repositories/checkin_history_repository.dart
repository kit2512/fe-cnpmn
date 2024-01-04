import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/errors/failure.dart';
import 'package:fe_cnpmn/config/errors/network_exception.dart';
import 'package:fe_cnpmn/data/datasources/checkin_datasource.dart';
import 'package:fe_cnpmn/data/models/checkin_history.dart';
import 'package:fe_cnpmn/data/models/work_day.dart';

class CheckinRepository {
  const CheckinRepository({
    required this.checkinDatasource,
  });

  final CheckinDatasource checkinDatasource;

  Future<Either<Failure, List<CheckinHistory>>> getCheckinHistory({
    int? employeeId,
    String? cardId,
    int? roomId,
    int? rfidId,
  }) async {
    try {
      final result = await checkinDatasource.getCheckinHistory(
        employeeId: employeeId,
        roomId: roomId,
        cardId: cardId,
        rfidId: rfidId,
      );
      return Right(result);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, WorkTime>> getWorkTime(
    DateTime startDate,
    DateTime endDate,
    int employeeId,
  ) async {
    try {
      final result =
          await checkinDatasource.getWorkTime(startDate, endDate, employeeId);
      return Right(result);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }
}
