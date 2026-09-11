import 'package:dio/dio.dart';
import 'package:dailyfeed/core/exceptions.dart';

/// Thin wrapper around Dio. Converts every Dio error into an [AppException].
class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    );
  }

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    return _handle(() => _dio.get<dynamic>(url, queryParameters: query));
  }

  Future<Map<String, dynamic>> post(String url, {Object? body}) async {
    return _handle(() => _dio.post<dynamic>(url, data: body));
  }

  Future<Map<String, dynamic>> _handle(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      final data = response.data;
      if (data is Map) return Map<String, dynamic>.from(data);
      throw AppException.invalidResponse();
    } on DioException catch (e) {
      throw _mapError(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Something went wrong. Please try again.');
    }
  }

  AppException _mapError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppException.timeout();

      case DioExceptionType.connectionError:
        return AppException.noInternet();

      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 401 || status == 403) return AppException.unauthorized();
        final message = _extractMessage(error.response?.data);
        return AppException.server(message ?? 'Server error ($status).');

      default:
        return AppException.noInternet();
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map && data['message'] is String)
      return data['message'] as String;
    return null;
  }
}
