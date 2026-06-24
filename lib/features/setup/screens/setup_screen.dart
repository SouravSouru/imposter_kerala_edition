import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/di/injection_container.dart';
import '../../../routes/app_router.dart';
import '../bloc/setup_bloc.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SetupBloc>()..add(SetupInitialized()),
      child: const _SetupView(),
    );
  }
}

class _SetupView extends StatelessWidget {
  const _SetupView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SetupBloc, SetupState>(
      listener: (context, state) {
        if (state is SetupGameReady) {
          context.push(AppRoutes.roleReveal, extra: state.session);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: AppColors.backgroundGradient)),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: BlocBuilder<SetupBloc, SetupState>(
                      builder: (context, state) {
                        if (state is! SetupConfigState) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
                        }
                        return _buildContent(context, state);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          ),
          Text('Game Setup', style: AppTextStyles.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, SetupConfigState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Player count
          _SectionCard(
            title: '👥 Number of Players',
            child: _CounterControl(
              value: state.playerCount,
              min: 3,
              max: 20,
              onChanged: (v) => context.read<SetupBloc>().add(PlayerCountChanged(v)),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0, duration: 400.ms),

          const SizedBox(height: 16),

          // Player names
          _SectionCard(
            title: '✏️ Player Names (optional)',
            child: _PlayerNamesList(state: state),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.2, end: 0, delay: 100.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Imposter count
          _SectionCard(
            title: '😈 Number of Imposters',
            child: _CounterControl(
              value: state.imposterCount,
              min: 1,
              max: (state.playerCount - 1).clamp(1, 3),
              onChanged: (v) => context.read<SetupBloc>().add(ImposterCountChanged(v)),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Discussion time
          _SectionCard(
            title: '⏱️ Discussion Time',
            child: _TimeSelector(
              selected: state.discussionMinutes,
              onChanged: (v) => context.read<SetupBloc>().add(DiscussionTimeChanged(v)),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2, end: 0, delay: 300.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Categories
          _SectionCard(
            title: '🎯 Categories',
            child: _CategoryGrid(state: state),
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 400.ms),

          const SizedBox(height: 32),

          // Start button
          _StartButton(isValid: state.isValid)
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms)
              .slideY(begin: 0.3, end: 0, delay: 500.ms, duration: 400.ms),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: AppColors.cardShadow,
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

// ── Counter Control ───────────────────────────────────────────────────────────
class _CounterControl extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _CounterControl({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CounterBtn(
          icon: Icons.remove,
          enabled: value > min,
          onTap: () => onChanged(value - 1),
        ),
        const SizedBox(width: 24),
        Column(
          children: [
            Text(
              '$value',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
            Text(
              'players',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(width: 24),
        _CounterBtn(
          icon: Icons.add,
          enabled: value < max,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CounterBtn({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryGreen.withValues(alpha: 0.15) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled ? AppColors.primaryGreen : AppColors.cardBorder,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? AppColors.primaryGreen : AppColors.textMuted,
          size: 22,
        ),
      ),
    );
  }
}

// ── Player Names List ─────────────────────────────────────────────────────────
class _PlayerNamesList extends StatelessWidget {
  final SetupConfigState state;
  const _PlayerNamesList({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(state.playerCount, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            initialValue: state.playerNames.length > i ? state.playerNames[i] : '',
            onChanged: (v) => context.read<SetupBloc>().add(PlayerNameChanged(i, v)),
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Player ${i + 1}',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '${i + 1}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 48),
              filled: true,
              fillColor: AppColors.backgroundCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        );
      }),
    );
  }
}

// ── Time Selector ─────────────────────────────────────────────────────────────
class _TimeSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _TimeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const options = [1, 2, 3, 5];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((min) {
        final isSelected = selected == min;
        return GestureDetector(
          onTap: () => onChanged(min),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.goldGradient : null,
              color: isSelected ? null : AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.accentGold : AppColors.cardBorder,
                width: 1.5,
              ),
            ),
            child: Text(
              '$min min',
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.black : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Category Grid ─────────────────────────────────────────────────────────────
class _CategoryGrid extends StatelessWidget {
  final SetupConfigState state;
  const _CategoryGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: state.allCategories.map((cat) {
        final isSelected = state.selectedCategoryIds.contains(cat.id);
        return GestureDetector(
          onTap: () => context.read<SetupBloc>().add(CategoryToggled(cat.id)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryGreen.withValues(alpha: 0.15)
                  : AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cat.icon, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  cat.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Start Button ──────────────────────────────────────────────────────────────
class _StartButton extends StatelessWidget {
  final bool isValid;
  const _StartButton({required this.isValid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isValid
          ? () => context.read<SetupBloc>().add(GameStarted())
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: isValid
              ? const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isValid ? null : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isValid ? AppColors.greenGlow : [],
          border: Border.all(
            color: isValid ? AppColors.primaryGreen : AppColors.cardBorder,
          ),
        ),
        child: Center(
          child: Text(
            isValid ? '🎮  Start Game' : 'Select at least 3 players',
            style: AppTextStyles.labelLarge.copyWith(
              color: isValid ? Colors.black : AppColors.textMuted,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
