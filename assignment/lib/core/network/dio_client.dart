import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

/// Configured Dio HTTP client with timeouts, logging, and unified error interceptors.
class DioClient {
  final Dio dio;

  DioClient({Dio? customDio}) : dio = customDio ?? Dio() {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: false,
          error: true,
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          final mappedException = mapDioException(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: mappedException,
              message: mappedException.toString(),
            ),
          );
        },
      ),
    );
  }

  /// Maps DioException to domain-friendly ServerException or NetworkException.
  static Exception mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Connection timed out. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String errorMessage = 'Server error occurred ($statusCode)';
        if (data is String && data.isNotEmpty) {
          errorMessage = data;
        } else if (data is Map<String, dynamic>) {
          errorMessage = data['message']?.toString() ??
              data['error']?.toString() ??
              errorMessage;
        }
        return ServerException(
          message: errorMessage,
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerException(message: 'Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Bad SSL certificate.');
      case DioExceptionType.transformTimeout:
        return const NetworkException(message: 'Request transform timed out.');
      case DioExceptionType.unknown:
        return NetworkException(
          message: error.message ?? 'An unexpected network error occurred.',
        );
    }
  }
}
