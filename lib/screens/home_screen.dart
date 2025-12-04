import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_section.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // ================================================
    // 🔵 MỤC 3 — FETCH LOCATION SAFELY (FULL VERSION)
    // ================================================
    Future.microtask(() async {
      try {
        // Try GPS first
        await context.read<WeatherProvider>().fetchByLocation();
      } catch (e) {
        // If user denied permission or GPS fails:
        await context.read<WeatherProvider>().fetchByCity("Ho Chi Minh");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: [
          // ⭐ FAVORITE BUTTON
          if (provider.weather != null)
            IconButton(
              icon: Icon(
                provider.favoriteCities.contains(provider.weather!.cityName)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: provider.favoriteCities.contains(provider.weather!.cityName)
                    ? Colors.red
                    : Colors.white,
              ),
              onPressed: () {
                final city = provider.weather!.cityName;
                if (provider.favoriteCities.contains(city)) {
                  provider.removeFavorite(city);
                } else {
                  provider.addFavorite(city);
                }
              },
            ),

          IconButton(
            icon: Icon(Icons.search),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
          ),

          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () => provider.refresh(),
        child: Builder(
          builder: (context) {
            if (provider.state == WeatherState.loading) {
              return ListView(children: [
                SizedBox(height: 200),
                Center(child: CircularProgressIndicator())
              ]);
            }

            if (provider.state == WeatherState.error && provider.weather == null) {
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      "Error: ${provider.error}",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            }

            final w = provider.weather;

            return ListView(
              children: [
                // CURRENT WEATHER
                if (w != null) CurrentWeatherCard(weather: w),

                SizedBox(height: 12),

                // FAVORITE CITIES
                if (provider.favoriteCities.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Favorite Cities",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ...provider.favoriteCities.map((c) {
                          return Card(
                            child: ListTile(
                              title: Text(c),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => provider.removeFavorite(c),
                              ),
                              onTap: () => provider.fetchByCity(c),
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),

                // HOURLY FORECAST
                if (provider.forecast.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Hourly Forecast",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        HourlyForecastList(items: provider.forecast),
                      ],
                    ),
                  ),

                // DAILY FORECAST
                if (provider.forecast.isNotEmpty)
                  DailyForecastSection(items: provider.forecast),

                SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
