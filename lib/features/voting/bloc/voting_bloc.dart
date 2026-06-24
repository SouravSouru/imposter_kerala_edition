import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/game_session.dart';
import '../../../data/models/player_model.dart';
import '../../../data/repositories/game_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class VotingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VotingStarted extends VotingEvent {
  final GameSession session;
  VotingStarted(this.session);
  @override
  List<Object?> get props => [session];
}

class PlayerVoted extends VotingEvent {
  final String playerId;
  PlayerVoted(this.playerId);
  @override
  List<Object?> get props => [playerId];
}

class VoteConfirmed extends VotingEvent {}

// ── States ────────────────────────────────────────────────────────────────────
abstract class VotingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VotingInProgress extends VotingState {
  final List<PlayerModel> players;
  final String? selectedPlayerId;

  VotingInProgress({required this.players, this.selectedPlayerId});

  @override
  List<Object?> get props => [players, selectedPlayerId];
}

class VotingResult extends VotingState {
  final GameResult result;
  VotingResult(this.result);
  @override
  List<Object?> get props => [result];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────
class VotingBloc extends Bloc<VotingEvent, VotingState> {
  final GameRepository _gameRepository;
  GameSession? _session;

  VotingBloc(this._gameRepository)
      : super(VotingInProgress(players: [])) {
    on<VotingStarted>(_onStarted);
    on<PlayerVoted>(_onPlayerVoted);
    on<VoteConfirmed>(_onVoteConfirmed);
  }

  void _onStarted(VotingStarted event, Emitter<VotingState> emit) {
    _session = event.session;
    emit(VotingInProgress(players: event.session.players));
  }

  void _onPlayerVoted(PlayerVoted event, Emitter<VotingState> emit) {
    final session = _session;
    if (session == null) return;
    emit(VotingInProgress(
      players: session.players,
      selectedPlayerId: event.playerId,
    ));
  }

  void _onVoteConfirmed(VoteConfirmed event, Emitter<VotingState> emit) {
    final session = _session;
    if (state is! VotingInProgress) return;
    final votingState = state as VotingInProgress;
    final selectedId = votingState.selectedPlayerId;
    if (selectedId == null || session == null) return;

    final result = _gameRepository.determineResult(
      session: session,
      votedPlayerId: selectedId,
    );
    emit(VotingResult(result));
  }
}
