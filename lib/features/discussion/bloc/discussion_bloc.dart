import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/game_session.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class DiscussionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiscussionStarted extends DiscussionEvent {
  final GameSession session;
  DiscussionStarted(this.session);
  @override
  List<Object?> get props => [session];
}

class DiscussionTick extends DiscussionEvent {}
class DiscussionSkipped extends DiscussionEvent {}

// ── States ────────────────────────────────────────────────────────────────────
abstract class DiscussionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiscussionRunning extends DiscussionState {
  final int secondsRemaining;
  final int totalSeconds;
  final String message;

  DiscussionRunning({
    required this.secondsRemaining,
    required this.totalSeconds,
    required this.message,
  });

  double get progress =>
      totalSeconds > 0 ? secondsRemaining / totalSeconds : 0.0;

  @override
  List<Object?> get props => [secondsRemaining, totalSeconds, message];
}

class DiscussionFinished extends DiscussionState {
  final GameSession session;
  DiscussionFinished(this.session);
  @override
  List<Object?> get props => [session];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────
class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  Timer? _timer;
  int _secondsRemaining = 0;
  int _totalSeconds = 0;
  GameSession? _session;
  int _messageIndex = 0;

  static const List<String> _messages = [
    'കള്ളൻ നിങ്ങളുടെ ഇടയിൽ ഉണ്ട് 👀',
    'ആരെയും വിശ്വസിക്കണ്ട 🤨',
    'വളരെ നിശബ്ദം... സംശയം 😏',
    'സത്യം പറയടാ മോനെ 😂',
    'ഒരുത്തൻ കള്ളൻ ഉണ്ട് ഇവിടെ 🕵️',
    'ആരാ ഇത്ര nervous ആയിരിക്കുന്നത്? 🫣',
  ];

  DiscussionBloc() : super(DiscussionRunning(
        secondsRemaining: 120,
        totalSeconds: 120,
        message: _messages[0],
      )) {
    on<DiscussionStarted>(_onStarted);
    on<DiscussionTick>(_onTick);
    on<DiscussionSkipped>(_onSkipped);
  }

  void _onStarted(DiscussionStarted event, Emitter<DiscussionState> emit) {
    _session = event.session;
    _totalSeconds = event.session.discussionDurationMinutes * 60;
    _secondsRemaining = _totalSeconds;
    _messageIndex = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(DiscussionTick());
    });
    emit(DiscussionRunning(
      secondsRemaining: _secondsRemaining,
      totalSeconds: _totalSeconds,
      message: _messages[_messageIndex],
    ));
  }

  void _onTick(DiscussionTick event, Emitter<DiscussionState> emit) {
    if (_secondsRemaining <= 0) {
      _timer?.cancel();
      final session = _session;
      if (session != null) emit(DiscussionFinished(session));
      return;
    }
    _secondsRemaining--;
    // Rotate message every 5 seconds
    if (_secondsRemaining % 5 == 0) {
      _messageIndex = (_messageIndex + 1) % _messages.length;
    }
    emit(DiscussionRunning(
      secondsRemaining: _secondsRemaining,
      totalSeconds: _totalSeconds,
      message: _messages[_messageIndex],
    ));
  }

  void _onSkipped(DiscussionSkipped event, Emitter<DiscussionState> emit) {
    _timer?.cancel();
    final session = _session;
    if (session != null) emit(DiscussionFinished(session));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
