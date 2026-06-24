import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/models/settings_model.dart';
import '../../settings/bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsBloc>()..add(LoadSettings()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppColors.backgroundGradient)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
                      ),
                      Text('Settings', style: AppTextStyles.headlineMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          _SettingsSection(
                            title: '🌐 Language',
                            child: _SegmentedOption(
                              options: const ['English', 'Malayalam'],
                              selectedIndex: state.settings.language == AppLanguage.english ? 0 : 1,
                              onChanged: (i) => context.read<SettingsBloc>().add(
                                    UpdateLanguage(
                                        i == 0 ? AppLanguage.english : AppLanguage.malayalam),
                                  ),
                            ),
                          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0, delay: 100.ms, duration: 300.ms),

                          const SizedBox(height: 16),

                          _SettingsSection(
                            title: '🎨 Theme',
                            child: _SegmentedOption(
                              options: const ['Dark', 'Light'],
                              selectedIndex: state.settings.themeMode == AppThemeMode.dark ? 0 : 1,
                              onChanged: (i) => context.read<SettingsBloc>().add(
                                    UpdateTheme(
                                        i == 0 ? AppThemeMode.dark : AppThemeMode.light),
                                  ),
                            ),
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 300.ms),

                          const SizedBox(height: 16),

                          _SettingsSection(
                            title: '📳 Vibration',
                            child: _ToggleRow(
                              value: state.settings.vibrationEnabled,
                              onChanged: (v) =>
                                  context.read<SettingsBloc>().add(UpdateVibration(v)),
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0, delay: 300.ms, duration: 300.ms),

                          const SizedBox(height: 16),

                          _SettingsSection(
                            title: '🔊 Sound',
                            child: _ToggleRow(
                              value: state.settings.soundEnabled,
                              onChanged: (v) =>
                                  context.read<SettingsBloc>().add(UpdateSound(v)),
                            ),
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 300.ms),

                          const SizedBox(height: 40),

                          Center(
                            child: Column(
                              children: [
                                Text('IMPOSTER', style: AppTextStyles.goldLabel),
                                Text(
                                  'Kerala Edition • v1.0',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Made with ❤️ for Kerala',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 600.ms),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingsSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SegmentedOption extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _SegmentedOption({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: options.asMap().entries.map((e) {
          final isSelected = e.key == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.goldGradient : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    e.value,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.black : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value ? 'Enabled' : 'Disabled',
          style: AppTextStyles.bodyMedium.copyWith(
            color: value ? AppColors.primaryGreen : AppColors.textMuted,
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 56,
            height: 30,
            decoration: BoxDecoration(
              color: value ? AppColors.primaryGreen : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: value ? AppColors.primaryGreen : AppColors.cardBorder,
                width: 1.5,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: value ? Colors.black : AppColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
