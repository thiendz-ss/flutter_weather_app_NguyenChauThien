import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/settings_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const CurrentWeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    // Convert temperature
    final temp = settings.convertTemp(weather.temperature).round();
    final feels = settings.convertTemp(weather.feelsLike).round();

    // Display unit label
    final unit = settings.isCelsius ? "°C" : "°F";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(gradient: _getWeatherGradient(weather.mainCondition)),
      child: Column(
        children: [
          Text(
            weather.cityName,
            style: const TextStyle(fontSize: 36, color: Colors.white),
          ),
          const SizedBox(height: 6),

          Text(
            DateFormat("EEEE, MMM d").format(weather.dateTime),
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          CachedNetworkImage(
            imageUrl: "https://openweathermap.org/img/wn/${weather.icon}@4x.png",
            height: 120,
          ),

          const SizedBox(height: 6),

          // ============================
          // 🔵 Temperature with unit
          // ============================
          Text(
            "$temp$unit",
            style: const TextStyle(fontSize: 72, color: Colors.white),
          ),

          const SizedBox(height: 6),

          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 6),

          // ============================
          // 🔵 Feels like
          // ============================
          Text(
            "Feels like $feels$unit",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // Background gradient by condition
  LinearGradient _getWeatherGradient(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('clear')) {
      return const LinearGradient(
        colors: [Color(0xFFFDB813), Color(0xFF87CEEB)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (condition.contains('rain')) {
      return const LinearGradient(
        colors: [Color(0xFF4A5568), Color(0xFF718096)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (condition.contains('cloud')) {
      return const LinearGradient(
        colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    return const LinearGradient(
      colors: [Colors.blue, Colors.indigo],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
