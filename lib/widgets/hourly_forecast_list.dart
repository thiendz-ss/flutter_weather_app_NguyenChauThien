import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/settings_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HourlyForecastList extends StatelessWidget {
  final List<WeatherModel> items;

  const HourlyForecastList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return SizedBox.shrink();

    final settings = context.watch<SettingsProvider>();

    // show next 8 items (~24h)
    final list = items.length > 8 ? items.sublist(0, 8) : items;

    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, i) {
          final it = list[i];

          // 🔵 Temperature convert
          final temp = settings.convertTemp(it.temperature).round();
          final unit = settings.isCelsius ? "°C" : "°F";

          // 🔵 Time format 24h / 12h
          final timeFormat = settings.is24h ? DateFormat('HH:mm') : DateFormat('h a');

          return Container(
            width: 96,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeFormat.format(it.dateTime),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 6),
                CachedNetworkImage(
                  imageUrl: "https://openweathermap.org/img/wn/${it.icon}.png",
                  height: 40,
                ),
                const SizedBox(height: 6),
                Text(
                  "$temp$unit",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
