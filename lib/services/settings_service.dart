import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String keyTemperatureUnit = "temp_unit";
  static const String keyTimeFormat = "time_format";

  // C = true, F = false
  Future<void> setTemperatureUnit(bool isCelsius) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyTemperatureUnit, isCelsius);
  }

  Future<bool> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyTemperatureUnit) ?? true;
  }

  // 24h = true, 12h = false
  Future<void> setTimeFormat(bool is24h) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyTimeFormat, is24h);
  }

  Future<bool> getTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyTimeFormat) ?? true;
  }
}
