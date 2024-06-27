import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key, required this.title});

  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int _counter = 0;
  int _increment = 2;
  int _clickCount = 0;
  final TextEditingController _controller = TextEditingController();
  String _operation = 'addition';

  void _incrementCounter() {
    setState(() {
      switch (_operation) {
        case 'addition':
          _counter += _increment;
          break;
        case 'multiplication':
          _counter *= _increment;
          break;
        case 'soustraction':
          _counter -= _increment;
          break;
        case 'division':
          if (_increment != 0) {
            _counter ~/= _increment;
          }
          break;
      }
      _clickCount++;
    });
  }

  void _updateIncrement() {
    final int? value = int.tryParse(_controller.text);
    if (value != null && value != 0) {
      setState(() {
        _increment = value;
      });
    } else {
      setState(() {
        _increment = 1;
      });
      _showAlert();
    }
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Valeur invalide"),
          content: const Text("L'incrément ne peut pas être égal à 0. La valeur a été définie à 1."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _getIconForOperation() {
    switch (_operation) {
      case 'addition':
        return const Icon(Icons.add);
      case 'multiplication':
        return const Icon(Icons.clear);
      case 'soustraction':
        return const Icon(Icons.remove);
      case 'division':
        return const Text(
          '/',
          style: TextStyle(fontWeight: FontWeight.bold),  // Text en gras
        );
      default:
        return const Icon(Icons.add);
    }
  }

  String _getOperationSymbol() {
    switch (_operation) {
      case 'addition':
        return '+';
      case 'multiplication':
        return '*';
      case 'soustraction':
        return '-';
      case 'division':
        return '/';
      default:
        return '+';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_counter ${_getOperationSymbol()} $_increment =',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${_calculateResult()}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            if (_clickCount > 0)
              Text(
                'Vous avez cliqué $_clickCount fois',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  labelText: 'Valeur de l\'incrément',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (String value) {
                  _updateIncrement();
                },
              ),
            ),
            ElevatedButton(
              onPressed: _updateIncrement,
              child: const Text('Mettre à jour l\'incrément'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: _operation,
                onChanged: (String? newValue) {
                  setState(() {
                    _operation = newValue!;
                  });
                },
                items: <String>['addition', 'multiplication', 'soustraction', 'division']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: _getIconForOperation(),
      ),
    );
  }

  int _calculateResult() {
    switch (_operation) {
      case 'addition':
        return _counter + _increment;
      case 'multiplication':
        return _counter * _increment;
      case 'soustraction':
        return _counter - _increment;
      case 'division':
        if (_increment != 0) {
          return _counter ~/ _increment; // Division entière
        }
        return 0;
      default:
        return _counter + _increment;
    }
  }
}
