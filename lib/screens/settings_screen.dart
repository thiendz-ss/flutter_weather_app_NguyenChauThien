import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          // ============================
          // 🔵 Temperature Unit
          // ============================
          ListTile(
            title: Text("Temperature Unit"),
            subtitle: Text("Choose between Celsius (°C) or Fahrenheit (°F)"),
          ),

          RadioListTile(
            value: true,
            groupValue: s.isCelsius,
            title: Text("Celsius (°C)"),
            onChanged: (v) => s.toggleCelsius(true),
          ),

          RadioListTile(
            value: false,
            groupValue: s.isCelsius,
            title: Text("Fahrenheit (°F)"),
            onChanged: (v) => s.toggleCelsius(false),
          ),

          Divider(),

          // ============================
          // 🔵 24H Format
          // ============================
          SwitchListTile(
            title: const Text("24-hour Time Format"),
            value: s.is24h,
            onChanged: s.toggleTimeFormat,
          ),

          Divider(),

          ListTile(
            title: const Text("Reset Settings"),
            trailing: Icon(Icons.refresh),
            onTap: () {
              s.clearAllSettings();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Settings reset")));
            },
          ),
        ],
      ),
    );
  }
}
