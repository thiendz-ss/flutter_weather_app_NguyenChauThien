import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService weatherService = WeatherService();
  final StorageService storageService = StorageService();

  WeatherModel? weather;
  List<WeatherModel> forecast = []; // Forecast List
  WeatherState state = WeatherState.initial;
  String error = "";

  List<String> favoriteCities = [];
  List<String> searchHistory = [];

  WeatherProvider() {
    _init();
  }

  // ============================================
  // INIT → Load cache + favorites + history
  // ============================================
  Future<void> _init() async {
    await loadFavorites();
    await loadSearchHistory();

    // Load cached weather
    final cached = await storageService.getWeather();
    if (cached != null) {
      weather = cached;
      state = WeatherState.loaded;
      notifyListeners();
    }
  }

  // ============================================
  // FAVORITES
  // ============================================
  Future<void> loadFavorites() async {
    favoriteCities = await storageService.getFavoriteCities();
    notifyListeners();
  }

  void addFavorite(String city) {
    city = city.trim();
    if (city.isEmpty) return;
    if (!favoriteCities.contains(city)) {
      favoriteCities.insert(0, city);

      if (favoriteCities.length > 10) {
        favoriteCities = favoriteCities.sublist(0, 10);
      }

      storageService.saveFavoriteCities(favoriteCities);
      notifyListeners();
    }
  }

  void removeFavorite(String city) {
    favoriteCities.remove(city);
    storageService.saveFavoriteCities(favoriteCities);
    notifyListeners();
  }

  // ============================================
  // SEARCH HISTORY
  // ============================================
  Future<void> loadSearchHistory() async {
    searchHistory = await storageService.getSearchHistory();
    notifyListeners();
  }

  void addHistory(String city) {
    city = city.trim();
    if (city.isEmpty) return;

    // không trùng
    searchHistory.remove(city);

    // thêm vào đầu
    searchHistory.insert(0, city);

    // giới hạn 10 item
    if (searchHistory.length > 10) {
      searchHistory = searchHistory.sublist(0, 10);
    }

    storageService.saveSearchHistory(searchHistory);
    notifyListeners();
  }

  // ============================================
  // FETCH WEATHER BY CITY
  // ============================================
  Future<void> fetchByCity(String city) async {
    if (city.trim().isEmpty) return;

    state = WeatherState.loading;
    error = "";
    notifyListeners();

    try {
      weather = await weatherService.getCurrentWeatherByCity(city);
      forecast = await weatherService.getForecastByCity(city);

      // cache weather
      await storageService.saveWeather(weather!);

      // add to search history
      addHistory(city);

      state = WeatherState.loaded;
    } catch (e) {
      error = e.toString();
      state = WeatherState.error;

      final cached = await storageService.getWeather();
      if (cached != null) {
        weather = cached;
        state = WeatherState.loaded;
      }
    }

    notifyListeners();
  }

  // ============================================
  // FETCH WEATHER BY GPS COORDINATES
  // ============================================
  Future<void> fetchByLocation() async {
    state = WeatherState.loading;
    error = "";
    notifyListeners();

    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      weather = await weatherService.getCurrentWeatherByLocation(
        pos.latitude,
        pos.longitude,
      );

      forecast = await weatherService.getForecastByCoords(
        pos.latitude,
        pos.longitude,
      );

      // save cache
      await storageService.saveWeather(weather!);

      state = WeatherState.loaded;
    } catch (e) {
      error = e.toString();
      state = WeatherState.error;

      final cached = await storageService.getWeather();
      if (cached != null) {
        weather = cached;
        state = WeatherState.loaded;
      }
    }

    notifyListeners();
  }

  // ============================================
  // REFRESH
  // ============================================
  Future<void> refresh() async {
    if (weather != null) {
      await fetchByCity(weather!.cityName);
    } else {
      await fetchByLocation();
    }
  }
}
