import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint(
            'REQUEST: ${options.method} ${options.uri}',
          );

          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            'RESPONSE: ${response.statusCode} '
            '${response.requestOptions.uri}',
          );

          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(
            'ERROR: ${error.response?.statusCode} '
            '${error.message}',
          );

          handler.next(error);
        },
      ),
    );
  }
}