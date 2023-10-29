import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/models/fruit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';


class DioHelper {

  var dio = Dio();

  DioHelper() {
    dio.options = BaseOptions(
        contentType: 'application/json',
        baseUrl: dotenv.get('APP_BACK_HOST')
    );
    dio.interceptors.add(
      InterceptorsWrapper(
          onRequest: (RequestOptions requestOptions, RequestInterceptorHandler handler) {
            requestOptions.headers.putIfAbsent(
                'Authorization', () => 'Bearer ${SessionManager().get('token')}');
            handler.next(requestOptions);
          }
      ),
    );
  }

  Future<List<UserFruit>> getUserFruits(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        "${dio.options.baseUrl}/api/fruits/fruits_by_date",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${await SessionManager().get('token')}',
          },
        ),
        queryParameters: params
      );
      if (response.statusCode == 200) {
        List jsonResponse = response.data["data"];
        print(jsonResponse);
        return jsonResponse.map((json) => UserFruit.fromJson(json)).toList();
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }
}