import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/game_session.dart';
import '../../../routes/app_router.dart';
import '../bloc/discussion_bloc.dart';

class DiscussionScreen extends StatelessWidget {
  final GameSession session;
  const DiscussionScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscussionBloc()..add(DiscussionStarted(session)),
      child: _DiscussionView(session: session),
    );
  }
}

class _DiscussionView extends StatelessWidget {
  final GameSession session;
  const _DiscussionView({required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscussionBloc, DiscussionState>(
      listener: (context, state) {
        if (state is DiscussionFinished) {
          context.pushReplacement(AppRoutes.voting, extra: state.session);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: AppColors.backgroundGradient)),
            // Subtle green radial glow
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1,
                    colors: [
                      AppColors.primaryGreen.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: BlocBuilder<DiscussionBloc, DiscussionState>(
                builder: (context, state) {
                  if (state is DiscussionRunning) {
                    return _buildRunning(context, state);
                  }
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGreen),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunning(BuildContext context, DiscussionRunning state) {
    final mins = state.secondsRemaining ~/ 60;
    final secs = state.secondsRemaining % 60;
    final timeStr = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    final isUrgent = state.secondsRemaining <= 30;

    return Column(
      children: [
        const SizedBox(height: 40),

        // Title
        Text(
          'DISCUSSION',
          style: AppTextStyles.headlineLarge.copyWith(
            letterSpacing: 6,
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ).animate().fadeIn(duration: 500.ms),

        Text(
          'TIME',
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 8,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 500.ms),

        const Spacer(),

        // Circular timer
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isUrgent ? AppColors.dangerRed : AppColors.primaryGreen)
                        .withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            // Progress ring
            SizedBox(
              width: 240,
              height: 240,
              child: CircularProgressIndicator(
                value: state.progress,
                strokeWidth: 6,
                backgroundColor: AppColors.surfaceElevated,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isUrgent ? AppColors.dangerRed : AppColors.primaryGreen,
                ),
                strokeCap: StrokeCap.round,
              ),
            ),
            // Inner content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: AppTextStyles.timer.copyWith(
                    color: isUrgent ? AppColors.dangerRed : AppColors.textPrimary,
                    fontSize: isUrgent ? 80 : 72,
                  ),
                  child: Text(timeStr),
                ),
                Text(
                  'remaining',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),

        const Spacer(),

        // Rotating message
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: Padding(
            key: ValueKey(state.message),
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              state.message,
              style: AppTextStyles.malayalamHeadline.copyWith(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 48),

        // Action buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () =>
                      context.read<DiscussionBloc>().add(DiscussionSkipped()),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.surfaceCard,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                  child: Text(
                    'Proceed to Vote →',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
