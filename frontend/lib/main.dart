import 'package:flutter/material.dart';
import 'screens/meditation_screen.dart';
import 'services/settings_service.dart';

void main() {
  final settingsService = SettingsService();
  runApp(MeditationApp(settingsService: settingsService));
}

class MeditationApp extends StatelessWidget {
  final SettingsService settingsService;

  const MeditationApp({super.key, required this.settingsService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4FC3F7),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF4FC3F7),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: MeditationScreen(settingsService: settingsService),
    );
  }
}
