import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApiExposer {
  var _response;

  void callApi(
      {context: BuildContext,
      authToken: String,
      dynamic body,
      url: String,
      onSuccess: Function,
      onError: Function,
      onAuthFailure: Function}) async {
    try {
      BaseOptions options = BaseOptions(
          connectTimeout: 30000,
          receiveTimeout: 30000,
          contentType: Headers.jsonContentType);

      options.headers['Authorization'] = 'Bearer $authToken';

      _response = await Dio(options).post(url, data: body);
      onSuccess(_response.data);
    } catch (e) {
      handleError(e, onAuthFailure, onError);
    }
  }

  void handleError(e, Function onAuthFailure, Function onError) {
    var _errorMessage = '';
    if (e is SocketException) {
      _errorMessage = 'You are not connected to the Internet';
      onError(_errorMessage);
    } else if (e is TimeoutException) {
      _errorMessage = 'There seems to be an error with your connection';
      onError(_errorMessage);
    } else if (e is DioError) {
      if (e.response != null) {
        _errorMessage =
            'Your wifi firewall may be blocking your access to our service.\n\nPlease ask your admin to whitelist AWS - Amazon Web Services or switch to your Mobile Internet';
        onError(_errorMessage);
      } else {
        if (e.type == DioErrorType.DEFAULT) {
          _errorMessage = 'You are not connected to the Internet';
          onError(_errorMessage);
        }
      }
    } else {
      _errorMessage = e.toString();
      onError(_errorMessage);
    }
  }
}
