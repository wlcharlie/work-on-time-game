import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/wot_game.dart';

enum TrafficPointType { lucky, card, coffee, question, home, fallback }

class TrafficBoardComponent extends PositionComponent
    with HasGameReference<WOTGame>, TapCallbacks, RiverpodComponentMixin {
  final int totalPoints;
  late final List<TrafficPointType> _points;
  late final List<PositionComponent> _pointSprites;
  late final SpriteComponent _anchor;

  TrafficBoardComponent({this.totalPoints = 20}) {
    _points = _generateRandomPoints(totalPoints);
    _pointSprites = [];
  }

  static List<TrafficPointType> _generateRandomPoints(int count) {
    final weights = {
      TrafficPointType.home: 1,
      TrafficPointType.lucky: 2,
      TrafficPointType.coffee: 3,
      TrafficPointType.question: 1,
      TrafficPointType.card: 3,
      TrafficPointType.fallback: 2,
    };
    final rand = Random();
    final types = weights.keys.toList();
    final totalWeight = weights.values.reduce((a, b) => a + b);

    List<TrafficPointType> result = [];
    for (int i = 0; i < count; i++) {
      int pick = rand.nextInt(totalWeight);
      int sum = 0;
      for (final type in types) {
        sum += weights[type]!;
        if (pick < sum) {
          result.add(type);
          break;
        }
      }
    }
    return result;
  }

  String? _getIcon(TrafficPointType type) {
    switch (type) {
      case TrafficPointType.lucky:
        return images.trafficPointCardLucky;
      case TrafficPointType.card:
        return images.trafficPointCard;
      case TrafficPointType.coffee:
        return images.trafficPointCardCoffee;
      case TrafficPointType.question:
        return images.trafficPointCardQuestion;
      case TrafficPointType.home:
        return images.trafficPointCardHome;
      default:
        return null;
    }
  }

  Color _getColor(TrafficPointType type) {
    switch (type) {
      case TrafficPointType.lucky:
        return TrafficColors.lucky;
      case TrafficPointType.card:
        return TrafficColors.card;
      case TrafficPointType.coffee:
        return TrafficColors.coffee;
      case TrafficPointType.question:
        return TrafficColors.question;
      case TrafficPointType.home:
        return TrafficColors.home;
      default:
        return TrafficColors.fallback;
    }
  }

  TrafficPointType getPointType(int index) {
    return _points[index];
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 建立格子
    final iconSize = 36.0;
    final spacing = 8.0;
    for (int i = 0; i < totalPoints; i++) {
      final type = _points[i];
      final icon = _getIcon(type);
      final color = _getColor(type);
      final isQuestionOrFallback = (type == TrafficPointType.question ||
          type == TrafficPointType.fallback);
      final thisIconSize = isQuestionOrFallback ? iconSize * 1.3 : iconSize;

      if (icon != null) {
        final point = SpriteComponent(
          sprite: Sprite(game.images.fromCache(icon)),
          size: Vector2(thisIconSize, thisIconSize),
          position: Vector2(i * (thisIconSize + spacing), 0),
        );
        _pointSprites.add(point);
        add(point);
      } else {
        final point = RectangleComponent(
          size: Vector2(thisIconSize, thisIconSize),
          position: Vector2(i * (thisIconSize + spacing), 0),
          paint: Paint()..color = color,
        );
        _pointSprites.add(point);
        add(point);
      }
    }

    // 建立角色指示器
    _anchor = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.anchor)),
      size: Vector2(iconSize * 1.1, iconSize * 1.1),
    );
    add(_anchor);
  }

  void updatePlayerPosition(int index) {
    if (index >= 0 && index < _pointSprites.length) {
      final point = _pointSprites[index];
      _anchor.position = Vector2(
        point.position.x + point.size.x * 0.65,
        point.position.y + point.size.y * 0.65,
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    // 處理點擊事件
  }
}
