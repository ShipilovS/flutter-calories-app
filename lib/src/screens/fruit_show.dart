import 'package:flutter/material.dart';

class FruitShowScreen extends StatefulWidget {
  const FruitShowScreen({super.key});
  @override
  State<FruitShowScreen> createState() => _FruitShowScreenState();
}

class _FruitShowScreenState extends State<FruitShowScreen> {

  @override
  void initState() {

    // TODO: implement initState
    setState(() {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // переместить в конструктор
    final args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о продукте'), // не показыватся нигде?
        backgroundColor: Colors.blueAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}

