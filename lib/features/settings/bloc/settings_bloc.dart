import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/settings_model.dart';
import '../../../data/repositories/settings_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateLanguage extends SettingsEvent {
  final AppLanguage language;
  UpdateLanguage(this.language);
  @override
  List<Object?> get props => [language];
}

class UpdateTheme extends SettingsEvent {
  final AppThemeMode themeMode;
  UpdateTheme(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class UpdateVibration extends SettingsEvent {
  final bool enabled;
  UpdateVibration(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class UpdateSound extends SettingsEvent {
  final bool enabled;
  UpdateSound(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

// ── State ─────────────────────────────────────────────────────────────────────
class SettingsState extends Equatable {
  final SettingsModel settings;
  const SettingsState({required this.settings});
  @override
  List<Object?> get props => [settings];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository)
      : super(const SettingsState(settings: SettingsModel())) {
    on<LoadSettings>(_onLoad);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateVibration>(_onUpdateVibration);
    on<UpdateSound>(_onUpdateSound);
  }

  Future<void> _onLoad(LoadSettings event, Emitter<SettingsState> emit) async {
    final settings = await _repository.getSettings();
    emit(SettingsState(settings: settings));
  }

  Future<void> _onUpdateLanguage(
      UpdateLanguage event, Emitter<SettingsState> emit) async {
    await _repository.updateLanguage(event.language);
    final updated = state.settings.copyWith(language: event.language);
    emit(SettingsState(settings: updated));
  }

  Future<void> _onUpdateTheme(
      UpdateTheme event, Emitter<SettingsState> emit) async {
    await _repository.updateTheme(event.themeMode);
    final updated = state.settings.copyWith(themeMode: event.themeMode);
    emit(SettingsState(settings: updated));
  }

  Future<void> _onUpdateVibration(
      UpdateVibration event, Emitter<SettingsState> emit) async {
    await _repository.updateVibration(event.enabled);
    final updated = state.settings.copyWith(vibrationEnabled: event.enabled);
    emit(SettingsState(settings: updated));
  }

  Future<void> _onUpdateSound(
      UpdateSound event, Emitter<SettingsState> emit) async {
    await _repository.updateSound(event.enabled);
    final updated = state.settings.copyWith(soundEnabled: event.enabled);
    emit(SettingsState(settings: updated));
  }
}
