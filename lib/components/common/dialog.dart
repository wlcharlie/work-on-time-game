import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class Dialog extends PositionComponent with HasGameReference<WOTGame> {
  late Image _bgImage;
  late Paint _bgPaint;
  late Paint _borderPaint;
  late RRect _rrect;

  Dialog({
    required Vector2 size,
    required Vector2 position,
  }) {
    this.size = size;
    this.position = position;

    _rrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      Radius.circular(6),
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await game.images.load(images.dialogBg);
    _bgImage = game.images.fromCache(images.dialogBg);

    _borderPaint = Paint()
      ..color = Color(0xFFA9886C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round;

    // Convert Float32List to Float64List
    final matrix4Storage = Matrix4.identity().storage;
    final Float64List float64Storage = Float64List.fromList(matrix4Storage);

    _bgPaint = Paint()
      ..shader = ImageShader(
        _bgImage,
        TileMode.repeated,
        TileMode.repeated,
        float64Storage,
      )
      ..color = Color.fromRGBO(255, 255, 255, 0.85);
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
  }
}
