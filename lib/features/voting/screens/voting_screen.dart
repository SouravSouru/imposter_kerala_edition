import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/models/game_session.dart';
import '../../../data/models/player_model.dart';
import '../../../routes/app_router.dart';
import '../bloc/voting_bloc.dart';

class VotingScreen extends StatelessWidget {
  final GameSession session;
  const VotingScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VotingBloc>()..add(VotingStarted(session)),
      child: const _VotingView(),
    );
  }
}

class _VotingView extends StatelessWidget {
  const _VotingView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VotingBloc, VotingState>(
      listener: (context, state) {
        if (state is VotingResult) {
          context.pushReplacement(AppRoutes.result, extra: state.result);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            Container(decoration: const BoxDecoration(gradient: AppColors.backgroundGradient)),
            SafeArea(
              child: BlocBuilder<VotingBloc, VotingState>(
                builder: (context, state) {
                  if (state is VotingInProgress) {
                    return _buildVoting(context, state);
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

  Widget _buildVoting(BuildContext context, VotingInProgress state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🗳️  VOTE THE',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'IMPOSTER',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.dangerRed,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.selectedPlayerId == null
                    ? 'Tap a player to select your vote'
                    : 'Player selected — confirm your vote!',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0, duration: 400.ms),

        const SizedBox(height: 24),

        // Player grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: state.players.length,
              itemBuilder: (context, i) {
                final player = state.players[i];
                final isSelected = state.selectedPlayerId == player.id;
                return _PlayerVoteCard(
                  player: player,
                  isSelected: isSelected,
                  index: i,
                  onTap: () => context.read<VotingBloc>().add(PlayerVoted(player.id)),
                );
              },
            ),
          ),
        ),

        // Confirm button
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: state.selectedPlayerId != null ? 1.0 : 0.4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
              onTap: state.selectedPlayerId != null
                  ? () => context.read<VotingBloc>().add(VoteConfirmed())
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: state.selectedPlayerId != null
                      ? const LinearGradient(
                          colors: [AppColors.dangerRed, AppColors.dangerRedDark],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: state.selectedPlayerId == null ? AppColors.surfaceCard : null,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: state.selectedPlayerId != null ? AppColors.redGlow : [],
                  border: Border.all(
                    color: state.selectedPlayerId != null
                        ? AppColors.dangerRed
                        : AppColors.cardBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    state.selectedPlayerId != null
                        ? '🗳️  Confirm Vote!'
                        : 'Select a player first',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: state.selectedPlayerId != null
                          ? Colors.white
                          : AppColors.textMuted,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerVoteCard extends StatefulWidget {
  final PlayerModel player;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const _PlayerVoteCard({
    required this.player,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  State<_PlayerVoteCard> createState() => _PlayerVoteCardState();
}

class _PlayerVoteCardState extends State<_PlayerVoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(_PlayerVoteCard old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _bounceCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  // Avatar color per player index
  Color get _avatarColor {
    const colors = [
      Color(0xFF00C853), Color(0xFF2979FF), Color(0xFFFF6D00),
      Color(0xFFD500F9), Color(0xFFFF1744), Color(0xFF00BCD4),
      Color(0xFFFFD600), Color(0xFF76FF03),
    ];
    return colors[widget.index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceCtrl,
      builder: (context, child) {
        final bounce = Curves.elasticOut.transform(_bounceCtrl.value);
        return Transform.scale(
          scale: widget.isSelected ? 0.95 + bounce * 0.05 : 1.0,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.dangerRed.withValues(alpha: 0.12)
                : AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? AppColors.dangerRed : AppColors.cardBorder,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected ? AppColors.redGlow : AppColors.cardShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _avatarColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: _avatarColor.withValues(alpha: 0.5), width: 2),
                ),
                child: Center(
                  child: Text(
                    widget.player.name.isNotEmpty
                        ? widget.player.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _avatarColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.player.name,
                style: AppTextStyles.playerName.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.isSelected ? 1.0 : 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.how_to_vote, color: AppColors.dangerRed, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Selected',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.dangerRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.index * 60), duration: 300.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          delay: Duration(milliseconds: widget.index * 60),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}
