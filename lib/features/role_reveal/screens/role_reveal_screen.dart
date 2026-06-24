import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/game_session.dart';
import '../../../routes/app_router.dart';
import '../bloc/role_reveal_bloc.dart';

class RoleRevealScreen extends StatelessWidget {
  final GameSession session;
  const RoleRevealScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoleRevealBloc()..add(RoleRevealStarted(session)),
      child: const _RoleRevealView(),
    );
  }
}

class _RoleRevealView extends StatelessWidget {
  const _RoleRevealView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleRevealBloc, RoleRevealState>(
      listener: (context, state) {
        if (state is RoleRevealAllDone) {
          context.pushReplacement(AppRoutes.discussion, extra: state.session);
        }
      },
      child: BlocBuilder<RoleRevealBloc, RoleRevealState>(
        builder: (context, state) {
          if (state is RoleRevealWaiting) {
            return _WaitingScreen(state: state);
          } else if (state is RoleRevealShowing) {
            return _RevealedScreen(state: state);
          }
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
          );
        },
      ),
    );
  }
}

// ── Waiting Screen (Hold to Reveal) ──────────────────────────────────────────
class _WaitingScreen extends StatefulWidget {
  final RoleRevealWaiting state;
  const _WaitingScreen({required this.state});

  @override
  State<_WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<_WaitingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _isHolding = false;
  Timer? _holdTimer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() => _progress = _progressController.value);
      });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _holdTimer?.cancel();
    super.dispose();
  }

  void _startHold() {
    setState(() => _isHolding = true);
    _progressController.forward(from: 0);
    _holdTimer = Timer(const Duration(milliseconds: 1000), () {
      if (_isHolding && mounted) {
        _onRevealComplete();
      }
    });
    _vibrate(50);
  }

  void _cancelHold() {
    setState(() {
      _isHolding = false;
      _progress = 0;
    });
    _progressController.stop();
    _progressController.reset();
    _holdTimer?.cancel();
  }

  void _onRevealComplete() async {
    _vibrate(200);
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      context.read<RoleRevealBloc>().add(RoleRevealCompleted());
    }
  }

  Future<void> _vibrate(int ms) async {
    try {
      final hasVibrator = (await Vibration.hasVibrator()) == true;
      if (hasVibrator) Vibration.vibrate(duration: ms);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.state.currentPlayer;
    final index = widget.state.currentIndex;
    final total = widget.state.totalPlayers;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppColors.backgroundGradient)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ROLE REVEAL',
                        style: AppTextStyles.goldLabel,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          '${index + 1} / $total',
                          style: AppTextStyles.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Player indicator
                Text(
                  player.name,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.accentGold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.2, end: 0, duration: 400.ms),

                const SizedBox(height: 8),

                Text(
                  "It's your turn!",
                  style: AppTextStyles.bodyLarge,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 60),

                // Hold to reveal button
                GestureDetector(
                  onLongPressStart: (_) => _startHold(),
                  onLongPressEnd: (_) {
                    if (_progress < 0.99) _cancelHold();
                  },
                  onLongPressCancel: _cancelHold,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 200 + (_isHolding ? 20.0 : 0),
                          height: 200 + (_isHolding ? 20.0 : 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: _isHolding
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryGreen.withValues(alpha: 0.3),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    )
                                  ]
                                : [],
                          ),
                        ),
                        // Progress arc
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 4,
                            backgroundColor:
                                AppColors.primaryGreen.withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        // Inner circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isHolding
                                ? AppColors.primaryGreen.withValues(alpha: 0.15)
                                : AppColors.surfaceCard,
                            border: Border.all(
                              color: _isHolding
                                  ? AppColors.primaryGreen
                                  : AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isHolding ? '🔓' : '🔒',
                                style: TextStyle(
                                  fontSize: _isHolding ? 44 : 40,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isHolding ? 'Revealing...' : 'Hold',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: _isHolding
                                      ? AppColors.primaryGreen
                                      : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Tap & Hold to Reveal Your Role',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn().then().fadeOut(duration: 1000.ms),

                const Spacer(flex: 2),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    '🔒 Make sure no one else can see your screen',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
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

// ── Revealed Screen (Card Flip) ───────────────────────────────────────────────
class _RevealedScreen extends StatefulWidget {
  final RoleRevealShowing state;
  const _RevealedScreen({required this.state});

  @override
  State<_RevealedScreen> createState() => _RevealedScreenState();
}

class _RevealedScreenState extends State<_RevealedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnim;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _flipAnim = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    )..addListener(() {
        if (_flipAnim.value > pi / 2 && _showFront) {
          setState(() => _showFront = false);
        }
      });

    // Auto-start flip after slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _flipController.forward();
    });

    _vibrateImposter();
  }

  Future<void> _vibrateImposter() async {
    if (!widget.state.isImposter) return;
    try {
      final hasVibrator = (await Vibration.hasVibrator()) == true;
      if (hasVibrator) {
        await Future.delayed(const Duration(milliseconds: 900));
        Vibration.vibrate(pattern: [0, 100, 100, 200, 100, 400]);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isImposter = widget.state.isImposter;

    return Scaffold(
      backgroundColor: isImposter ? AppColors.imposterBackground : AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: isImposter
                  ? AppColors.imposterGradient
                  : AppColors.normalRevealGradient,
            ),
          ),
          // Imposter red pulse overlay
          if (isImposter)
            _ImposterPulse(),
          // Particles
          if (!_showFront)
            _ParticleBurst(isImposter: isImposter),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.state.currentPlayer.name.toUpperCase(),
                        style: AppTextStyles.goldLabel.copyWith(
                          color: AppColors.accentGold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          '${widget.state.currentIndex + 1} / ${widget.state.totalPlayers}',
                          style: AppTextStyles.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // The 3D flipping card
                AnimatedBuilder(
                  animation: _flipAnim,
                  builder: (context, child) {
                    final angle = _flipAnim.value;
                    final transform = Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle);
                    return Transform(
                      transform: transform,
                      alignment: Alignment.center,
                      child: angle < pi / 2
                          ? _CardFront()
                          : Transform(
                              transform: Matrix4.identity()..rotateY(pi),
                              alignment: Alignment.center,
                              child: _showFront
                                  ? _CardFront()
                                  : (isImposter
                                      ? _ImposterCard(state: widget.state)
                                      : _NormalCard(state: widget.state)),
                            ),
                    );
                  },
                ),
                const Spacer(),
                // Hide & Pass button (shows after reveal)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _showFront ? 0 : 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GestureDetector(
                      onTap: _showFront
                          ? null
                          : () => context.read<RoleRevealBloc>().add(NextPlayer()),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.cardBorder, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🙈', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: 10),
                            Text(
                              'Hide & Pass Phone',
                              style: AppTextStyles.labelLarge.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card Front (hidden side) ──────────────────────────────────────────────────
class _CardFront extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🃏', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            'YOUR ROLE',
            style: AppTextStyles.goldLabel,
          ),
          const SizedBox(height: 8),
          Text(
            'Revealing...',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ── Normal Player Card ────────────────────────────────────────────────────────
class _NormalCard extends StatelessWidget {
  final RoleRevealShowing state;
  const _NormalCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surfaceElevated, AppColors.surfaceCard],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorder, width: 1.5),
        boxShadow: AppColors.greenGlow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryGreen, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield, color: AppColors.primaryGreen, size: 16),
                const SizedBox(width: 6),
                Text('CREWMATE', style: AppTextStyles.categoryTag),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Category
          Text(
            state.category,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
              letterSpacing: 2,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(begin: -0.3, end: 0, delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // The word
          Text(
            state.word,
            style: AppTextStyles.secretWord,
            textAlign: TextAlign.center,
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                delay: 400.ms,
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(delay: 400.ms),

          const SizedBox(height: 28),

          // Sparkles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return Text(
                i == 2 ? '⭐' : '✨',
                style: TextStyle(fontSize: i == 2 ? 24 : 16),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0, 0),
                    delay: Duration(milliseconds: 600 + i * 80),
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  );
            }),
          ),

          const SizedBox(height: 24),

          // Funny message
          Text(
            'കള്ളനെ കണ്ടെത്തണം 😎',
            style: AppTextStyles.malayalamFunny,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 800.ms),

          const SizedBox(height: 8),

          Text(
            'Remember your word. Don\'t reveal it!',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 900.ms),
        ],
      ),
    );
  }
}

// ── Imposter Card ─────────────────────────────────────────────────────────────
class _ImposterCard extends StatelessWidget {
  final RoleRevealShowing state;
  const _ImposterCard({required this.state});

  String get _randomMessage {
    final r = Random();
    return AppStrings.imposterMessages[r.nextInt(AppStrings.imposterMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0008), Color(0xFF0D0004)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.dangerRed.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: AppColors.redGlow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.dangerRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.dangerRed, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.dangerRed, size: 16),
                const SizedBox(width: 6),
                Text(
                  'IMPOSTER',
                  style: AppTextStyles.categoryTag.copyWith(color: AppColors.dangerRed),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Devil emoji with shake animation
          const Text('😈', style: TextStyle(fontSize: 72))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .custom(
                duration: 400.ms,
                builder: (context, value, child) => Transform.rotate(
                  angle: sin(value * pi * 2) * 0.1,
                  child: child,
                ),
              ),

          const SizedBox(height: 20),

          Text(
            'YOU ARE THE\nIMPOSTER',
            style: AppTextStyles.imposterTitle,
            textAlign: TextAlign.center,
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                delay: 200.ms,
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          // Word hidden
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.dangerRed.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.dangerRed.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  '???',
                  style: AppTextStyles.secretWord.copyWith(
                    color: AppColors.dangerRed,
                    fontSize: 42,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Word Hidden — Figure it out! 😈',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.dangerRed.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 24),

          // Random Malayalam message
          Text(
            _randomMessage,
            style: AppTextStyles.malayalamFunny.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }
}

// ── Imposter Pulse Overlay ────────────────────────────────────────────────────
class _ImposterPulse extends StatefulWidget {
  @override
  State<_ImposterPulse> createState() => _ImposterPulseState();
}

class _ImposterPulseState extends State<_ImposterPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppColors.dangerRed.withValues(alpha: _controller.value * 0.12),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Particle Burst ────────────────────────────────────────────────────────────
class _ParticleBurst extends StatefulWidget {
  final bool isImposter;
  const _ParticleBurst({required this.isImposter});

  @override
  State<_ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<_ParticleBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _BurstPainter(
          progress: _controller.value,
          isImposter: widget.isImposter,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  final double progress;
  final bool isImposter;

  _BurstPainter({required this.progress, required this.isImposter});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const count = 16;
    final paint = Paint()..style = PaintingStyle.fill;
    final color = isImposter ? AppColors.dangerRed : AppColors.primaryGreen;

    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 2 * pi;
      final distance = progress * size.height * 0.6;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      paint.color = color.withValues(alpha: opacity * 0.6);
      final x = center.dx + cos(angle) * distance;
      final y = center.dy + sin(angle) * distance;
      canvas.drawCircle(Offset(x, y), 4 * (1 - progress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.progress != progress;
}
