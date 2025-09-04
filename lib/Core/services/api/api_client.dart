import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api_constants.dart';
import 'dio_factory.dart';

abstract class ApiClient {
  /// get request
  Future<Response> get(
    String uri, {
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    CancelToken? cancelToken,
  });

  /// post request
  Future<Response> post(
    String uri, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  });

  /// update request
  Future<Response> put(
    String uri, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    CancelToken? cancelToken,
  });

  /// delete request
  Future<Response> delete(
    String uri, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    CancelToken? cancelToken,
  });

  ///
  Future<Response> head(String uri, {Map<String, dynamic>? headers, CancelToken? cancelToken});
}

class DioClient implements ApiClient {
  //
  late final DioFactory _dioFactory;
  late final Map<String, String> defaultHeaders;
  late final BaseOptions options;
  //
  DioClient() {
    //
    _dioFactory = DioFactory();
    //
    defaultHeaders = {
      ApiHeaders.headerContentTypeKey: ApiHeaders.headerContentTypeJson,
      ApiHeaders.headerAcceptKey: ApiHeaders.headerContentTypeJson,
    };
    //
    options = BaseOptions(
      headers: defaultHeaders,
      baseUrl: ApiSettings.baseUrl,
      receiveTimeout: const Duration(seconds: ApiSettings.receiveTimeout),
      sendTimeout: const Duration(seconds: ApiSettings.sendTimeout),
      connectTimeout: const Duration(seconds: ApiSettings.connectTimeout),
      validateStatus: (status) {
        return true;
      },
    );
  }
  //

  @override
  Future<Response> get(
    String uri, {
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) async {
    final dio = await _getDio(
      headers: headers,
      params: queryParameters,
      responseType: responseType,
    );
    final response = dio.get(uri);
    return response;
  }

  @override
  Future<Response> post(
    String uri, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final dio = await _getDio(
      headers: headers,
      params: queryParameters,
      responseType: responseType,
    );
    final response = dio.post(
      uri,
      data: body,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return response;
  }

  @override
  Future<Response> put(
    String uri, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) async {
    final dio = await _getDio(
      headers: headers,
      params: queryParameters,
      responseType: responseType,
    );
    final response = dio.put(uri, data: body);
    return response;
  }

  @override
  Future<Response> delete(
    String uri, {
    Object? body,
    Map<String, dynamic>? headers,
    Map<String, dynamic> queryParameters = const {},
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) async {
    final dio = await _getDio(
      headers: headers,
      params: queryParameters,
      responseType: responseType,
    );
    final response = dio.delete(uri, data: body);
    return response;
  }

  /// head request
  @override
  Future<Response> head(String uri, {Map<String, dynamic>? headers, CancelToken? cancelToken}) async {
    final dio = await _getDio(headers: headers);
    final response = dio.head(uri, cancelToken: cancelToken);
    return response;
  }

  Future<Dio> _getDio({
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    ResponseType? responseType,
  }) async {
    //
    final Dio dio = _dioFactory();
    //
    options.headers = headers ?? defaultHeaders;
    //
    options.headers[ApiHeaders.headerAcceptKey] = ApiHeaders.headerContentTypeJson;
    //
    options.queryParameters = params ?? {};
    //
    dio.options = options.copyWith(responseType: responseType);
    //
    return dio;
  }
}
