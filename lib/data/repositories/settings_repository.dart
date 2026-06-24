import 'package:hive_flutter/hive_flutter.dart';
import '../models/settings_model.dart';

class SettingsRepository {
  static const String _boxName = 'settings';
  static const String _settingsKey = 'app_settings';

  Future<SettingsModel> getSettings() async {
    final box = await Hive.openBox<Map>(_boxName);
    final raw = box.get(_settingsKey);
    if (raw == null) return const SettingsModel();
    return SettingsModel.fromMap(Map<String, dynamic>.from(raw));
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final box = await Hive.openBox<Map>(_boxName);
    await box.put(_settingsKey, settings.toMap());
  }

  Future<void> updateVibration(bool enabled) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(vibrationEnabled: enabled));
  }

  Future<void> updateSound(bool enabled) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(soundEnabled: enabled));
  }

  Future<void> updateTheme(AppThemeMode themeMode) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(themeMode: themeMode));
  }

  Future<void> updateLanguage(AppLanguage language) async {
    final settings = await getSettings();
    await saveSettings(settings.copyWith(language: language));
  }
}
