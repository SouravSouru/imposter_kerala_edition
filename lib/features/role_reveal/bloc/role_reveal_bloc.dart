import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/game_session.dart';
import '../../../data/models/player_model.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class RoleRevealEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RoleRevealStarted extends RoleRevealEvent {
  final GameSession session;
  RoleRevealStarted(this.session);
  @override
  List<Object?> get props => [session];
}

class RoleRevealCompleted extends RoleRevealEvent {}
class NextPlayer extends RoleRevealEvent {}

// ── States ────────────────────────────────────────────────────────────────────
abstract class RoleRevealState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RoleRevealInitial extends RoleRevealState {}

class RoleRevealWaiting extends RoleRevealState {
  final PlayerModel currentPlayer;
  final int currentIndex;
  final int totalPlayers;

  RoleRevealWaiting({
    required this.currentPlayer,
    required this.currentIndex,
    required this.totalPlayers,
  });

  @override
  List<Object?> get props => [currentPlayer, currentIndex, totalPlayers];
}

class RoleRevealShowing extends RoleRevealState {
  final PlayerModel currentPlayer;
  final int currentIndex;
  final int totalPlayers;
  final String category;
  final String word;
  final bool isImposter;

  RoleRevealShowing({
    required this.currentPlayer,
    required this.currentIndex,
    required this.totalPlayers,
    required this.category,
    required this.word,
    required this.isImposter,
  });

  @override
  List<Object?> get props => [
        currentPlayer,
        currentIndex,
        totalPlayers,
        category,
        word,
        isImposter,
      ];
}

class RoleRevealAllDone extends RoleRevealState {
  final GameSession session;
  RoleRevealAllDone(this.session);
  @override
  List<Object?> get props => [session];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────
class RoleRevealBloc extends Bloc<RoleRevealEvent, RoleRevealState> {
  GameSession? _session;
  int _currentIndex = 0;

  RoleRevealBloc() : super(RoleRevealInitial()) {
    on<RoleRevealStarted>(_onStarted);
    on<RoleRevealCompleted>(_onCompleted);
    on<NextPlayer>(_onNextPlayer);
  }

  void _onStarted(RoleRevealStarted event, Emitter<RoleRevealState> emit) {
    _session = event.session;
    _currentIndex = 0;
    _emitWaiting(emit);
  }

  void _onCompleted(RoleRevealCompleted event, Emitter<RoleRevealState> emit) {
    final session = _session;
    if (session == null) return;
    final player = session.players[_currentIndex];
    emit(RoleRevealShowing(
      currentPlayer: player,
      currentIndex: _currentIndex,
      totalPlayers: session.players.length,
      category: '${session.category.icon} ${session.category.name}',
      word: player.isImposter ? '???' : (player.assignedWord ?? ''),
      isImposter: player.isImposter,
    ));
  }

  void _onNextPlayer(NextPlayer event, Emitter<RoleRevealState> emit) {
    final session = _session;
    if (session == null) return;
    _currentIndex++;
    if (_currentIndex >= session.players.length) {
      emit(RoleRevealAllDone(session));
    } else {
      _emitWaiting(emit);
    }
  }

  void _emitWaiting(Emitter<RoleRevealState> emit) {
    final session = _session;
    if (session == null) return;
    emit(RoleRevealWaiting(
      currentPlayer: session.players[_currentIndex],
      currentIndex: _currentIndex,
      totalPlayers: session.players.length,
    ));
  }
}
