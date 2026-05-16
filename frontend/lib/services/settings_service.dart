import '../models/meditation_settings.dart';

class SettingsService {
  MeditationSettings _settings = MeditationSettings.defaults();

  MeditationSettings getSettings() {
    return _settings;
  }

  void updateSettings(MeditationSettings settings) {
    _settings = settings;
  }

  void resetToDefaults() {
    _settings = MeditationSettings.defaults();
  }

  MeditationSettings getDefaults() {
    return MeditationSettings.defaults();
  }
}
