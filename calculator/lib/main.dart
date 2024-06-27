import 'package:flutter/material.dart';
import 'calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFC0CB),
        ),
        useMaterial3: true,
      ),
      home: const Calculator(title: 'Calculator'),
    );
  }
}
