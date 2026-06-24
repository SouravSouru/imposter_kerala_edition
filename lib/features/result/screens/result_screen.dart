import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/repositories/game_repository.dart';
import '../../../routes/app_router.dart';

class ResultScreen extends StatefulWidget {
  final GameResult result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _pulseController;

  bool get _caught => widget.result.impostersCaught;

  String get _subtitle {
    final r = Random();
    if (_caught) {
      return AppStrings.caughtSubtitles[r.nextInt(AppStrings.caughtSubtitles.length)];
    } else {
      return AppStrings.imposterWinsSubtitles[r.nextInt(AppStrings.imposterWinsSubtitles.length)];
    }
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    if (_caught) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: _caught
                  ? AppColors.resultCaughtGradient
                  : AppColors.resultWinGradient,
            ),
          ),
          // Red particle rain for imposter win
          if (!_caught) _RedParticleRain(controller: _pulseController),
          // Confetti for caught
          if (_caught)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  AppColors.primaryGreen,
                  AppColors.accentGold,
                  Colors.white,
                  AppColors.primaryGreenDark,
                ],
                numberOfParticles: 40,
                emissionFrequency: 0.08,
                gravity: 0.2,
              ),
            ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Main emoji
                  Center(
                    child: Text(
                      _caught ? '🎉' : '😈',
                      style: const TextStyle(fontSize: 80),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.3, 0.3),
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(duration: 400.ms),
                  ),
                  const SizedBox(height: 24),
                  // Main title
                  Text(
                    _caught ? 'കള്ളനെ പൊക്കി!' : 'എല്ലാവരെയും\nപറ്റിച്ചു!',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: _caught ? AppColors.primaryGreen : AppColors.dangerRed,
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 500.ms)
                      .slideY(begin: 0.3, end: 0, delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: 8),
                  // Funny subtitle
                  Text(
                    _subtitle,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 40),
                  // Result card
                  _ResultCard(result: widget.result, caught: _caught)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, delay: 600.ms, duration: 500.ms),
                  const SizedBox(height: 40),
                  // Action buttons
                  _ActionButtons().animate().fadeIn(delay: 900.ms, duration: 400.ms),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final GameResult result;
  final bool caught;

  const _ResultCard({required this.result, required this.caught});

  @override
  Widget build(BuildContext context) {
    final imposter = result.session.imposters.isNotEmpty
        ? result.session.imposters.first
        : null;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: caught
              ? AppColors.primaryGreen.withValues(alpha: 0.4)
              : AppColors.dangerRed.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: caught ? AppColors.greenGlow : AppColors.redGlow,
      ),
      child: Column(
        children: [
          // Voted player
          _InfoRow(
            icon: '🗳️',
            label: 'You Voted',
            value: result.votedPlayer.name,
            valueColor: caught ? AppColors.primaryGreen : AppColors.dangerRed,
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 16),
          // Imposter name
          if (imposter != null) ...[
            _InfoRow(
              icon: '😈',
              label: 'The Imposter Was',
              value: imposter.name,
              valueColor: AppColors.dangerRed,
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.cardBorder, height: 1),
            const SizedBox(height: 16),
          ],
          // Category
          _InfoRow(
            icon: result.session.category.icon,
            label: 'Category',
            value: result.session.category.name,
            valueColor: AppColors.textPrimary,
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 16),
          // Secret word
          _InfoRow(
            icon: '🔑',
            label: 'The Secret Word Was',
            value: result.session.secretWord,
            valueColor: AppColors.accentGold,
            valueLarge: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool valueLarge;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.bodyMedium),
          ],
        ),
        Text(
          value,
          style: valueLarge
              ? AppTextStyles.headlineMedium.copyWith(color: valueColor, fontSize: 20)
              : AppTextStyles.labelLarge.copyWith(color: valueColor),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Play Again
        GestureDetector(
          onTap: () => context.go(AppRoutes.setup),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.greenGlow,
            ),
            child: Center(
              child: Text(
                '🔄  Play Again',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Back to Home
        GestureDetector(
          onTap: () => context.go(AppRoutes.home),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Center(
              child: Text(
                '🏠  Back to Home',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RedParticleRain extends StatefulWidget {
  final AnimationController controller;
  const _RedParticleRain({required this.controller});

  @override
  State<_RedParticleRain> createState() => _RedParticleRainState();
}

class _RedParticleRainState extends State<_RedParticleRain>
    with SingleTickerProviderStateMixin {
  late AnimationController _rain;

  @override
  void initState() {
    super.initState();
    _rain = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _rain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rain,
      builder: (context, _) => CustomPaint(
        painter: _RainPainter(_rain.value),
        size: Size.infinite,
      ),
    );
  }
}

class _RainPainter extends CustomPainter {
  final double progress;
  _RainPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    const count = 30;
    for (int i = 0; i < count; i++) {
      final x = ((i * 137.5 + progress * 200) % size.width);
      final y = ((progress + i / count) % 1.0) * size.height;
      final opacity = (sin(progress * pi * 2 + i) * 0.5 + 0.5) * 0.3;
      paint.color = AppColors.dangerRed.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(_RainPainter old) => old.progress != progress;
}
