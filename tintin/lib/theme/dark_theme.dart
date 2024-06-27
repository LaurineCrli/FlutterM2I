import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.red[300] ?? Colors.red,
  colorScheme: ColorScheme.dark(
    primary: Colors.red[300] ?? Colors.red, 
    secondary: Colors.amber[300] ?? Colors.amber, 
  ),
  scaffoldBackgroundColor: Color(0xFF2E2E2E), 
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.red[300] ?? Colors.red, 
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.amber[300] ?? Colors.amber, 
  iconTheme: IconThemeData(
    color: Colors.amber[300] ?? Colors.amber, 
  listTileTheme: ListTileThemeData(
    textColor: Colors.white,
    iconColor: Colors.amber[300] ?? Colors.amber, 
  ),
);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Exemple de Thème Sombre'),
        ),
        body: Center(
          child: Text('Bonjour le monde!', style: Theme.of(context).textTheme.bodyMedium),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
