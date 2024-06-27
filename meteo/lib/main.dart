import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';
import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeSharedPreferences(); 
  runApp(MyApp());
}

Future<void> _initializeSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('savedCities')) {
    await prefs.setStringList('savedCities', []);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Weather App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple[50],
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  List<String> _savedCities = [];
  Future<Map<String, dynamic>>? _weatherFuture;
  String _errorMessage = '';
  LatLng? _cityCoordinates;

  static const Map<String, String> weatherIcons = {
    '01d': 'assets/soleil.png', 
    '01n': 'assets/lune.png', 
    '02d': 'assets/soleil-nuage.png', 
    '02n': 'assets/lune-nuage.png', 
    '03d': 'assets/nuage.png', 
    '03n': 'assets/nuage.png', 
    '04d': 'assets/nuage.png', 
    '04n': 'assets/nuage.png', 
    '09d': 'assets/nuage-pluie.png',
    '09n': 'assets/nuage-pluie.png',
    '10d': 'assets/nuage-pluie.png',
    '10n': 'assets/nuage-pluie.png',
    '11d': 'assets/nuage-orage.png', 
    '11n': 'assets/nuage-orage.png', 
    '13d': 'assets/nuage-flocons.png', 
    '13n': 'assets/nuage-flocons.png', 
    '50d': 'assets/nuage-brouillard.png', 
    '50n': 'assets/nuage-brouillard.png', 
  };

  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  Future<void> _loadSavedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCities = prefs.getStringList('savedCities') ?? [];
    });
  }

  Future<void> _saveCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedCities', _savedCities);
  }

  void _fetchWeather() {
    setState(() {
      _weatherFuture = _getWeatherData(_controller.text);
    });
  }

  Future<Map<String, dynamic>> _getWeatherData(String cityName) async {
    try {
      final cityData = await _apiService.getCityCoordinates(cityName);
      if (cityData.isEmpty) {
        throw Exception('City not found');
      }

      final latitude = cityData['latitude'];
      final longitude = cityData['longitude'];
      final weatherData = await _apiService.getWeatherData(latitude, longitude);

      setState(() {
        _cityCoordinates = LatLng(latitude, longitude);
      });

      return {
        'city': cityName,
        'country': cityData['country'],
        'latitude': latitude,
        'longitude': longitude,
        'temperature': weatherData['main']['temp'],
        'icon': weatherData['weather'][0]['icon'],
        'description': weatherData['weather'][0]['description'],
      };
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      throw e;
    }
  }

  Future<void> _fetchWeatherUsingCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _weatherFuture = _getWeatherDataFromCoordinates(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<Map<String, dynamic>> _getWeatherDataFromCoordinates(double latitude, double longitude) async {
    try {
      final weatherData = await _apiService.getWeatherData(latitude, longitude);

      setState(() {
        _cityCoordinates = LatLng(latitude, longitude);
      });

      return {
        'city': 'Current Location',
        'latitude': latitude,
        'longitude': longitude,
        'temperature': weatherData['main']['temp'],
        'icon': weatherData['weather'][0]['icon'],
        'description': weatherData['weather'][0]['description'],
      };
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      throw e;
    }
  }

  Widget _buildWeatherDisplay(Map<String, dynamic> data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('City: ${data['city']}', style: TextStyle(fontSize: 20)),
        if (data['city'] != 'Current Location') Text('Country: ${data['country']}', style: TextStyle(fontSize: 20)),
        SizedBox(height: 8),
        Text('Latitude: ${data['latitude']}', style: TextStyle(fontSize: 20)),
        Text('Longitude: ${data['longitude']}', style: TextStyle(fontSize: 20)),
        SizedBox(height: 16),
        Container(
          height: 200,
          child: _cityCoordinates != null
              ? FlutterMap(
            options: MapOptions(
              center: _cityCoordinates,
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _cityCoordinates!,
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
              : Container(),
        ),
        SizedBox(height: 16),
        Image.asset(weatherIcons[data['icon']] ?? 'assets/thermometre.png', width: 100, height: 100),
        SizedBox(height: 8),
        Text('Temperature: ${data['temperature']}°C', style: TextStyle(fontSize: 20)),
        Text('Description: ${data['description']}', style: TextStyle(fontSize: 20)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('City Weather App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => _fetchWeather(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _fetchWeather,
                    child: Text('Get Weather'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _fetchWeatherUsingCurrentLocation,
                    child: Text('Use Current Location'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty && !_savedCities.contains(_controller.text)) {
                        setState(() {
                          _savedCities.add(_controller.text);
                          _saveCities(); 
                        });
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              FutureBuilder<Map<String, dynamic>>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return _buildWeatherDisplay(snapshot.data!);
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                'Saved Cities:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _savedCities.length,
                itemBuilder: (context, index) {
                  return Container(
                      color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                      child: ListTile(
                        title: Text(_savedCities[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _savedCities.removeAt(index);
                              _saveCities(); 
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _controller.text = _savedCities[index];
                            _fetchWeather();
                          });
                        },
                      ),
                    );
                 },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
