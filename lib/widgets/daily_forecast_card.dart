import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    // Lấy mỗi ngày 1 lần (12:00)
    final daily = forecasts.where((item) {
      return DateFormat("HH").format(item.dateTime) == "12";
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "5-Day Forecast",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        ...daily.map((item) {
          return Card(
            color: Colors.white12,
            child: ListTile(
              leading: CachedNetworkImage(
                  imageUrl:
                  "https://openweathermap.org/img/wn/${item.icon}.png",
                  height: 40),
              title: Text(
                DateFormat("EEEE").format(item.dateTime),
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                "${item.temperature.round()}°",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }),
      ],
    );
  }
}
