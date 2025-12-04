// lib/models/weather_model.dart

class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String icon;
  final String mainCondition;
  final DateTime dateTime;
  final double? tempMin;
  final double? tempMax;
  final int? visibility;
  final int? cloudiness;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.dateTime,
    this.tempMin,
    this.tempMax,
    this.visibility,
    this.cloudiness,
  });

  // ================================
  // 🔵 JSON → MODEL (hỗ trợ cả Current + Forecast)
  // ================================
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // OpenWeather forecast items include "dt_txt" (string) and don't include top-level 'name'
    final bool isForecastItem = json.containsKey('dt_txt');

    // city/country might be in top-level (current) or in "city" (forecast response wrapper).
    final String cityName = (json['name'] as String?) ??
        (json['city'] != null ? (json['city']['name'] as String?) : null) ??
        '';

    final String country = (json['sys']?['country'] as String?) ??
        (json['city'] != null ? (json['city']['country'] as String?) : null) ??
        '';

    // Parse date/time:
    final DateTime dateTime = isForecastItem
        ? DateTime.parse(json['dt_txt'] as String)
        : DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);

    return WeatherModel(
      cityName: cityName,
      country: country,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toInt(),
      windSpeed: (json['wind'] != null && json['wind']['speed'] != null) ? (json['wind']['speed'] as num).toDouble() : 0.0,
      pressure: (json['main']['pressure'] as num).toInt(),
      description: (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['description'] as String
          : '',
      icon: (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['icon'] as String
          : '',
      mainCondition: (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['main'] as String
          : '',
      dateTime: dateTime,
      tempMin: json['main']['temp_min'] != null ? (json['main']['temp_min'] as num).toDouble() : null,
      tempMax: json['main']['temp_max'] != null ? (json['main']['temp_max'] as num).toDouble() : null,
      visibility: json['visibility'] != null ? (json['visibility'] as num).toInt() : null,
      cloudiness: json['clouds'] != null ? (json['clouds']['all'] as num?)?.toInt() : null,
    );
  }

  // ================================
  // 🔵 MODEL → JSON (phục vụ cache)
  // ================================
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': country},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
        'temp_min': tempMin,
        'temp_max': tempMax,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {
          'description': description,
          'icon': icon,
          'main': mainCondition,
        }
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'visibility': visibility,
      'clouds': {'all': cloudiness},
    };
  }
}
