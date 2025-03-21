import 'dart:ui';
import 'package:flutter/painting.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class ItemDialog extends ValueRoute<bool> with HasGameReference<WOTGame> {
  final String imagePath;
  final String dialogTitle;
  final String? dialogDescription;

  late Image image;

  ItemDialog({
    required this.imagePath,
    required this.dialogTitle,
    this.dialogDescription,
  }) : super(value: false);

  @override
  Component build() {
    return ItemDialogComponent(
      imagePath: imagePath,
      dialogTitle: dialogTitle,
      dialogDescription: dialogDescription,
      onPressed: (value) => completeWith(value),
    );
  }
}

class ItemDialogComponent extends PositionComponent
    with HasGameReference<WOTGame> {
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

  late Image _itemImage;

  ItemDialogComponent({
    required this.imagePath,
    required this.dialogTitle,
    this.dialogDescription,
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
  }

  @override
  void onLoad() {
    super.onLoad();
    position = Vector2(
      (game.canvasSize.x - _width) / 2,
      (game.canvasSize.y - _height) / 2,
    );
    _bgImage = game.images.fromCache(images.itemDialogBg);
    _bgPaint = Paint()
      ..shader = ImageShader(
        _bgImage,
        TileMode.repeated,
        TileMode.repeated,
        (Matrix4.identity()).storage,
      );

    _itemImage = game.images.fromCache(imagePath);

    List<Component> children = [];

    /// itemImage
    children.add(SpriteComponent(
      sprite: Sprite(_itemImage),
      size: _itemImageSize,
      position: _itemImagePosition,
    ));

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
      children.add(TextBoxComponent(
        position: Vector2(_width / 2, 288),
        anchor: Anchor.center,
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
          ),
        ),
      ));
    }

    // close button
    children.add(ButtonComponent(
      position: Vector2(90, 361),
      button: ItemDialogButton(
        text: '關閉',
        color: Color(0xFF887768),
        bgColor: Color(0xFFFFDEC1),
        borderColor: Color(0xFF887768),
      ),
      onPressed: () => onPressed(false),
    ));

    // add button
    children.add(ButtonComponent(
      position: Vector2(175, 361),
      button: ItemDialogButton(text: '帶上'),
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

class ItemDialogButton extends PositionComponent {
  final String text;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final TextPainter _textDrawable;
  late final Offset _textOffset;
  late final RRect _rrect;
  late final Paint _borderPaint;
  late final Paint _bgPaint;

  ItemDialogButton({
    required this.text,
    this.color = const Color(0xFFFFFFFF),
    this.bgColor = const Color(0xFF6A4D3A),
    this.borderColor = const Color(0xFF6A4D3A),
  }) : _textDrawable = TextPaint(
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w400,
          ),
        ).toTextPainter(text) {
    size = Vector2(73, 36);
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
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
    _textDrawable.paint(canvas, _textOffset);
  }
}
