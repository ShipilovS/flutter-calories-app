import 'dart:ffi';

import 'package:intl/intl.dart';

class Fruit {
  final int id;
  final String name;
  final String size_gram;
  final String kilocalories;
  final bool is_favorite; // bool
  final String description;

  const Fruit({
    required this.id,
    required this.name,
    required this.size_gram,
    required this.kilocalories,
    required this.is_favorite,
    required this.description,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      id:           json['id'],
      name:         json['name']            == null ? "" : json['name'],
      size_gram:    json['size_gram']       == null ? "" : json['size_gram'],
      kilocalories: json['kilocalories']    == null ? "" : json['kilocalories'],
      is_favorite:  json['is_favorite']     == false ? false : true,
      description:  json['description']     == null ? "" : json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size_gram': size_gram,
      'kilocalories': kilocalories,
      'is_favorite': is_favorite,
      'description': description,
    };
  }
}

class UserFruit {
  final int id;
  final int user_id;
  final int fruit_id;
  final String fruit_name;
  final String selected_date; // #date?

  const UserFruit({
    required this.id,
    required this.user_id,
    required this.fruit_id,
    required this.fruit_name,
    required this.selected_date
  });

  factory UserFruit.fromJson(Map<String, dynamic> json) {
    return UserFruit(
      id:             json['id'],
      user_id:        json['user_id']       == null ? "" : json['user_id'],
      fruit_name:     json['fruit_name']    == null ? "" : json['fruit_name'],
      fruit_id:       json['fruit_id']      == null ? "" : json['fruit_id'],
      selected_date:  json['selected_date'] == null ? "" : json['selected_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'fruit_id': fruit_id,
      'fruit_name': fruit_name,
      'selected_date': selected_date,
    };
  }
}