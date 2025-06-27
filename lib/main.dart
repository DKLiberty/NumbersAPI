import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/saved_facts_screen.dart';

void main() {
  runApp(const NumberAPIApp());
}

class NumberAPIApp extends StatelessWidget {
  const NumberAPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NumberAPI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/saved': (context) => const SavedFactsScreen(),
      }
    );
  }
}