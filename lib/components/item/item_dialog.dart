import 'dart:ui';
import 'package:flame/effects.dart';
import 'package:flutter/painting.dart';
import 'dart:typed_data';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class ItemDialog extends ValueRoute<bool> with HasGameReference<WOTGame> {
  final String imagePath;
  final String dialogTitle;
  final String? dialogDescription;
  final bool noAnimation;
  final bool withBackdrop;
  final bool revertAction;

  late Image image;

  ItemDialog({
    required this.imagePath,
    required this.dialogTitle,
    this.dialogDescription,
    this.noAnimation = false,
    this.withBackdrop = false,
    this.revertAction = false,
  }) : super(value: false);

  @override
  Component build() {
    return ItemDialogBackdrop(
      showBackdrop: withBackdrop,
      child: ItemDialogComponent(
        imagePath: imagePath,
        dialogTitle: dialogTitle,
        dialogDescription: dialogDescription,
        noAnimation: noAnimation,
        revertAction: revertAction,
        onPressed: (value) => completeWith(value),
      ),
    );
  }
}

class ItemDialogBackdrop extends PositionComponent
    with HasGameReference<WOTGame> {
  final Component child;
  final bool showBackdrop;
  late Paint _paint;

  ItemDialogBackdrop({required this.child, required this.showBackdrop});

  @override
  void onLoad() {
    super.onLoad();
    size = Vector2(game.canvasSize.x, game.canvasSize.y);
    anchor = Anchor.topLeft;
    _paint = Paint()..color = Color(0xFFFFFFFF).withValues(alpha: 0.2);

    add(child);
  }

  @override
  void render(Canvas canvas) {
    if (showBackdrop) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _paint);
    }
  }
}

class ItemDialogComponent extends PositionComponent
    with HasGameReference<WOTGame>, HasPaint {
  // Dialog base
  /// width include the border 4px
  final _width = 349.0;

  /// height include the border 4px
  final _height = 433.0;

  late Image _bgImage;
  late RRect _rrect;
  late Paint _bgPaint;
  late Paint _borderPaint;

  final _itemImageSize = Vector2(200, 200);
  final _itemImagePosition = Vector2(72, 36);

  // Dynamic by context
  final String imagePath;
  final String dialogTitle;
  final String? dialogDescription;
  final void Function(bool) onPressed;
  final bool noAnimation;
  final bool revertAction;
  late Image _itemImage;

  ItemDialogComponent({
    required this.imagePath,
    required this.dialogTitle,
    this.dialogDescription,
    required this.onPressed,
    this.noAnimation = false,
    this.revertAction = false,
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

    // Convert Float32List to Float64List
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

    _itemImage = game.images.fromCache(imagePath);

    List<Component> children = [];

    /// itemImage
    final itemImage = SpriteComponent(
      sprite: Sprite(_itemImage),
      size: _itemImageSize,
      position: _itemImagePosition,
    );
    children.add(itemImage);
    setPaint(2, itemImage.paint);

    // title
    children.add(TextComponent(
      position: Vector2(_width / 2, 248),
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

    // description
    if (dialogDescription != null) {
      children.add(
        TextBoxComponent(
          position: Vector2(_width / 2, 288),
          anchor: Anchor.center,
          align: Anchor.center,
          boxConfig: TextBoxConfig(
            maxWidth: _width - 48,
          ),
          text: dialogDescription ?? '',
          textRenderer: TextPaint(
            style: TextStyle(
              fontFamily: 'TaiwanPearl',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF917055),
              height: 1.25,
            ),
          ),
        ),
      );
    }

    // close button
    children.add(ButtonComponent(
      position: Vector2(48, 376),
      button: ItemDialogButton(
        text: '關閉',
        color: Color(0xFF887768),
        bgColor: Color(0xFFFFDEC1),
        borderColor: Color(0xFF887768),
        noAnimation: noAnimation,
      ),
      onPressed: () => onPressed(false),
    ));

    // add button
    children.add(ButtonComponent(
      position: Vector2(180, 376),
      button: ItemDialogButton(
        text: revertAction ? '放回去' : '帶上',
        noAnimation: noAnimation,
      ),
      onPressed: () => onPressed(true),
    ));

    addAll(children);

    if (noAnimation) return;

    // 加一點打開動畫～～
    scale = Vector2.all(0.97);

    add(
      ScaleEffect.to(
        Vector2.all(1.06),
        EffectController(duration: 0.1),
        onComplete: () {
          add(
            ScaleEffect.to(
              Vector2.all(1.0),
              EffectController(duration: 0.12),
            ),
          );
        },
      ),
    );

    add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0),
        onComplete: () {
          add(
            OpacityEffect.to(1, EffectController(duration: 0.12)),
          );
        },
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
  }
}

class ItemDialogButton extends PositionComponent with HasPaint {
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

  ItemDialogButton({
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
    if (noAnimation) return;

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
