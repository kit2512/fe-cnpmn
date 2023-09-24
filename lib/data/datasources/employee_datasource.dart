import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/dio_config.dart';
import 'package:fe_cnpmn/data/models/employee.dart';
import 'package:fe_cnpmn/enums/user_role_enum.dart';

class EmployeeDataSource {
  EmployeeDataSource({
    required this.dio,
  });

  final DioClient dio;

  Future<List<Employee>> getEmployees({
    int? roomId,
  }) async {
    final Response<List<dynamic>> response = await dio.sendRequest.get(
      'employees',
      data: roomId != null
          ? {
              'room_id': roomId,
            }
          : null,
    );
    return response.data!.map((e) => Employee.fromJson(e as Map<String, dynamic>)).toList(
          growable: false,
        );
  }

  Future<Employee> createEmployee({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required UserRole role,
  }) async {
    final Response<Map<String, dynamic>> response = await dio.sendRequest.post('employee/create', data: {
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'password': password,
      'role': role.name,
    });
    return Employee.fromJson(response.data!);
  }

  Future<Employee> getEmployeeDetails({
    required int id,
  }) async {
    final Response<Map<String, dynamic>> response = await dio.sendRequest.get('/employee/$id');
    return Employee.fromJson(response.data!);
  }

  Future<bool> deleteEmployee({required int id}) async {
    final Response<Map<String, dynamic>> response = await dio.sendRequest.delete(
      '/employee/delete',
      queryParameters: {'employee_id': id},
    );
    return response.data!['success'] as bool;
  }
}
