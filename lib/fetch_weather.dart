import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherFetch {
  final String apiKey;

  WeatherFetch(this.apiKey);

  Future<Map<String, dynamic>> getWeatherAtLocation(
      double lat, double lon) async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getForecastAtLocation(
      double lat, double lon) async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
