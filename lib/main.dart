import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/home_boarding.dart';
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
      },
      initialRoute: '/boarding',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru', 'RU')
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Учет калорий'),
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
