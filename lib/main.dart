import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/saved_facts_screen.dart';

void main() {
  runApp(const NumberTriviaApp());
}

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({super.key});

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
        '/home': (context) => const HomeScreen(), // WidgetBuilder sifatida funksiya
        '/saved': (context) => const SavedFactsScreen(), // WidgetBuilder sifatida funksiya
      },
    );
  }
}