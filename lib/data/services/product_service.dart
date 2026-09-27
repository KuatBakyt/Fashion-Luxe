import 'package:dio/dio.dart';
import 'package:luxe/core/error/app_exeption.dart';

import '../models/product.dart';

class ProductService {
  final Dio dio;

  ProductService(this.dio);

  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get('/products');

      final List<dynamic> data = response.data;

      return data
          .map(
            (json) => Product.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  AppException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 401:
          case 403:
            return const UnauthorizedException();

          case 404:
            return const NotFoundException();

          case 500:
          case 502:
          case 503:
          case 504:
            return const ServerException();

          default:
            return const UnknownException();
        }

      default:
        return const UnknownException();
    }
  }
}