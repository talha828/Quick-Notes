import 'package:flutter/material.dart';
import 'package:quick_notes/screens/loginScreen/loginScreen.dart';
import 'package:quick_notes/screens/mainScreen/mainScreen.dart';
import 'package:quick_notes/screens/signUpScreen/signUpScreen.dart';
import 'package:quick_notes/screens/splashScreen/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}




