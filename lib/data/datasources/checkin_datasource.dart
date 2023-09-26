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
    int? rfidMachineId,
    int? roomId,
    String? cardId,
  }) async {
    final data = <String, dynamic>{
      if (employeeId != null) 'employee_id': employeeId,
      if (rfidMachineId != null) 'rfid_machine_id': rfidMachineId,
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
