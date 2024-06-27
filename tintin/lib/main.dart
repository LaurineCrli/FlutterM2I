import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/albums_master.dart';
import './providers/reading_list_provider.dart';
import './theme/dark_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ReadingListProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Albums de Tintin',
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const AlbumsMaster(),
    );
  }
}
