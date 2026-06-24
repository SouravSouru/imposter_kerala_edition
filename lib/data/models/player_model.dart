import 'package:equatable/equatable.dart';

enum PlayerRole { normal, imposter }

class PlayerModel extends Equatable {
  final String id;
  final String name;
  final PlayerRole role;
  final String? assignedWord;
  final String? assignedCategory;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.role,
    this.assignedWord,
    this.assignedCategory,
  });

  bool get isImposter => role == PlayerRole.imposter;

  PlayerModel copyWith({
    String? id,
    String? name,
    PlayerRole? role,
    String? assignedWord,
    String? assignedCategory,
  }) =>
      PlayerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        assignedWord: assignedWord ?? this.assignedWord,
        assignedCategory: assignedCategory ?? this.assignedCategory,
      );

  @override
  List<Object?> get props => [id, name, role, assignedWord, assignedCategory];
}
