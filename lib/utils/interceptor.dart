// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:sereports/repository/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeReportInterceptor implements InterceptorContract {
  late final BuildContext context;

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final authRepo = AuthRepo(preferences);
    final token = await authRepo.getToken();
    print("Token: $token");
    if (token == null || token.isEmpty) {
      if (context.mounted) {
        authRepo.redirectToLogin(context);
      }
    }

    request.headers[HttpHeaders.authorizationHeader] = "Bearer $token";

    request.headers[HttpHeaders.contentTypeHeader] = "application/json";

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}
