import 'package:equatable/equatable.dart';
import 'player_model.dart';
import 'category_model.dart';

class GameSession extends Equatable {
  final String id;
  final List<PlayerModel> players;
  final CategoryModel category;
  final String secretWord;
  final int imposterCount;
  final int discussionDurationMinutes;
  final DateTime createdAt;

  const GameSession({
    required this.id,
    required this.players,
    required this.category,
    required this.secretWord,
    required this.imposterCount,
    required this.discussionDurationMinutes,
    required this.createdAt,
  });

  List<PlayerModel> get imposters =>
      players.where((p) => p.isImposter).toList();

  List<PlayerModel> get normalPlayers =>
      players.where((p) => !p.isImposter).toList();

  @override
  List<Object?> get props => [
        id,
        players,
        category,
        secretWord,
        imposterCount,
        discussionDurationMinutes,
        createdAt,
      ];
}

class GameConfig extends Equatable {
  final int playerCount;
  final List<String> playerNames;
  final int imposterCount;
  final int discussionDurationMinutes;
  final List<String> selectedCategoryIds;

  const GameConfig({
    required this.playerCount,
    required this.playerNames,
    required this.imposterCount,
    required this.discussionDurationMinutes,
    required this.selectedCategoryIds,
  });

  GameConfig copyWith({
    int? playerCount,
    List<String>? playerNames,
    int? imposterCount,
    int? discussionDurationMinutes,
    List<String>? selectedCategoryIds,
  }) =>
      GameConfig(
        playerCount: playerCount ?? this.playerCount,
        playerNames: playerNames ?? this.playerNames,
        imposterCount: imposterCount ?? this.imposterCount,
        discussionDurationMinutes:
            discussionDurationMinutes ?? this.discussionDurationMinutes,
        selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      );

  @override
  List<Object?> get props => [
        playerCount,
        playerNames,
        imposterCount,
        discussionDurationMinutes,
        selectedCategoryIds,
      ];
}
