import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_calories_app/src/screens/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import  'dart:io';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final snackBar = SnackBar(
    content: const Text('Неверный email и/или пароль'),
    action: SnackBarAction(
      label: 'Скрыть',
      onPressed: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => setState(() => _email = value.trim()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) => setState(() => _password = value.trim()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Process login data

                  final response = await http.post(
                      Uri.parse("${dotenv.get('APP_BACK_HOST')}/api/authentication/login"),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        "email": _email,
                        "password": _password
                      })
                  );

                  if (response.statusCode == 200) {
                    final token = json.decode(response.body)["data"]["token"];
                    await SessionManager().set('token', token);
                    // print("SessionManager().get('token') = ${await SessionManager().get('token')}");
                    Navigator.pushReplacement(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) => const HomeScreen(),
                    ));
                  } else {
                    print('errors: ${json.decode(response.body)["errors"]}');
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
