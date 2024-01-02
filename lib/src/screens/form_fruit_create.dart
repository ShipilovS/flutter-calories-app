import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/dio_helpler.dart';
import 'package:flutter_calories_app/src/models/fruit.dart';

class FormFruitCreate extends StatefulWidget {
  const FormFruitCreate({super.key});

  @override
  State<FormFruitCreate> createState() => _FormFruitCreateState();
}

class _FormFruitCreateState extends State<FormFruitCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Fruit>>? _fruits;
  Fruit? selectedFruit;

  @override
  void initState() {
    // TODO: implement initState
    _fruits = DioHelper().getFruits({});
    super.initState();
  }

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
            FutureBuilder(
              future: _fruits,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return DropdownButton<Fruit?>(
                    // Initial Value
                    isExpanded: true,
                    value: selectedFruit,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                     items: data.map((Fruit user) {
                      return DropdownMenuItem<Fruit>(
                        value: user,
                        child: Text(
                          user.name,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (Fruit? fruit) {
                      setState(() {
                        selectedFruit = fruit!;
                      });
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () async {
                  await DioHelper().createUserFriut(
                    {
                      'fruit_id': selectedFruit?.id // Ошибка?
                    }
                  );
                  Navigator.pop(context);
                  // setState(() {
                  //   _fruits = DioHelper().getFruits({});
                  // });
                  // Navigator.pushNamed(context, '/home').then((_)
                  //   => setState(() {
                  //     _fruits = DioHelper().getFruits({});
                  //   })
                  // );
                  // Navigator.pushReplacementNamed(context, '/home');
                  //
                },
                child: const Text('Создать'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
