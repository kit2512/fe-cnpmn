import 'package:dio/dio.dart';
import 'package:fe_cnpmn/config/env.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  DioClient() {
    _dio.options = BaseOptions(
      baseUrl: URL.baseURL,
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      responseType: ResponseType.json,
    );

    // _dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (RequestOptions options, handler) async {
    //       if (options.headers.containsKey('Authorization')) {
    //         final accessToken = await localDataSource.getAccessToken();
    //         options.headers['Authorization'] = 'Bearer $accessToken';
    //       }
    //       if (locale != null) {
    //         options.headers['Accept-Language'] = locale!.languageCode;
    //       }
    //       return handler.next(options);
    //     },
    //     onError: (error, handler) async {
    //       if (error.response?.statusCode == 401) {
    //         final options = error.response!.requestOptions;
    //         final prefs = await SharedPreferences.getInstance();
    //         final refreshToken = prefs.getString('refreshToken');
    //
    //         try {
    //           if (refreshToken != null) {
    //             // ignore: inference_failure_on_function_invocation
    //             final response = await _tokenDio.post(
    //               '${URL.apiUrl}users/auth/refresh/',
    //               data: {
    //                 'refresh': refreshToken,
    //               },
    //             );
    //             final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
    //             await prefs.setString('accessToken', authResponse.access);
    //             await prefs.setString('refreshToken', authResponse.refresh);
    //
    //             options.headers['Authorization'] = authResponse.access;
    //             // ignore: inference_failure_on_function_invocation
    //             final originResult = await _dio.fetch(options..path);
    //             if (originResult.statusCode != null && originResult.statusCode! ~/ 100 == 2) {
    //               return handler.resolve(originResult);
    //             }
    //           }
    //         } catch (e) {
    //           await prefs.clear();
    //           log('🐞Error: $e');
    //           return handler.next(error);
    //         }
    //       }
    //       return handler.next(error);
    //     },
    //   ),
    // );

    // TODO(hankatpixelfield): uncomment when API is fully tested
    // if (kDebugMode) {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 140,
      ),
    );
    // }
  }


  final Dio _dio = Dio();
  final Dio _tokenDio = Dio();

  Dio get sendRequest => _dio;
}
