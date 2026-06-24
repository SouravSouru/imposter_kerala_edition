import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Animated background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
          // Floating particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: _ParticlePainter(_particleController.value),
                size: Size.infinite,
              );
            },
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing orb behind logo
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 80,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
                // Question mark icon
                Text(
                  '👤',
                  style: const TextStyle(fontSize: 80),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                // IMPOSTER title
                Text(
                  'IMPOSTER',
                  style: AppTextStyles.heroTitle,
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms)
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      delay: 300.ms,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 8),

                // Kerala Edition subtitle
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'KERALA EDITION',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 3,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      delay: 600.ms,
                      duration: 400.ms,
                    ),

                const SizedBox(height: 40),

                // Loading dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(
                          onPlay: (c) => c.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.2, 1.2),
                          delay: Duration(milliseconds: i * 150),
                          duration: 500.ms,
                        );
                  }),
                ).animate().fadeIn(delay: 900.ms, duration: 400.ms),

                const SizedBox(height: 80),

                // Tagline
                Text(
                  'കള്ളൻ നിങ്ങളുടെ ഇടയിൽ ഉണ്ട്...',
                  style: AppTextStyles.malayalamSubtitle.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<_Particle> _particles;
  static const int _count = 20;

  _ParticlePainter(this.progress)
      : _particles = List.generate(_count, (i) => _Particle(i, _count));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    for (final p in _particles) {
      final x = (p.x * size.width + p.speedX * progress * size.width) %
          size.width;
      final y = (p.y * size.height -
              p.speedY * progress * size.height +
              size.height) %
          size.height;

      final opacity =
          (sin(progress * 2 * pi + p.phase) * 0.5 + 0.5) * 0.4;
      paint.color = (p.isQuestion
              ? AppColors.accentGold
              : AppColors.primaryGreen)
          .withValues(alpha: opacity);

      if (p.isQuestion) {
        final tp = TextPainter(
          text: TextSpan(
            text: '?',
            style: TextStyle(
              color: AppColors.accentGold.withValues(alpha: opacity),
              fontSize: p.size * 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x, y));
      } else {
        canvas.drawCircle(Offset(x, y), p.size, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x;
  final double y;
  final double speedX;
  final double speedY;
  final double size;
  final double phase;
  final bool isQuestion;

  _Particle(int index, int total)
      : x = _hash(index * 7 + 1),
        y = _hash(index * 13 + 5),
        speedX = (_hash(index * 3 + 2) - 0.5) * 0.3,
        speedY = _hash(index * 11 + 3) * 0.2 + 0.05,
        size = _hash(index * 17 + 7) * 4 + 2,
        phase = _hash(index * 5 + 9) * 2 * pi,
        isQuestion = index % 4 == 0;

  static double _hash(int n) => ((n * 1664525 + 1013904223) & 0xFFFFFFFF) / 0xFFFFFFFF;
}
