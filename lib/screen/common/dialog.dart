import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class CommonDialog extends ValueRoute<bool> with HasGameReference<WOTGame> {
  final String dialogTitle;

  CommonDialog({
    required this.dialogTitle,
  }) : super(value: false);

  @override
  Component build() {
    return CommonDialogBackdrop(
      child: CommonDialogComponent(
        dialogTitle: dialogTitle,
        onPressed: (value) => completeWith(value),
      ),
    );
  }
}

class CommonDialogBackdrop extends PositionComponent
    with HasGameReference<WOTGame> {
  final Component child;
  late Paint _paint;

  CommonDialogBackdrop({
    required this.child,
  });

  @override
  void onLoad() {
    super.onLoad();
    size = Vector2(game.canvasSize.x, game.canvasSize.y);
    anchor = Anchor.topLeft;
    _paint = Paint()..color = Color(0xFFFFFFFF).withValues(alpha: 0.8);

    add(child);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _paint);
  }
}

class CommonDialogComponent extends PositionComponent
    with HasGameReference<WOTGame>, HasPaint {
  // Dialog base
  /// width include the border 4px
  final _width = 349.0;

  /// height include the border 4px
  final _height = 204.0;

  late Image _bgImage;
  late RRect _rrect;
  late Paint _bgPaint;
  late Paint _borderPaint;

  // Dynamic by context
  final String dialogTitle;
  final void Function(bool) onPressed;

  CommonDialogComponent({
    required this.dialogTitle,
    required this.onPressed,
  }) {
    size = Vector2(_width, _height);

    _rrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      Radius.circular(6),
    );
    _borderPaint = Paint()
      ..color = Color(0xFFA9886C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round;

    setPaint(0, _borderPaint);
  }

  @override
  void onLoad() {
    super.onLoad();
    position = Vector2(
      (game.canvasSize.x) / 2,
      (game.canvasSize.y) / 2,
    );
    anchor = Anchor.center;
    _bgImage = game.images.fromCache(images.itemDialogBg);
    final matrix4Storage = Matrix4.identity().storage;
    final Float64List float64Storage = Float64List.fromList(matrix4Storage);
    _bgPaint = Paint()
      ..color = Color(0xFFA9886C)
      ..shader = ImageShader(
        _bgImage,
        TileMode.repeated,
        TileMode.repeated,
        float64Storage,
      );
    setPaint(1, _bgPaint);

    List<Component> children = [];

    // title
    children.add(TextComponent(
      position: Vector2(_width / 2, 81),
      anchor: Anchor.center,
      text: dialogTitle,
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'TaiwanPearl',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF917156),
        ),
      ),
    ));

    // close button
    children.add(ButtonComponent(
      position: Vector2(48, 147),
      button: CommonDialogButton(
        text: '關閉',
        color: Color(0xFF887768),
        bgColor: Color(0xFFFFDEC1),
        borderColor: Color(0xFF887768),
      ),
      onPressed: () => onPressed(false),
    ));

    // add button
    children.add(ButtonComponent(
      position: Vector2(180, 147),
      button: CommonDialogButton(
        text: '確定',
      ),
      onPressed: () => onPressed(true),
    ));

    addAll(children);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
  }
}

class CommonDialogButton extends PositionComponent with HasPaint {
  final String text;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final TextPainter _textDrawable;
  late final Offset _textOffset;
  late final RRect _rrect;
  late final Paint _borderPaint;
  late final Paint _bgPaint;

  final bool noAnimation;

  CommonDialogButton({
    required this.text,
    this.color = const Color(0xFFFFFFFF),
    this.bgColor = const Color(0xFF6A4D3A),
    this.borderColor = const Color(0xFF6A4D3A),
    this.noAnimation = false,
  }) : _textDrawable = TextPaint(
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ).toTextPainter(text) {
    size = Vector2(120, 36);
    _textOffset = Offset(
      (size.x - _textDrawable.width) / 2,
      (size.y - _textDrawable.height) / 2,
    );
    _rrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      Radius.circular(10),
    );
    _bgPaint = Paint()..color = bgColor;
    _borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = borderColor;
    setPaint(0, _borderPaint);
    setPaint(1, _bgPaint);
  }

  @override
  void onLoad() {
    super.onLoad();

    add(
      SequenceEffect([
        OpacityEffect.to(0, EffectController(duration: 0)),
        OpacityEffect.to(1, EffectController(duration: 0.25)),
      ]),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
    _textDrawable.paint(canvas, _textOffset);
  }
}
