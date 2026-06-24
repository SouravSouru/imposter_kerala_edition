import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/game_session.dart';
import '../../../data/repositories/game_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────
abstract class SetupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetupInitialized extends SetupEvent {}

class PlayerCountChanged extends SetupEvent {
  final int count;
  PlayerCountChanged(this.count);
  @override
  List<Object?> get props => [count];
}

class PlayerNameChanged extends SetupEvent {
  final int index;
  final String name;
  PlayerNameChanged(this.index, this.name);
  @override
  List<Object?> get props => [index, name];
}

class ImposterCountChanged extends SetupEvent {
  final int count;
  ImposterCountChanged(this.count);
  @override
  List<Object?> get props => [count];
}

class DiscussionTimeChanged extends SetupEvent {
  final int minutes;
  DiscussionTimeChanged(this.minutes);
  @override
  List<Object?> get props => [minutes];
}

class CategoryToggled extends SetupEvent {
  final String categoryId;
  CategoryToggled(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class GameStarted extends SetupEvent {}

// ── States ────────────────────────────────────────────────────────────────────
abstract class SetupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetupInitialState extends SetupState {}

class SetupConfigState extends SetupState {
  final int playerCount;
  final List<String> playerNames;
  final int imposterCount;
  final int discussionMinutes;
  final List<CategoryModel> allCategories;
  final List<String> selectedCategoryIds;
  final bool isValid;

  SetupConfigState({
    required this.playerCount,
    required this.playerNames,
    required this.imposterCount,
    required this.discussionMinutes,
    required this.allCategories,
    required this.selectedCategoryIds,
    required this.isValid,
  });

  SetupConfigState copyWith({
    int? playerCount,
    List<String>? playerNames,
    int? imposterCount,
    int? discussionMinutes,
    List<CategoryModel>? allCategories,
    List<String>? selectedCategoryIds,
  }) {
    final newCount = playerCount ?? this.playerCount;
    final newNames = playerNames ?? this.playerNames;
    final newImposters = imposterCount ?? this.imposterCount;
    final newCategories = selectedCategoryIds ?? this.selectedCategoryIds;
    return SetupConfigState(
      playerCount: newCount,
      playerNames: newNames,
      imposterCount: newImposters,
      discussionMinutes: discussionMinutes ?? this.discussionMinutes,
      allCategories: allCategories ?? this.allCategories,
      selectedCategoryIds: newCategories,
      isValid: newCount >= 3 && newImposters < newCount,
    );
  }

  @override
  List<Object?> get props => [
        playerCount,
        playerNames,
        imposterCount,
        discussionMinutes,
        allCategories,
        selectedCategoryIds,
        isValid,
      ];
}

class SetupGameReady extends SetupState {
  final GameSession session;
  SetupGameReady(this.session);
  @override
  List<Object?> get props => [session];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────
class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final GameRepository _gameRepository;

  SetupBloc(this._gameRepository) : super(SetupInitialState()) {
    on<SetupInitialized>(_onInit);
    on<PlayerCountChanged>(_onPlayerCountChanged);
    on<PlayerNameChanged>(_onPlayerNameChanged);
    on<ImposterCountChanged>(_onImposterCountChanged);
    on<DiscussionTimeChanged>(_onDiscussionTimeChanged);
    on<CategoryToggled>(_onCategoryToggled);
    on<GameStarted>(_onGameStarted);
  }

  void _onInit(SetupInitialized event, Emitter<SetupState> emit) {
    final categories = _gameRepository.getAllCategories();
    emit(SetupConfigState(
      playerCount: 4,
      playerNames: List.generate(4, (i) => ''),
      imposterCount: 1,
      discussionMinutes: 2,
      allCategories: categories,
      selectedCategoryIds: categories.map((c) => c.id).toList(),
      isValid: true,
    ));
  }

  void _onPlayerCountChanged(
      PlayerCountChanged event, Emitter<SetupState> emit) {
    if (state is SetupConfigState) {
      final s = state as SetupConfigState;
      final newCount = event.count.clamp(3, 20);
      final names = List.generate(newCount, (i) {
        if (i < s.playerNames.length) return s.playerNames[i];
        return '';
      });
      final newImposter = s.imposterCount.clamp(1, newCount - 1);
      emit(s.copyWith(
        playerCount: newCount,
        playerNames: names,
        imposterCount: newImposter,
      ));
    }
  }

  void _onPlayerNameChanged(
      PlayerNameChanged event, Emitter<SetupState> emit) {
    if (state is SetupConfigState) {
      final s = state as SetupConfigState;
      final names = List<String>.from(s.playerNames);
      if (event.index < names.length) {
        names[event.index] = event.name;
      }
      emit(s.copyWith(playerNames: names));
    }
  }

  void _onImposterCountChanged(
      ImposterCountChanged event, Emitter<SetupState> emit) {
    if (state is SetupConfigState) {
      final s = state as SetupConfigState;
      final max = (s.playerCount - 1).clamp(1, 3);
      emit(s.copyWith(imposterCount: event.count.clamp(1, max)));
    }
  }

  void _onDiscussionTimeChanged(
      DiscussionTimeChanged event, Emitter<SetupState> emit) {
    if (state is SetupConfigState) {
      emit((state as SetupConfigState)
          .copyWith(discussionMinutes: event.minutes));
    }
  }

  void _onCategoryToggled(CategoryToggled event, Emitter<SetupState> emit) {
    if (state is SetupConfigState) {
      final s = state as SetupConfigState;
      final ids = List<String>.from(s.selectedCategoryIds);
      if (ids.contains(event.categoryId)) {
        if (ids.length > 1) ids.remove(event.categoryId);
      } else {
        ids.add(event.categoryId);
      }
      emit(s.copyWith(selectedCategoryIds: ids));
    }
  }

  void _onGameStarted(GameStarted event, Emitter<SetupState> emit) {
    if (state is SetupConfigState) {
      final s = state as SetupConfigState;
      if (!s.isValid) return;
      final config = GameConfig(
        playerCount: s.playerCount,
        playerNames: s.playerNames,
        imposterCount: s.imposterCount,
        discussionDurationMinutes: s.discussionMinutes,
        selectedCategoryIds: s.selectedCategoryIds,
      );
      final session = _gameRepository.createSession(config);
      emit(SetupGameReady(session));
    }
  }
}
