import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/weather_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Weather App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,    // UI dark mode theo design
        ),
        home: HomeScreen(),
      ),
    );
  }
}
