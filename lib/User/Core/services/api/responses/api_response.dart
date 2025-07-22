import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moatmat_app/User/Core/errors/exceptions.dart';

class ApiResponse {
  //
  final bool? status;
  //
  final int? statusCode;
  //
  final String message;
  // hold incoming data from response
  final dynamic data;
  // hold any errors details
  final Map<String, dynamic>? errors;
  //
  final int? currentPage;
  final int? lastPage;

  ApiResponse({
    this.status,
    this.statusCode,
    this.errors,
    required this.message,
    required this.data,
    this.currentPage,
    this.lastPage,
  });

  factory ApiResponse.empty() {
    return ApiResponse(
      message: "",
      data: [],
    );
  }

  void throwErrorIfExists() {
    if (status == true || statusCode == 200) {
      return;
    }
    if (statusCode == 401) {
      throw ServerException();
    }
    if (status == false || status == null || (errors?.isNotEmpty ?? false)) {
      throw ServerException();
    }

    throw ServerException();
  }

  dynamic getData({dynamic key}) {
    if (key != null) {
      return data[key];
    }
    return data;
  }

  String getMessage() {
    //
    String details = message;
    //
    if (errors != null || errors != {}) {
      //
      details += ' : \n';
      //
      (errors ?? {}).forEach((key, value) {
        details += (value as List).first;
      });
      //
    }
    //
    return details;
  }

  factory ApiResponse.fromDioResponse(Response response) {
    return ApiResponse(
      data: response.data["data"] ?? [],
      status: (response.data["status"] as bool?) ?? false,
      statusCode: response.statusCode,
      errors: response.data["errors"],
      message: response.data["message"] ?? "",
      currentPage: response.data["current_page"] ?? 0,
      lastPage: response.data["last_page"] ?? 0,
    );
  }
}
