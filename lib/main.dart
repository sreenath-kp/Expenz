import 'package:flutter/material.dart';
import 'package:expenz/expenz.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF00ab75),
          onSurface: Colors.white,
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E0D0D),
        ),
        cardTheme: const CardTheme(
          color: Color.fromARGB(255, 200, 200, 220),
          margin: EdgeInsets.symmetric(vertical: 5),
          elevation: 4,
        ),
      ),
      // themeMode: ThemeMode.system,
      home: const Expenses(),
    );
  }
}
