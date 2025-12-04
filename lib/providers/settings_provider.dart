import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService service = SettingsService();

  bool isCelsius = true; // true = C, false = F
  bool is24h = true;

  SettingsProvider() {
    load();
  }

  Future<void> load() async {
    isCelsius = await service.getTemperatureUnit();
    is24h = await service.getTimeFormat();
    notifyListeners();
  }

  // ================================
  // 🔵 Toggle Celsius / Fahrenheit
  // ================================
  void toggleCelsius(bool v) {
    isCelsius = v;
    service.setTemperatureUnit(v);
    notifyListeners();
  }

  // Convert °C → °F khi cần
  double convertTemp(double celsius) {
    if (isCelsius) return celsius;
    return (celsius * 9 / 5) + 32;
  }

  // ================================
  // 🔵 Toggle 24h format
  // ================================
  void toggleTimeFormat(bool v) {
    is24h = v;
    service.setTimeFormat(v);
    notifyListeners();
  }

  // ================================
  // 🔵 Reset all settings
  // ================================
  void clearAllSettings() {
    toggleCelsius(true);
    toggleTimeFormat(true);
  }
}
