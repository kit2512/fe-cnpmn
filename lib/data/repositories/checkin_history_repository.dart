import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/errors/failure.dart';
import 'package:fe_cnpmn/config/errors/network_exception.dart';
import 'package:fe_cnpmn/data/datasources/checkin_datasource.dart';
import 'package:fe_cnpmn/data/models/checkin_history.dart';

class CheckinRepository {
  const CheckinRepository({
    required this.checkinDatasource,
  });

  final CheckinDatasource checkinDatasource;

  Future<Either<Failure, List<CheckinHistory>>> getCheckinHistory({
    int? employeeId,
    String? cardId,
    int? roomId,
    int? rfidMachineId,
  }) async {
    try {
      final result = await checkinDatasource.getCheckinHistory(
        employeeId: employeeId,
        roomId: roomId,
        cardId: cardId,
        rfidMachineId: rfidMachineId,
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
