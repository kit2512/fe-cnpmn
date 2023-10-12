import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/models/card.dart';

class CardDatasource {
  const CardDatasource({
    required this.dioClient,
  });

  final DioClient dioClient;

  Future<List<RfidCard>> getCards({
    bool isAvailable = false,
  }) async {
    final Response<List<dynamic>> response = await dioClient.sendRequest.get(
      'cards',
      queryParameters: {
        'is_available': isAvailable,
      },
    );
    return response.data!.map((e) => RfidCard.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<RfidCard> createCard({required String cardId, int? employeeId}) async {
    final Response<Map<String, dynamic>> response = await dioClient.sendRequest.post(
      'card/create',
      data: {
        'id': cardId,
        if (employeeId != null) 'employee_id': employeeId,
      },
    );
    return RfidCard.fromJson(response.data!);
  }

  Future<RfidCard> deleteCard({required String cardId}) async {
    final Response<Map<String, dynamic>> response = await dioClient.sendRequest.delete(
      'card/delete/$cardId',
    );
    return RfidCard.fromJson(response.data!);
  }
}
