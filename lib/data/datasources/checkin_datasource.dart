import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/models/checkin_history.dart';
import 'package:fe_cnpmn/data/models/work_day.dart';
import 'package:intl/intl.dart';

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
    return response.data!
        .map((e) => CheckinHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<WorkDay> getWorkDays(
      DateTime startDate, DateTime endDate, int? employeeId) async {
    final startTime = DateFormat('yyyy-MM-dd').format(startDate);
    final endTime = DateFormat('yyyy-MM-dd').format(endDate);

    // ignore: inference_failure_on_function_invocation
    final response = await dioClient.sendRequest.get(
      '/work_days/$employeeId',
      queryParameters: {
        'start_date': startTime,
        'end_date': endTime,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final workDays =
        (data['work_days'] as List<dynamic>).first as Map<String, dynamic>;
    // ignore: cascade_invocations
    workDays.addAll({
      'punishment_hours': data['punishment_hours'],
    });

    return WorkDay.fromJson(workDays);
  }
}
