import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'screens/balance_screen.dart';
import 'screens/slot_machine_screen.dart';
import 'package:pay_and_pray/providers/balance_provider.dart' as provider;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => provider.BalanceProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jednoręki Bandyta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/balance': (context) => const BalanceScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
