import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/errors/failure.dart';
import 'package:fe_cnpmn/config/errors/network_exception.dart';
import 'package:fe_cnpmn/data/datasources/card_datasource.dart';
import 'package:fe_cnpmn/data/models/card.dart';

class CardRepository {
  const CardRepository({required this.cardDataSource});

  final CardDatasource cardDataSource;

  Future<Either<Failure, List<RfidCard>>> getCards({
    bool isAvailable = false,
  }) async {
    try {
      final result = await cardDataSource.getCards(isAvailable: isAvailable);
      return Right(result);
    } on DioException catch (e) {
      final exception = NetworkException.getDioException(e);
      return Left(NetworkFailure(exception));
    } catch (_) {
      return Left(NetworkFailure(const NetworkException.unexpectedError()));
    }
  }

  Future<Either<Failure, RfidCard>> addCard({
    required String cardId,
    int? employeeId,
  }) async {
    try {
      final result = await cardDataSource.createCard(
        cardId: cardId,
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

  Future<Either<Failure,RfidCard >>deleteCard({required String cardId}) async {
    try {
      final result = await cardDataSource.deleteCard(
        cardId: cardId,
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
