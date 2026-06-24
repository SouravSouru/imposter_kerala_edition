import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../models/game_session.dart';
import '../models/player_model.dart';
import '../../core/constants/app_strings.dart';

class GameRepository {
  final _uuid = const Uuid();
  final _random = Random();

  List<CategoryModel> getAllCategories() {
    return CategoryData.categories
        .map((map) => CategoryModel.fromMap(map))
        .toList();
  }

  List<CategoryModel> getCategoriesById(List<String> ids) {
    return getAllCategories()
        .where((c) => ids.contains(c.id))
        .toList();
  }

  /// Core game logic: randomly assigns roles and secret word to all players.
  GameSession createSession(GameConfig config) {
    // 1. Determine categories to use
    final availableCategories = config.selectedCategoryIds.isNotEmpty
        ? getCategoriesById(config.selectedCategoryIds)
        : getAllCategories();

    // 2. Pick a random category
    final category =
        availableCategories[_random.nextInt(availableCategories.length)];

    // 3. Pick a random word from that category
    final secretWord = category.words[_random.nextInt(category.words.length)];

    // 4. Create player list
    final playerNames = _resolveNames(config);

    // 5. Choose imposter indices (unique random positions)
    final imposterIndices = _pickImposterIndices(
      config.playerCount,
      config.imposterCount,
    );

    // 6. Build PlayerModel list
    final players = List.generate(config.playerCount, (index) {
      final isImposter = imposterIndices.contains(index);
      return PlayerModel(
        id: _uuid.v4(),
        name: playerNames[index],
        role: isImposter ? PlayerRole.imposter : PlayerRole.normal,
        assignedCategory: category.name,
        assignedWord: isImposter ? null : secretWord,
      );
    });

    return GameSession(
      id: _uuid.v4(),
      players: players,
      category: category,
      secretWord: secretWord,
      imposterCount: config.imposterCount,
      discussionDurationMinutes: config.discussionDurationMinutes,
      createdAt: DateTime.now(),
    );
  }

  List<String> _resolveNames(GameConfig config) {
    return List.generate(config.playerCount, (i) {
      if (i < config.playerNames.length &&
          config.playerNames[i].trim().isNotEmpty) {
        return config.playerNames[i].trim();
      }
      return 'Player ${i + 1}';
    });
  }

  Set<int> _pickImposterIndices(int playerCount, int imposterCount) {
    final indices = <int>{};
    while (indices.length < imposterCount) {
      indices.add(_random.nextInt(playerCount));
    }
    return indices;
  }

  /// Determine game result based on votes
  GameResult determineResult({
    required GameSession session,
    required String votedPlayerId,
  }) {
    final votedPlayer =
        session.players.firstWhere((p) => p.id == votedPlayerId);
    final impostersCaught = votedPlayer.isImposter;

    return GameResult(
      session: session,
      votedPlayer: votedPlayer,
      impostersCaught: impostersCaught,
    );
  }
}

class GameResult {
  final GameSession session;
  final PlayerModel votedPlayer;
  final bool impostersCaught;

  const GameResult({
    required this.session,
    required this.votedPlayer,
    required this.impostersCaught,
  });
}
