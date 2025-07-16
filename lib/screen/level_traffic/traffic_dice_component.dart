import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class TrafficDiceComponent extends PositionComponent
    with HasGameReference<WOTGame>, TapCallbacks, RiverpodComponentMixin {
  late final SpriteComponent _dice;
  late final List<SpriteComponent> _diceRolls;
  late final TextComponent _diceText;
  bool _isRolling = false;
  int _currentRoll = 0;

  TrafficDiceComponent() {
    _diceRolls = [];
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 建立骰子
    _dice = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.dice)),
      size: Vector2(100, 100),
      position: Vector2(
        game.size.x / 2 - 50,
        game.size.y * 0.6,
      ),
    );
    add(_dice);

    // 建立骰子動畫
    for (int i = 1; i <= 9; i++) {
      final roll = SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('traffic_scene/dice_$i.png'),
        ),
        size: Vector2(100, 100),
        position: _dice.position,
      );
      roll.opacity = 0;
      _diceRolls.add(roll);
      add(roll);
    }

    // 建立骰子文字
    _diceText = TextComponent(
      text: '骰子前進',
      position: Vector2(
        game.size.x / 2,
        game.size.y * 0.6 + 120,
      ),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 24,
        ),
      ),
    );
    add(_diceText);
  }

  void roll() {
    if (_isRolling) return;
    _isRolling = true;
    _dice.opacity = 0;
    _diceText.textRenderer = TextPaint(
      style: const TextStyle(
        color: Color(0x00000000),
        fontSize: 24,
      ),
    );

    // 隨機選擇一個骰子動畫
    _currentRoll = Random().nextInt(9);
    _diceRolls[_currentRoll].opacity = 1;

    // 動畫結束後顯示點數
    Future.delayed(const Duration(milliseconds: 500), () {
      _diceRolls[_currentRoll].opacity = 0;
      _dice.opacity = 1;
      _diceText.textRenderer = TextPaint(
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 24,
        ),
      );
      _diceText.text = '移動${_currentRoll + 1}格！';
      _isRolling = false;
    });
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_isRolling) {
      roll();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isRolling) {
      // 繪製動畫幀
      final sprite = Sprite(
        game.images.fromCache(
          'traffic_scene/dice_$_currentRoll.png',
        ),
      );
      sprite.render(
        canvas,
        position: Vector2(200, 25),
        size: Vector2(100, 50),
      );
    } else if (_currentRoll != null) {
      // 繪製骰子點數
      _renderDiceFace(canvas, _currentRoll! + 1, Vector2(150, 25));
    }
  }

  void _renderDiceFace(Canvas canvas, int point, Vector2 position) {
    final paint = Paint()..color = const Color(0xFFAE866B);
    final dotRadius = 4.0;
    final spacing = 20.0;

    switch (point) {
      case 1:
        canvas.drawCircle(
          Offset(position.x, position.y),
          dotRadius,
          paint,
        );
        break;
      case 2:
        canvas.drawCircle(
          Offset(position.x - spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        break;
      case 3:
        canvas.drawCircle(
          Offset(position.x - spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x, position.y),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        break;
      case 4:
        canvas.drawCircle(
          Offset(position.x - spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x - spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        break;
      case 5:
        canvas.drawCircle(
          Offset(position.x - spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x, position.y),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x - spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        break;
      case 6:
        canvas.drawCircle(
          Offset(position.x - spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y - spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x - spacing, position.y),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x - spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        canvas.drawCircle(
          Offset(position.x + spacing, position.y + spacing),
          dotRadius,
          paint,
        );
        break;
    }
  }
}
