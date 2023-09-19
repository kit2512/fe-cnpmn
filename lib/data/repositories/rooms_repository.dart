import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/errors/failure.dart';
import 'package:fe_cnpmn/config/errors/network_exception.dart';
import 'package:fe_cnpmn/data/datasources/room_datasource.dart';
import 'package:fe_cnpmn/data/models/room.dart';

class RoomRepository {
  const RoomRepository({
    required this.roomDatasource,
  });

  final RoomDatasource roomDatasource;

  Future<Either<Failure, List<Room>>> getRooms({int? employeeId}) async {
    try {
      final result = await roomDatasource.getRooms(
        employeeId: employeeId,
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
