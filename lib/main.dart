import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/balance_screen.dart';
import 'screens/slot_machine_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/balance': (context) => const BalanceScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
