import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';

const double dialogWidth = 660.0;
const double dialogHeight = 440.0;

class Dialog extends PositionComponent with HasGameReference<WOTGame> {
  late Image _bgImage;
  late Paint _bgPaint;
  late Paint _borderPaint;
  late RRect _rrect;
  late List<Component> content;

  Dialog({
    Vector2? size,
    Vector2? position,
    Vector2? scale,
    required this.content,
  }) {
    this.size = size ?? Vector2(dialogWidth, dialogHeight);
    this.position = position ?? Vector2(64, 1060);
    this.scale = scale ?? Vector2.all(1);

    _rrect = RRect.fromLTRBR(
      0,
      0,
      this.size.x,
      this.size.y,
      Radius.circular(6),
    );
  }

  Dialog.title({
    Vector2? size,
    Vector2? position,
    required String title,
    Vector2? scale,
  }) {
    this.size = size ?? Vector2(dialogWidth, dialogHeight);
    this.position = position ?? Vector2(64, 1060);
    this.scale = scale ?? Vector2.all(1);

    _rrect = RRect.fromLTRBR(
      0,
      0,
      this.size.x,
      this.size.y,
      Radius.circular(40),
    );

    content = [
      TextComponent(
        text: title,
        textRenderer: TextPaint(
          style: typography.tp48.withColor(AppColors.brown500),
        ),
        position: Vector2(this.size.x / 2, this.size.y / 2),
        anchor: Anchor.center,
      ),
    ];
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(dialogWidth, dialogHeight);

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

    for (var child in content) {
      add(child);
    }
  }

  @override
  void onMount() {
    super.onMount();
    position = Vector2((game.size.x - dialogWidth) / 2, position.y);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
  }
}
