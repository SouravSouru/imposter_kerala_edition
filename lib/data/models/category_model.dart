import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String nameML;
  final String icon;
  final List<String> words;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.nameML,
    required this.icon,
    required this.words,
  });

  @override
  List<Object?> get props => [id, name, nameML, icon, words];

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'nameML': nameML,
        'icon': icon,
        'words': words,
      };

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
        id: map['id'] as String,
        name: map['name'] as String,
        nameML: map['nameML'] as String,
        icon: map['icon'] as String,
        words: List<String>.from(map['words'] as List),
      );
}
