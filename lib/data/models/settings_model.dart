import 'package:equatable/equatable.dart';

enum AppLanguage { english, malayalam }
enum AppThemeMode { dark, light }

class SettingsModel extends Equatable {
  final AppLanguage language;
  final AppThemeMode themeMode;
  final bool vibrationEnabled;
  final bool soundEnabled;

  const SettingsModel({
    this.language = AppLanguage.english,
    this.themeMode = AppThemeMode.dark,
    this.vibrationEnabled = true,
    this.soundEnabled = true,
  });

  SettingsModel copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
    bool? vibrationEnabled,
    bool? soundEnabled,
  }) =>
      SettingsModel(
        language: language ?? this.language,
        themeMode: themeMode ?? this.themeMode,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        soundEnabled: soundEnabled ?? this.soundEnabled,
      );

  Map<String, dynamic> toMap() => {
        'language': language.name,
        'themeMode': themeMode.name,
        'vibrationEnabled': vibrationEnabled,
        'soundEnabled': soundEnabled,
      };

  factory SettingsModel.fromMap(Map<String, dynamic> map) => SettingsModel(
        language: AppLanguage.values.firstWhere(
          (e) => e.name == map['language'],
          orElse: () => AppLanguage.english,
        ),
        themeMode: AppThemeMode.values.firstWhere(
          (e) => e.name == map['themeMode'],
          orElse: () => AppThemeMode.dark,
        ),
        vibrationEnabled: map['vibrationEnabled'] as bool? ?? true,
        soundEnabled: map['soundEnabled'] as bool? ?? true,
      );

  @override
  List<Object?> get props =>
      [language, themeMode, vibrationEnabled, soundEnabled];
}
