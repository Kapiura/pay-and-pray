import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'screens/balance_screen.dart';
import 'screens/slot_machine_screen.dart';
import 'providers/balance_provider.dart';
import 'providers/audio_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioHandler.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => BalanceProvider(),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/balance': (context) => const BalanceScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
