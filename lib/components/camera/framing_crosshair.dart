import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/extension/position.dart';
import 'package:work_on_time_game/wot_game.dart';

class FramingCrosshair extends PositionComponent
    with HasGameReference<WOTGame>, CollisionCallbacks, HasPaint {
  late final SpriteComponent _framingCorner1;
  late final SpriteComponent _framingCorner2;
  late final SpriteComponent _framingCorner3;
  late final SpriteComponent _framingCorner4;

  late final SpriteComponent _crosshair1;
  late final SpriteComponent _crosshair2;
  late final SpriteComponent _crosshair3;
  late final SpriteComponent _crosshair4;
  late final SpriteComponent _crosshair5;
  late final SpriteComponent _crosshair6;

  FramingCrosshair();

  void _changeFrameOpacity(double opacity) {
    final newAlphaValue = (255 * opacity).toInt();
    _framingCorner1.paint.color =
        _framingCorner1.paint.color.withAlpha(newAlphaValue);
    _framingCorner2.paint.color =
        _framingCorner2.paint.color.withAlpha(newAlphaValue);
    _framingCorner3.paint.color =
        _framingCorner3.paint.color.withAlpha(newAlphaValue);
    _framingCorner4.paint.color =
        _framingCorner4.paint.color.withAlpha(newAlphaValue);

    _crosshair1.paint.color = _crosshair1.paint.color.withAlpha(newAlphaValue);
    _crosshair2.paint.color = _crosshair2.paint.color.withAlpha(newAlphaValue);
    _crosshair3.paint.color = _crosshair3.paint.color.withAlpha(newAlphaValue);
    _crosshair4.paint.color = _crosshair4.paint.color.withAlpha(newAlphaValue);
    _crosshair5.paint.color = _crosshair5.paint.color.withAlpha(newAlphaValue);
    _crosshair6.paint.color = _crosshair6.paint.color.withAlpha(newAlphaValue);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    size = Vector2(662, 532);
    anchor = Anchor.center;

    // position = Vector2(game.size.x / 2, game.size.y / 2);

    // 使用 extension 方法將物件置於畫面正中心
    // centerInGame();

    final framingCornerImage1 = await game.images.load(images.framingCorner1);
    final framingCornerImage2 = await game.images.load(images.framingCorner2);
    final framingCornerImage3 = await game.images.load(images.framingCorner3);
    final framingCornerImage4 = await game.images.load(images.framingCorner4);

    final crosshairImage1 = await game.images.load(images.cameraCrosshair1);
    final crosshairImage2 = await game.images.load(images.cameraCrosshair2);
    final crosshairImage3 = await game.images.load(images.cameraCrosshair3);
    final crosshairImage4 = await game.images.load(images.cameraCrosshair4);
    final crosshairImage5 = await game.images.load(images.cameraCrosshair5);
    final crosshairImage6 = await game.images.load(images.cameraCrosshair6);

    _framingCorner1 = SpriteComponent.fromImage(framingCornerImage1);
    _framingCorner2 = SpriteComponent.fromImage(framingCornerImage2);
    _framingCorner3 = SpriteComponent.fromImage(framingCornerImage3);
    _framingCorner4 = SpriteComponent.fromImage(framingCornerImage4);

    _crosshair1 = SpriteComponent.fromImage(crosshairImage1);
    _crosshair2 = SpriteComponent.fromImage(crosshairImage2);
    _crosshair3 = SpriteComponent.fromImage(crosshairImage3);
    _crosshair4 = SpriteComponent.fromImage(crosshairImage4);
    _crosshair5 = SpriteComponent.fromImage(crosshairImage5);
    _crosshair6 = SpriteComponent.fromImage(crosshairImage6);
  }

  @override
  void onMount() {
    super.onMount();

    debugMode = false;

    _framingCorner1.position = size.topLeftPosition();
    _framingCorner2.position = size.topRightPosition(_framingCorner2.size);
    _framingCorner3.position = size.bottomRightPosition(_framingCorner3.size);
    _framingCorner4.position = size.bottomLeftPosition(_framingCorner4.size);

    _crosshair1.position = size.centerPosition(_crosshair1.size);
    _crosshair2.position = size.centerPosition(_crosshair2.size);
    _crosshair3.position =
        size.centerPosition(_crosshair3.size, offset: Vector2(-73, 0));
    _crosshair4.position =
        size.centerPosition(_crosshair4.size, offset: Vector2(73, 0));
    _crosshair5.position =
        size.centerPosition(_crosshair5.size, offset: Vector2(0, -35));
    _crosshair6.position =
        size.centerPosition(_crosshair6.size, offset: Vector2(0, 35));

    add(_framingCorner1);
    add(_framingCorner2);
    add(_framingCorner3);
    add(_framingCorner4);

    add(_crosshair1);
    add(_crosshair2);
    add(_crosshair3);
    add(_crosshair4);
    add(_crosshair5);
    add(_crosshair6);

    add(RectangleHitbox()..isSolid = true);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    _changeFrameOpacity(0.7);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    _changeFrameOpacity(0.4);
  }
}
