import 'package:flutter/material.dart';

class FormFruitCreate extends StatefulWidget {
  const FormFruitCreate({super.key});

  @override
  State<FormFruitCreate> createState() => _FormFruitCreateState();
}

class _FormFruitCreateState extends State<FormFruitCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
              hintText: 'Enter Something',
                contentPadding: EdgeInsets.all(20.0),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
