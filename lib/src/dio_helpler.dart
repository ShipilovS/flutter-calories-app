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
          onRequest: (RequestOptions requestOptions, RequestInterceptorHandler handler) async {
            String token = await SessionManager().get('token');
            requestOptions.headers.putIfAbsent(
                'Authorization', () => 'Bearer $token');
            handler.next(requestOptions);
          }
      ),
    );
  }

  Future<List<UserFruit>> getUserFruits(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        "${dio.options.baseUrl}/api/fruits/fruits_by_date",
        queryParameters: params
      );
      if (response.statusCode == 200) {
        List jsonResponse = response.data["data"];
        return jsonResponse.map((json) => UserFruit.fromJson(json)).toList();
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }

  Future<List<Fruit>> getFruits(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
          "${dio.options.baseUrl}/api/fruits",
          queryParameters: params
      );
      if (response.statusCode == 200) {
        List jsonResponse = response.data["data"];
        return jsonResponse.map((json) => Fruit.fromJson(json)).toList();
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }

  Future<List<Fruit>> getFavorites(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
          "${dio.options.baseUrl}/api/favorites",
          queryParameters: params
      );
      if (response.statusCode == 200) {
        List jsonResponse = response.data["data"];
        return jsonResponse.map((json) => Fruit.fromJson(json)).toList();
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }

  Future<Fruit> createUserFriut(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(
          "${dio.options.baseUrl}/api/fruits/create_user_fruit",
          data: {
            'fruit': params
          }
      );
      if (response.statusCode == 201) {
        var jsonResponse = response.data["data"];
        return Fruit.fromJson(jsonResponse as Map<String, dynamic>);
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }

  Future<void> createFavorite(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(
          "${dio.options.baseUrl}/api/favorites",
        queryParameters: params
      );
      if (response.statusCode == 201) {
        print("Successful created Favorite");
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }

  Future<void> destroyUserFruit(int id) async {
    try {
      final response = await dio.delete(
          "${dio.options.baseUrl}/api/fruits/${id.toInt()}/destroy_user_fruit",
      );
      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }

  Future<void> destroyFavorite(int id) async {
    try {
      final response = await dio.delete(
        "${dio.options.baseUrl}/api/favorites/${id.toInt()}",
      );
      if (response.statusCode == 204) {
        print("Successful destroyed");
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }

  Future<Fruit> getFruit(int id) async {
    try {
      final response = await dio.get(
        "${dio.options.baseUrl}/api/fruits/${id.toInt()}",
      );
      if (response.statusCode == 200) {
        var jsonResponse = response.data['data'];
        return Fruit.fromJson(jsonResponse);
      } else {
        throw Exception('Error');
      }
    } on DioException catch (e) {
      print('[Error] => ${e}');
      throw e;
    }
  }
}