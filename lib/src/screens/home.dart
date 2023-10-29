import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  int currentPageIndex = 0;
  String currentTitle = 'Продукты';
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

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
                    },
                    child: Text("Выбрать дату"),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children:[
                        Text("A"),
                        Text("B"),
                        Text("C"),
                      ],
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

