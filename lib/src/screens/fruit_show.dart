import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/dio_helpler.dart';
import 'package:flutter_calories_app/src/models/fruit.dart';

class FruitShowScreen extends StatefulWidget {
  const FruitShowScreen({super.key});
  @override
  State<FruitShowScreen> createState() => _FruitShowScreenState();
}

class _FruitShowScreenState extends State<FruitShowScreen> {
  late Future<Fruit> _fruit;

  @override
  void initState() {
    // TODO: implement initState
    // setState(() {
    //   _fruit = DioHelper().getFruit(args['id'].toInt());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // переместить в конструктор
    final args = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о продукте'), // не показыватся нигде?
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("id - ${args['id'].toString()}"),
            Text("описание - ${args['description'].toString()}"),
          ],
        ),
      ),
    );
  }
}
