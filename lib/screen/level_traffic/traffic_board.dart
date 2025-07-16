import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'dart:math';

enum TrafficPointType { lucky, card, coffee, question, home, fallback }

class TrafficBoard extends StatefulWidget {
  final int currentIndex;
  final int totalPoints;
  final double iconSize;
  final double maxWidth;
  final List<TrafficPointType> _points;

  TrafficBoard({
    Key? key,
    required this.currentIndex,
    required this.totalPoints,
    this.iconSize = 36,
    this.maxWidth = 430,
    List<TrafficPointType>? points,
  })  : _points = points ?? _generateRandomPoints(totalPoints),
        super(key: key);

  List<TrafficPointType> get points => _points;

  // 將 getPointType 移到 TrafficBoard 類別中
  TrafficPointType getPointType(int index) {
    if (index < 0) index = 0;
    if (index >= _points.length) index = _points.length - 1;
    return _points[index];
  }

  static List<TrafficPointType> _generateRandomPoints(int count) {
    // 用 Map 設定每種格子的權重（根據要求的機率）
    // 總權重為 100，對應 100% 的機率
    final weights = {
      TrafficPointType.card: 20, // 卡片事件 20%
      TrafficPointType.lucky: 10, // 幸運事件 10%
      TrafficPointType.coffee: 15, // 咖啡事件 15%
      TrafficPointType.question: 15, // 問題事件 15%
      TrafficPointType.home: 10, // 回家事件 10%
      TrafficPointType.fallback: 30, // 一般事件 30%（其餘）
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

  @override
  State<TrafficBoard> createState() => _TrafficBoardState();
}

class _TrafficBoardState extends State<TrafficBoard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TrafficBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 當 currentIndex 改變時，自動滾動到該位置
    if (oldWidget.currentIndex != widget.currentIndex) {
      _scrollToCurrentIndex();
    }
  }

  void _scrollToCurrentIndex() {
    // 計算目標位置的偏移量
    final itemWidth = widget.iconSize + 8.0; // iconSize + padding
    final targetOffset = widget.currentIndex * itemWidth;

    // 計算滾動位置，讓目標位置居中顯示
    final containerWidth = widget.maxWidth - 8.0; // 減去 padding
    final scrollOffset = targetOffset - (containerWidth / 2) + (itemWidth / 2);

    // 確保滾動範圍在有效範圍內
    final maxScrollExtent = (widget.totalPoints * itemWidth) - containerWidth;
    final clampedOffset = scrollOffset.clamp(0.0, maxScrollExtent);

    // 平滑滾動到目標位置
    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.maxWidth,
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
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.totalPoints, (index) {
            final type = widget._points[index];
            final icon = _getIcon(type);
            final color = _getColor(type);
            final isQuestionOrFallback = (type == TrafficPointType.question ||
                type == TrafficPointType.fallback);
            final double thisIconSize =
                isQuestionOrFallback ? widget.iconSize * 1.3 : widget.iconSize;
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
                  if (index == widget.currentIndex)
                    Positioned(
                      right: -thisIconSize * 0.35,
                      bottom: -thisIconSize * 0.35,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
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
