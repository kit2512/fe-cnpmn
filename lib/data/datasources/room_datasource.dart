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

  Future<Room> createRoom({required String name}) async {
    final Response<Map<String, dynamic>> response = await dioClient.sendRequest.post(
      '/room/create',
      data: {'name': name},
    );
    return Room.fromJson(response.data!);
  }

  Future<bool> assignEmployee({
    required int roomId,
    required List<int> employeeIds,
  }) async {
    final Response<dynamic> response = await dioClient.sendRequest.post(
      'room/assign_employees',
      data: {
        'room_id': roomId,
        'employee_ids': employeeIds,
      },
    );
    return true;
  }
}
