import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherService {
  final String baseUrl = "https://api.openweathermap.org/data/2.5";
  final String apiKey = dotenv.env["API_KEY"] ?? "";

  // Current weather by city name
  Future<WeatherModel> getCurrentWeatherByCity(String city) async {
    final url = Uri.parse("$baseUrl/weather?q=${Uri.encodeComponent(city)}&appid=$apiKey&units=metric");
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception("Failed to load weather: ${resp.body}");
    return WeatherModel.fromJson(jsonDecode(resp.body));
  }

  // Current weather by coordinates
  Future<WeatherModel> getCurrentWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse("$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric");
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception("Failed to load weather by location: ${resp.body}");
    return WeatherModel.fromJson(jsonDecode(resp.body));
  }

  // Forecast by CITY NAME (3-hour steps)
  Future<List<WeatherModel>> getForecastByCity(String city) async {
    final url = Uri.parse("$baseUrl/forecast?q=${Uri.encodeComponent(city)}&appid=$apiKey&units=metric");
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception("Failed to load forecast: ${resp.body}");
    final data = jsonDecode(resp.body);
    final List list = data['list'] as List;
    return list.map((e) => WeatherModel.fromJson(e)).toList();
  }

  // Forecast by coordinates
  Future<List<WeatherModel>> getForecastByCoords(double lat, double lon) async {
    final url = Uri.parse("$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric");
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception("Failed to load forecast by coords: ${resp.body}");
    final data = jsonDecode(resp.body);
    final List list = data['list'] as List;
    return list.map((e) => WeatherModel.fromJson(e)).toList();
  }
}
