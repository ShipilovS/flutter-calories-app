import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/home_boarding.dart';
import 'package:flutter_calories_app/src/screens/form_fruit_create.dart';
import 'package:flutter_calories_app/src/screens/fruit_show.dart';
import 'package:flutter_calories_app/src/screens/home.dart';
import 'package:flutter_calories_app/src/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/boarding': (context) => const HomeBoarding(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/form_fruit_create': (context) => const FormFruitCreate(),
        '/fruit_show': (context) => FruitShowScreen(),
        // arguments: ModalRoute.of(context)?.settings.arguments
      },
      initialRoute: '/boarding',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      supportedLocales: [
        const Locale('ru', 'RU')
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Учет калорий'), // не показыватся нигде?
          backgroundColor: Colors.blueAccent,
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: LoginScreen(),
        ),
      ),
    );
  }
}
