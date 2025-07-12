import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/components/background/endless_background.dart';
import 'package:work_on_time_game/components/character/exp_bar.dart';
import 'package:work_on_time_game/components/character/status_meters.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'dart:ui';

class LeaveResult extends PositionComponent with HasGameReference<WOTGame> {
  late EndlessBackground _bg;
  @override
  void onLoad() async {
    super.onLoad();
    await game.images.load(images.greenDotBackground);

    size = Vector2(game.size.x, game.size.y);

    _bg = EndlessBackground(
      image: game.images.fromCache(images.greenDotBackground),
    );
    add(_bg);
    add(ResultSection());

    add(ButtonComponent(
      onPressed: () {
        game.overlays.remove('homeLevelInspector');
        game.router.pushNamed('lobby');
      },
      position: Vector2(107, 478) * 2,
      size: Vector2(180, 52) * 2,
      button: ConfirmButton(),
    ));
  }
}

class ResultSection extends PositionComponent with HasGameReference<WOTGame> {
  late final Paint _bgPaint;
  late final Paint _borderPaint;
  @override
  void onLoad() {
    super.onLoad();
    _bgPaint = Paint()..color = const Color(0xFFF4DBCB);
    _borderPaint = Paint()
      ..color = const Color(0xFFAE866B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    position = Vector2(16, 210) * 2;

    add(TextComponent(
      text: '都準備好了，出發吧',
      position: Vector2(68, 32) * 2,
      textRenderer: TextPaint(
        style: typography.tp48
            .withFontWeight(FontWeight.w600)
            .withShadow()
            .copyWith(
              color: const Color(0xFF917156),
            ),
      ),
    ));

    // divider
    add(RectangleComponent(
      size: Vector2(321, 1) * 2,
      position: Vector2(20, 90) * 2,
      paint: Paint()..color = const Color(0xFFAE866B),
    ));

    add(CircleComponent(
      radius: 32,
      position: Vector2(20, 116) * 2,
      paint: Paint()..color = const Color(0xFFAE866B),
    ));

    add(MindStatusMeter(position: Vector2(199, 133) * 2, meterLevel: 0.5));
    add(SavingStatusMeter(position: Vector2(250, 133) * 2, meterLevel: 0.8));
    add(EnergyStatusMeter(position: Vector2(301, 133) * 2, meterLevel: 1));

    // exp. bar
    add(ExpBar(value: 0.5)..position = Vector2(23, 206) * 2);

    // exp. number text
    add(TextComponent(
      text: '+100',
      position: Vector2(238, 198) * 2,
      textRenderer:
          TextPaint(style: typography.tp48.copyWith(color: Color(0xFF3EB05F))),
    ));

    // exp. text
    add(TextComponent(
      text: 'EXP',
      position: Vector2(298, 198) * 2,
      textRenderer: TextPaint(style: typography.tp48),
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final bgRect = Rect.fromLTWH(0, 0, 361 * 2, 252 * 2);
    final bgRRect = RRect.fromRectAndRadius(bgRect, const Radius.circular(6));
    canvas.drawRRect(bgRRect, _bgPaint);
    canvas.drawRRect(bgRRect, _borderPaint);
  }
}

class ConfirmButton extends PositionComponent {
  @override
  void onLoad() {
    super.onLoad();
    add(TextComponent(
      text: '確認',
      textRenderer: TextPaint(style: typography.tp48),
      position: Vector2(70, 16) * 2,
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final bgRect = Rect.fromLTWH(0, 0, 180 * 2, 52 * 2);
    final bgRRect = RRect.fromRectAndRadius(bgRect, const Radius.circular(10));
    canvas.drawRRect(bgRRect, Paint()..color = const Color(0xFFFFDEC1));

    final borderRect = Rect.fromLTWH(0, 0, 180 * 2, 52 * 2);
    final borderRRect =
        RRect.fromRectAndRadius(borderRect, const Radius.circular(10));
    canvas.drawRRect(
      borderRRect,
      Paint()
        ..color = const Color(0xFF887768)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }
}
