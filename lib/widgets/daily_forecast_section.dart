import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/settings_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DailyForecastSection extends StatelessWidget {
  final List<WeatherModel> items;

  const DailyForecastSection({required this.items});

  // Extract 1 item for each day (prefer 12:00)
  List<WeatherModel> _extractDaily(List<WeatherModel> list) {
    Map<String, WeatherModel> map = {};
    for (var it in list) {
      final day = DateFormat('yyyy-MM-dd').format(it.dateTime);
      final hour = DateFormat('HH').format(it.dateTime);

      if (!map.containsKey(day)) {
        map[day] = it;
      } else {
        if (hour == '12') map[day] = it;
      }
    }
    return map.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return SizedBox.shrink();

    final settings = context.watch<SettingsProvider>();
    final unit = settings.isCelsius ? "°C" : "°F";

    final daily = _extractDaily(items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text(
            "5-Day Forecast",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        ...daily.map((it) {
          final temp = settings.convertTemp(it.temperature).round();

          return Card(
            color: Colors.white10,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: "https://openweathermap.org/img/wn/${it.icon}.png",
                height: 40,
              ),
              title: Text(
                DateFormat('EEEE').format(it.dateTime),
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "${it.description}",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                "$temp$unit",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
