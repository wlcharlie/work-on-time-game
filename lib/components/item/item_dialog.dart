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

  // @override
  // Component build() {
  //   return PositionComponent(
  //     size: Vector2(0, 0),
  //     position: Vector2(
  //       (game.canvasSize.x - 349) / 2,
  //       (game.canvasSize.y - 433) / 2,
  //     ),
  //     children: [
  //       RectangleComponent(
  //         size: Vector2(349, 433),
  //         paint: Paint()
  //           ..shader = ImageShader(
  //             image,
  //             TileMode.repeated,
  //             TileMode.repeated,
  //             (Matrix4.identity()..scale(25.0, 25.0)).storage,
  //           ),
  //       ),
  //       RectangleComponent(
  //         size: Vector2(349, 433),
  //         paint: Paint()
  //           ..color = Color(0xFFA9886C)
  //           ..style = PaintingStyle.stroke
  //           ..strokeWidth = 4
  //           ..strokeJoin = StrokeJoin.round,
  //       ),
  //       ButtonComponent(
  //         button: TextComponent(text: 'TRUE'),
  //         onPressed: () => completeWith(true),
  //       ),
  //       ButtonComponent(
  //         button: TextComponent(text: 'FALSE'),
  //         onPressed: () => completeWith(false),
  //       ),
  //     ],
  //   );
  // }
}

class ItemDialogComponent extends PositionComponent
    with HasGameReference<WOTGame> {
  final String imagePath;
  final String dialogTitle;
  final String? dialogDescription;
  final void Function(bool) onPressed;

  late Image image;
  late Image itemImage;

  ItemDialogComponent({
    required this.imagePath,
    required this.dialogTitle,
    this.dialogDescription,
    required this.onPressed,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    if (!game.images.containsKey(images.itemDialogBg)) {
      await game.images.load(images.itemDialogBg);
    }

    image = game.images.fromCache(images.itemDialogBg);

    if (!game.images.containsKey(imagePath)) {
      await game.images.load(imagePath);
    }

    itemImage = game.images.fromCache(imagePath);

    List<Component> children = [];

    children.add(RectangleComponent(
      size: Vector2(349, 433),
      paint: Paint()
        ..shader = ImageShader(
          image,
          TileMode.repeated,
          TileMode.repeated,
          (Matrix4.identity()).storage,
        ),
    ));

    children.add(RectangleComponent(
      size: Vector2(349, 433),
      paint: Paint()
        ..color = Color(0xFFA9886C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.round,
    ));

    children.add(SpriteComponent(
      sprite: Sprite(itemImage),
      size: Vector2(200, 200),
      position: Vector2(72, 36),
    ));

    children.add(ButtonComponent(
      position: Vector2(90, 361),
      button: TextComponent(
        text: 'TRUE',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFF000000),
          ),
        ),
      ),
      onPressed: () => onPressed(true),
    ));

    children.add(ButtonComponent(
      position: Vector2(175, 361),
      button: TextComponent(
        text: 'TRUE',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFF000000),
          ),
        ),
      ),
      onPressed: () => onPressed(true),
    ));

    addAll(children);
    size = Vector2(0, 0);
    position = Vector2(
      (game.canvasSize.x - 349) / 2,
      (game.canvasSize.y - 433) / 2,
    );
  }
}
