import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../components/dialog/snack_bar.dart';
import '../constants/api_path.dart';
import '../logger/print_log.dart';

class Repository {
  static Future<Response> apiRequest({
    required String path,
    String method = 'GET',
    dynamic body,
    dynamic queryParameters,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: APIPath.baseUrl))
      ..interceptors.add(DioInterceptor());

    final response = await dio.request(
      path,
      data: body,
      queryParameters: queryParameters,
      options: Options(
        method: method,
        followRedirects: false,
        validateStatus: (status) => true,
      ),
    );

    return response;
  }
}

class DioInterceptor extends Interceptor {
  @override
  Future<void> onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      final req = response.requestOptions;
      if (response.statusCode != 200) {
        printLog('${req.method.toUpperCase()} - ${req.uri}', isError: true);
        if (req.data != null) printLog(req.data, isError: true);
        printLog('${response.statusCode} - ${response.data}', isError: true);
      } else {
        printLog(
            '${response.statusCode} - ${req.method.toUpperCase()} ${req.uri}');
      }
    }
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    showSnackBar(
      text: 'Got error ${err.response?.statusCode ?? 500} when fetch data',
      type: SnackBarType.error,
    );
    return super.onError(err, handler);
  }
}

bool isNetworkError(Object e) {
  return e is DioException &&
      e.type == DioExceptionType.unknown &&
      e.error is IOException;
}

void onCatchError(String flag, Object e, StackTrace s) {
  printLog('$flag error: $e, stacktrace: $s', isError: true);
  showSnackBar(
    text: isNetworkError(e)
        ? 'Check your internet connection'
        : 'Something went wrong',
    type: SnackBarType.error,
  );
}

void onError(Response response) {
  showSnackBar(
    text: 'Got error ${response.statusCode ?? 500} when fetch data',
    type: SnackBarType.error,
  );
}
