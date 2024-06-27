import 'package:dio/dio.dart';
import 'env.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getCityCoordinates(String cityName) async {
    final String apiKey = environment['CITY_API_KEY']!;
    final response = await _dio.get(
      'https://api.api-ninjas.com/v1/city',
      queryParameters: {'name': cityName},
      options: Options(headers: {'X-Api-Key': apiKey}),
    );

    if (response.statusCode == 200 && response.data.isNotEmpty) {
      return response.data[0];
    } else {
      throw Exception('City not found');
    }
  }

  Future<Map<String, dynamic>> getWeatherData(double latitude, double longitude) async {
    final String apiKey = environment['METEO_API_KEY']!;
    final response = await _dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'appid': apiKey,
        'units': 'metric'
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
