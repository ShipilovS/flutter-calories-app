import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/dio_helpler.dart';
import 'package:flutter_calories_app/src/models/fruit.dart';
import 'package:flutter_calories_app/src/screens/form_fruit_create.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dio = Dio();

  DateTime _selectedDate = DateTime.now();
  int currentPageIndex = 0;
  String currentTitle = 'Продукты';
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;
  late Future<List<UserFruit>>? _user_fruits;
  late Future<List<Fruit>>? _fruits;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user_fruits = DioHelper().getUserFruits(
        {
          'selected_date': _selectedDate
        }
    );

    _fruits = DioHelper().getFruits({});
  }

  List title_lists = ['Продукты', 'Календарь', 'Избранные'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Учет калорий'),
          backgroundColor: Colors.blueAccent,
        ),
        bottomNavigationBar: NavigationBar(
            labelBehavior: labelBehavior,
            selectedIndex: currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
                if (index == 0) {
                  _fruits = DioHelper().getFruits({});
                } else if (index == 1) {
                  _user_fruits = DioHelper().getUserFruits({
                    'selected_date': _selectedDate ?? DateTime.now()
                  });
                };
                // currentTitle = title_lists[index];
              });
            },
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.shopping_cart),
                label: 'Продукты',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month),
                label: 'Календарь',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.bookmark),
                icon: Icon(Icons.bookmark_border),
                label: 'Избранные',
              ),
            ],
        ),
          body: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 22),
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: _fruits,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: const Icon(Icons.list),
                                // Добавить флаг на беке, что выбран в избранное
                                trailing: IconButton(onPressed: () {},
                                    selectedIcon: Icon(Icons.bookmark),
                                    icon: const Icon(Icons.bookmark_border)
                              ),
                                title: Text("${snapshot.data![index].name.toString()}"),
                                subtitle: Text(
                                    "на ${snapshot.data![index].size_gram.toString()}гр - "
                                        "${snapshot.data![index].kilocalories.toString()} килокалорий"
                                ),

                                // onTap: ,
                              ),
                            );
                          });
                        }
                      },
                    ),
                  )
                ]
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 55),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                      "${DateFormat.yMMMMd().format(_selectedDate)}",
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2300),
                        locale: const Locale("ru", "RU"),
                      );
                      if (newDate == null) return;
                      setState(() {
                        _selectedDate = newDate;
                      });
                      _user_fruits = DioHelper().getUserFruits({
                        'selected_date': _selectedDate
                      });
                    },
                    child: Text("Выбрать дату"),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _user_fruits,
                      builder: (context, snapshot) {
                        print(_selectedDate);
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            return Dismissible(
                              // color: Colors.white,
                              key: UniqueKey(), // Key(item)
                              onDismissed: (direction) {
                                setState(() {
                                  // _fruits.removeAt(index);
                                  DioHelper().destroyUserFruit(item.id);
                                });
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    _user_fruits = DioHelper().getUserFruits(
                                        {
                                          'selected_date': _selectedDate
                                        }
                                    );
                                  });
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('${item.fruit_name} Удален')));
                              },
                              background: Container(color: Colors.red),
                              child: ListTile(
                                // обернуть в кнопку
                                leading: const Icon(Icons.list),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/fruit_show',
                                          arguments: {'id': snapshot.data![index].fruit_id},
                                        );
                                      }, icon: const Icon(Icons.info)),
                                      // IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                                    ],
                                  ),
                                  title: Text("${snapshot.data![index].fruit_name.toString()}"),
                                // onTap: ,
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 22),
              alignment: Alignment.center,
              child: const Text('Избранные продукты'),
            ),
          ][currentPageIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/form_fruit_create');
            },
            child: const Icon(Icons.add),
          )
      );
    }
}

