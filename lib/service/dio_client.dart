import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'app_error_handler.dart';

/// Dio HTTP client with request timeout, retry mechanism, and error handling
/// Handles 30s timeout and retries failed requests up to 3 times
class DioClient {
  static final Dio _dio = Dio();

  /// Initialize Dio with interceptors
  static void initialize() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );

    // Add logging interceptor
    _dio.interceptors.add(LoggingInterceptor());

    // Add retry interceptor
    _dio.interceptors.add(RetryInterceptor());
  }

  /// Get Dio instance
  static Dio getInstance() => _dio;

  /// GET request with retry
  static Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      developer.log('GET Error: $url - $e');
      throw AppErrorHandler.getErrorMessage(e);
    }
  }

  /// POST request with retry
  static Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      developer.log('POST Error: $url - $e');
      throw AppErrorHandler.getErrorMessage(e);
    }
  }

  /// PUT request with retry
  static Future<dynamic> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      developer.log('PUT Error: $url - $e');
      throw AppErrorHandler.getErrorMessage(e);
    }
  }

  /// DELETE request with retry
  static Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } catch (e) {
      developer.log('DELETE Error: $url - $e');
      throw AppErrorHandler.getErrorMessage(e);
    }
  }

  /// Handle API response
  static dynamic _handleResponse(Response response) {
    if (response.statusCode == null) {
      throw Exception('No response status code');
    }

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else if (response.statusCode == 401) {
      throw '401: Unauthorized';
    } else if (response.statusCode == 403) {
      throw '403: Forbidden';
    } else if (response.statusCode == 404) {
      throw '404: Not Found';
    } else if (response.statusCode! >= 500) {
      throw '${response.statusCode}: Server Error';
    } else {
      throw 'Error: ${response.statusCode} - ${response.statusMessage}';
    }
  }
}

/// Logging interceptor for debugging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('→ ${options.method} ${options.path}', name: 'HTTP Request');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.path}',
      name: 'HTTP Response',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log('✗ ${err.type} - ${err.message}', name: 'HTTP Error');
    handler.next(err);
  }
}

/// Retry interceptor - retries failed requests up to 3 times
class RetryInterceptor extends Interceptor {
  static const int maxRetries = 3;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestOptions = err.requestOptions;

    // Don't retry if it's a 401 or 403
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      handler.next(err);
      return;
    }

    // Get retry count from headers (custom header)
    int retryCount =
        int.tryParse(
          requestOptions.headers['X-Retry-Count']?.toString() ?? '0',
        ) ??
        0;

    if (retryCount < maxRetries &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.unknown)) {
      // Increment retry count
      requestOptions.headers['X-Retry-Count'] = (retryCount + 1).toString();

      developer.log(
        'Retrying ${requestOptions.method} ${requestOptions.path} (Attempt ${retryCount + 1}/$maxRetries)',
        name: 'HTTP Retry',
      );

      // Retry with exponential backoff (1s, 2s, 4s)
      Future.delayed(Duration(seconds: 1 << retryCount)).then((_) async {
        try {
          final response = await DioClient.getInstance().request(
            requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              sendTimeout: requestOptions.sendTimeout,
              receiveTimeout: requestOptions.receiveTimeout,
              headers: requestOptions.headers,
            ),
          );
          handler.resolve(response);
        } catch (e) {
          handler.next(err);
        }
      });
    } else {
      handler.next(err);
    }
  }
}
