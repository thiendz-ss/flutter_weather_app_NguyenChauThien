import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  // Key cho lưu weather cache
  static const String _weatherKey = "cached_weather";

  // Key cho lưu danh sách Favorite Cities
  static const String _favoriteKey = "favorite_cities";

  // Key cho lưu Search History
  static const String _historyKey = "search_history";

  // ================================
  // 🟦 1) LƯU WEATHER (CACHE)
  // ================================
  Future<void> saveWeather(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_weatherKey, jsonEncode(weather.toJson()));
  }

  Future<WeatherModel?> getWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_weatherKey);
    if (data == null) return null;
    return WeatherModel.fromJson(jsonDecode(data));
  }

  // ================================
  // 🟪 2) FAVORITE CITIES (LIST)
  // ================================
  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_favoriteKey, cities);
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteKey) ?? [];
  }

  // ================================
  // 🟧 3) SEARCH HISTORY (LIST)
  // ================================
  Future<void> saveSearchHistory(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_historyKey, items);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }
}
