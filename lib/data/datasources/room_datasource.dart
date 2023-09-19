import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/models/room.dart';

class RoomDatasource {
  const RoomDatasource({required this.dioClient});

  final DioClient dioClient;

  Future<List<Room>> getRooms({int? employeeId}) async {
    final Response<List<dynamic>> response = await dioClient.sendRequest.get(
      '/rooms',
      queryParameters: employeeId == null
          ? null
          : {
              'employee_id': employeeId,
            },
    );
    return response.data!
        .map(
          (e) => Room.fromJson(e as Map<String, dynamic>),
        )
        .toList(growable: false);
  }
}
