import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/errors/failure.dart';
import 'package:fe_cnpmn/config/errors/network_exception.dart';
import 'package:fe_cnpmn/data/datasources/rfid_datasource.dart';
import 'package:fe_cnpmn/data/models/rfid_machine.dart';

class RfidRepository {
  const RfidRepository({
    required this.rfidDatasource,
  });

  final RfidDatasource rfidDatasource;

  Future<Either<Failure, List<RfidMachine>>> getRfids({int? roomId}) async {
    try {
      final result = await rfidDatasource.getRfids(
        roomId: roomId,
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
}
