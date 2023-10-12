import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/models/checkin_history.dart';

class CheckinDatasource {
  const CheckinDatasource({
    required this.dioClient,
  });

  final DioClient dioClient;

  Future<List<CheckinHistory>> getCheckinHistory({
    int? employeeId,
    int? rfidId,
    int? roomId,
    String? cardId,
  }) async {
    final data = <String, dynamic>{
      if (employeeId != null) 'employee_id': employeeId,
      if (rfidId != null) 'rfid_id': rfidId,
      if (roomId != null) 'room_id': roomId,
      if (cardId != null) 'card_id': cardId,
    };
    final Response<List<dynamic>> response = await dioClient.sendRequest.get(
      '/checkin/history',
      queryParameters: data,
    );
    return response.data!.map((e) => CheckinHistory.fromJson(e as Map<String, dynamic>)).toList();
  }
}
