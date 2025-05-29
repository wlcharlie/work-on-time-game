import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'dart:math';

enum TrafficPointType { lucky, card, coffee, question, home, fallback }

class TrafficBoard extends StatelessWidget {
  final int currentIndex;
  final int totalPoints;
  final double iconSize;
  final double maxWidth;
  late final List<TrafficPointType> _points;

  TrafficBoard({
    Key? key,
    required this.currentIndex,
    required this.totalPoints,
    this.iconSize = 36,
    this.maxWidth = 430,
  })  : _points = _generateRandomPoints(totalPoints),
        super(key: key);

  static List<TrafficPointType> _generateRandomPoints(int count) {
    // 用 Map 設定每種格子的權重
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
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: TrafficColors.background,
        border: Border(
          top: BorderSide(color: TrafficColors.border, width: 8),
          bottom: BorderSide(color: TrafficColors.border, width: 8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPoints, (index) {
            final type = _points[index];
            final icon = _getIcon(type);
            final color = _getColor(type);
            final isQuestionOrFallback = (type == TrafficPointType.question ||
                type == TrafficPointType.fallback);
            final double thisIconSize =
                isQuestionOrFallback ? iconSize * 1.3 : iconSize;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  icon != null
                      ? Container(
                          width: thisIconSize,
                          height: thisIconSize,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Image.asset(
                                images.getFullPath(icon),
                                width: thisIconSize * 0.6,
                                height: thisIconSize * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: thisIconSize,
                          height: thisIconSize,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                  if (index == currentIndex)
                    Positioned(
                      right: -thisIconSize * 0.35,
                      bottom: -thisIconSize * 0.35,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          images.getFullPath(images.anchor),
                          width:
                              thisIconSize * 1.1 < 32 ? 32 : thisIconSize * 1.1,
                          height:
                              thisIconSize * 1.1 < 32 ? 32 : thisIconSize * 1.1,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
