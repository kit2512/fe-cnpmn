import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/models/day_off_model.dart';

class DaysOffDataSource {
  DaysOffDataSource(this._dio);

  final DioClient _dio;

  Future<DayOffModel> createDayOff(DayOffModel newDayOff) async {
    final response = await _dio.sendRequest.post<Map<String, dynamic>>(
      '/days_off/create',
      data: newDayOff.toJson(),
    );
    return DayOffModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<DayOffModel> updateDayOff(DayOffModel dayOff) async {
    final response = await _dio.sendRequest.put<Map<String, dynamic>>(
      '/days_off',
      data: dayOff.toJson(),
    );
    return DayOffModel.fromJson(response.data as Map<String, dynamic>);
  }
}

