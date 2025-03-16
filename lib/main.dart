import 'package:flutter/material.dart';
import 'package:pay_and_pray/screens/main_screen.dart' show MainScreen;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Pay & Pray', home: MainScreen());
  }
}
