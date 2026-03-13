import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/biology_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDCAT Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A3A6B)),
        scaffoldBackgroundColor: const Color(0xFFF0F4FA),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/subject/biology': (_) => const BiologyScreen(),
        '/quiz': (_) => const QuizScreen(),
        '/results': (_) => const ResultScreen(),
      },
    );
  }
}
