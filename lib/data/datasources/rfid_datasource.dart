import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/models/rfid_machine.dart';

class RfidDatasource {
  const RfidDatasource({
    required this.dioClient,
  });

  final DioClient dioClient;

  Future<List<RfidMachine>> getRfids({int? roomId}) async {
    final Response<List<dynamic>> response = await dioClient.sendRequest.get(
      '/rfids',
      queryParameters: {
        if (roomId != null) 'room_id': roomId,
      },
    );
    return response.data!
        .map(
          (e) => RfidMachine.fromJson(e as Map<String, dynamic>),
        )
        .toList(growable: false);
  }
}
