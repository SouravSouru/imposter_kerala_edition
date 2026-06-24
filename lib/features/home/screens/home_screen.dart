import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
          // Green glow top
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryGreen.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Gold glow bottom right
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accentGold.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  // Logo area
                  _buildLogo(),
                  const Spacer(flex: 2),
                  // Buttons
                  _HomeButton(
                    icon: '🎮',
                    label: 'Start Game',
                    isPrimary: true,
                    onTap: () => context.push(AppRoutes.setup),
                    delay: 0,
                  ),
                  const SizedBox(height: 16),
                  _HomeButton(
                    icon: '📖',
                    label: 'How To Play',
                    isPrimary: false,
                    onTap: () => context.push(AppRoutes.howToPlay),
                    delay: 100,
                  ),
                  const SizedBox(height: 16),
                  _HomeButton(
                    icon: '⚙️',
                    label: 'Settings',
                    isPrimary: false,
                    onTap: () => context.push(AppRoutes.settings),
                    delay: 200,
                  ),
                  const Spacer(flex: 1),
                  Center(
                    child: Text(
                      'v1.0 • Kerala Edition',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Glowing icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.surfaceElevated, AppColors.surfaceCard],
            ),
            boxShadow: AppColors.greenGlow,
            border: Border.all(color: AppColors.cardBorder, width: 1.5),
          ),
          child: const Center(
            child: Text('👤', style: TextStyle(fontSize: 50)),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              duration: 700.ms,
              curve: Curves.elasticOut,
            )
            .animate(
              onPlay: (c) => c.repeat(reverse: true),
            )
            .custom(
              duration: 2000.ms,
              builder: (context, value, child) => Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen
                          .withValues(alpha: 0.2 + value * 0.2),
                      blurRadius: 20 + value * 20,
                      spreadRadius: value * 5,
                    ),
                  ],
                ),
                child: child,
              ),
            ),

        const SizedBox(height: 20),

        Text('IMPOSTER', style: AppTextStyles.heroTitle)
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 500.ms),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'KERALA EDITION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: 3,
            ),
          ),
        ).animate().fadeIn(delay: 400.ms).scale(delay: 400.ms, begin: const Offset(0.8, 0.8)),

        const SizedBox(height: 16),

        Text(
          'കള്ളൻ നിങ്ങളുടെ ഇടയിൽ ഉണ്ട്...',
          style: AppTextStyles.malayalamSubtitle.copyWith(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}

class _HomeButton extends StatefulWidget {
  final String icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  final int delay;

  const _HomeButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<_HomeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) {
          _controller.forward();
        },
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isPrimary ? null : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isPrimary
                  ? AppColors.primaryGreen
                  : AppColors.cardBorder,
              width: 1.5,
            ),
            boxShadow: widget.isPrimary ? AppColors.greenGlow : AppColors.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: widget.isPrimary ? Colors.black : AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 500 + widget.delay))
        .slideY(
          begin: 0.3,
          end: 0,
          delay: Duration(milliseconds: 500 + widget.delay),
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}
