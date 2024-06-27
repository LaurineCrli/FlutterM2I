import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final List<int> _fruits = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
      _fruits.add(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('$_counter : ${getItemType(_counter)}'),
      ),
      body: ListView.builder(
        itemCount: _fruits.length,
        itemBuilder: (context, index) {
          int currentItem = _fruits[index];
          return GestureDetector(
            onTap: () => _showAlertDialog(context, currentItem),
            child: Container(
              color: getBackgroundColor(currentItem),
              child: ListTile(
                leading: Image.asset(getImage(currentItem)),
                title: Text(
                  'Item $currentItem',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: _counter == 0
            ? Colors.deepPurple[100]
            : (_counter % 2 == 0 ? Colors.deepPurple[400] : Colors.deepPurple[200]),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, int number) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: getBackgroundColor(number),
          title: Text(
            getItemType(number),
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(getImage(number)),
              const SizedBox(height: 16),
              Text(
                'Valeur: $number',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _fruits.remove(number);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

bool isPrime(int number) {
  if (number <= 1) return false;
  for (int i = 2; i <= number ~/ 2; i++) {
    if (number % i == 0) return false;
  }
  return true;
}

String getItemType(int number) {
  if (isPrime(number)) {
    return "Nombre premier";
  } else if (number % 2 == 0) {
    return "Nombre pair";
  } else {
    return "Nombre impair";
  }
}

Color getBackgroundColor(int number) {
  if (isPrime(number)) {
    return Colors.deepPurple[100]!;
  } else if (number % 2 == 0) {
    return Colors.deepPurple[400]!;
  } else {
    return Colors.deepPurple[700]!;
  }
}

String getImage(int number) {
  if (isPrime(number)) {
    return 'img/ananas.png';
  } else if (number % 2 == 0) {
    return 'img/poire.png';
  } else {
    return 'img/pomme.png';
  }
}
