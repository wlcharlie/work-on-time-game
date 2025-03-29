import 'package:flame/game.dart';

class Item {
  final String name;
  final String imagePath;
  final String? imagePathLg;
  final String? title;
  final String? description;

  // for 場景
  Vector2 position = Vector2.zero();
  final String sceneName;
  final int priority;

  Item({
    required this.name,
    required this.imagePath,
    this.imagePathLg,
    this.title,
    this.description,
    required this.position,
    required this.sceneName,
    this.priority = 0,
  });
}
