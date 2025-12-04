import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Build URL
  static String buildUrl(String endpoint, Map<String, String> params) {
    final uri = Uri.parse('$baseUrl$endpoint');

    return uri.replace(queryParameters: {
      "appid": apiKey,
      "units": "metric",
      ...params
    }).toString();
  }

  static const String currentWeather = "/weather";
  static const String forecast = "/forecast";
}
