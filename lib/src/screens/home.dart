import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/dio_helpler.dart';
import 'package:flutter_calories_app/src/models/fruit.dart';
import 'package:flutter_calories_app/src/screens/form_fruit_create.dart';
import 'package:flutter_calories_app/src/screens/fruit_show.dart';
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
  late Future<List<Fruit>>? _favorites;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user_fruits = DioHelper().getUserFruits(
        {
          'selected_date': _selectedDate
        }
    );
    _favorites = DioHelper().getFavorites({});
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
                    'selected_date': _selectedDate
                  });
                } else if (index == 2) {
                  _favorites = DioHelper().getFavorites({});
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
                                trailing: FittedBox(
                                  fit: BoxFit.fill,
                                  child:  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (snapshot.data![index].is_favorite) {
                                              DioHelper().destroyFavorite(snapshot.data![index].id.toInt());
                                            } else {
                                              DioHelper().createFavorite({
                                                'fruit_id': snapshot.data![index].id
                                              });
                                            }
                                            setState(() {
                                              _fruits = DioHelper().getFruits({});
                                            });
                                          },
                                          icon: Icon(snapshot.data![index].is_favorite ? Icons.favorite : Icons.favorite_border )
                                      ),
                                      IconButton(onPressed: () {
                                        Navigator.pushNamed(
                                          context, '/fruit_show',
                                          arguments: {
                                            'id':           snapshot.data![index].id,
                                            'name':         snapshot.data![index].name,
                                            'description':  snapshot.data![index].description
                                          },
                                        );
                                      }, icon: const Icon(Icons.info)),
                                      // IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                                    ],
                                  ),
                                ),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   selectedIcon: Icon(Icons.bookmark),
                                    //   icon: const Icon(Icons.bookmark_border
                                    // )
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
              padding: EdgeInsets.symmetric(vertical: 15),
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
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data![index];
                            return Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: const Icon(Icons.list),
                                // Добавить флаг на беке, что выбран в избранное
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Удаление продукта"),
                                            content: Text("Вы действительно хотите удалить продукт?"),
                                            actions: [
                                              TextButton(
                                                child: Text("Отменить"),
                                                onPressed:  () { Navigator.pop(context); },
                                              ),
                                              TextButton(
                                                child: Text("Удалить"),
                                                onPressed: () async {
                                                  await DioHelper().destroyUserFruit(item.id);
                                                  setState(() {
                                                    _user_fruits = DioHelper().getUserFruits({
                                                      'selected_date': _selectedDate
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete)
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
              child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: _favorites,
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
                                    title: Text("${snapshot.data![index].name.toString()}"),
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
          ][currentPageIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/form_fruit_create').then((_)
                => setState(() {
                  _user_fruits = DioHelper().getUserFruits(
                      {
                        'selected_date': _selectedDate
                      }
                  );
                })
              );
            },
            child: const Icon(Icons.add),
          )
      );
    }
}

