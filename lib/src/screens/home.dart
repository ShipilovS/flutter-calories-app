import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/dio_helpler.dart';
import 'package:flutter_calories_app/src/models/fruit.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user_fruits = DioHelper().getUserFruits(
        {
          'selected_date': _selectedDate
        }
    );
  }

  List title_lists = ['Продукты', 'Календарь', 'Корзина'];
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
                label: 'Корзина',
              ),
            ],
        ),
          body: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 22),
              alignment: Alignment.center,
              child: const Text('Продукты'),
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
                                  trailing: Icon(Icons.arrow_right),
                                  title: Text("${snapshot.data![index].name.toString()}"),
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
            onPressed: () {},
            child: const Icon(Icons.add),
          )
      );
    }
}

