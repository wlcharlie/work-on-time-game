import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/providers/inventory.dart';
import 'package:work_on_time_game/screen/common/dialog.dart';
import 'package:work_on_time_game/screen/level_home/bed_room.dart';
import 'package:work_on_time_game/screen/level_home/enter_way.dart';
import 'package:work_on_time_game/screen/level_home/leave_result.dart';
import 'package:work_on_time_game/screen/level_home/living_room.dart';
import 'package:work_on_time_game/wot_game.dart';

class LevelHomeWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  late final SpriteComponent cutscene;

  final initialScene = 'bed_room';
  String currentScene = ''; // living_room, bed_room, enter_way

  double _cutsceneBlur = 10;
  double _cutsceneSpeed = 3;
  bool _cutsceneOff = false;

  static ComponentKey componentKey = ComponentKey.named("level_home_world");

  @override
  ComponentKey get key => componentKey;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // cutscene
    cutscene = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.loading)),
    );
    cutscene.decorator = PaintDecorator.blur(_cutsceneBlur);
    await Flame.images.loadAll(images.allHomeLevelImages());

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 2;
  }

  @override
  void onMount() async {
    super.onMount();
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 1;
    switchScene(initialScene);
    add(cutscene);
  }

  @override
  void onRemove() {
    game.overlays.remove('homeLevelInspector');
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_cutsceneOff) return;

    if (_cutsceneBlur > 0) {
      _cutsceneBlur -= dt * _cutsceneSpeed;
      cutscene.decorator = PaintDecorator.blur(_cutsceneBlur);
    }

    if (_cutsceneBlur <= 0) {
      cutscene.removeFromParent();
      game.overlays.add('homeLevelInspector');
      _cutsceneOff = true;
    }
  }

  void switchScene(String scene) async {
    if (scene == currentScene) return;

    final currentSceneComponent =
        game.findByKey(ComponentKey.named(currentScene));
    if (currentSceneComponent != null) {
      remove(currentSceneComponent);
    }

    switch (scene) {
      case 'living_room':
        add(LivingRoom());
        break;
      case 'bed_room':
        add(BedRoom());
        break;
      case 'enter_way':
        add(EnterWay());
        break;
    }
    currentScene = scene;

    game.camera.moveTo(Vector2(0, 0));
  }

  /// 將相機從左上改為中心
  Function preZoomCameraAdjustment() {
    // 保存原始錨點和位置
    final originalAnchor = game.camera.viewfinder.anchor;
    final originalPosition = game.camera.viewfinder.position.clone();

    // 將錨點設為中心
    game.camera.viewfinder.anchor = Anchor.center;
    game.camera.setBounds(null);
    // 重新填滿
    final _tempVector = Vector2(game.size.x / 2, game.size.y / 2);
    // 將相機位置設定為目標位置
    game.camera.moveTo(_tempVector, speed: double.infinity);

    //recover function
    return () {
      game.camera.viewfinder.anchor = originalAnchor;
      game.camera.viewfinder.position = originalPosition;
    };
  }

  Future<bool> leaveWorld() async {
    game.overlays.remove('homeLevelInspector');
    final result = await game.router.pushAndWait(CommonDialog(
      dialogTitle: '確定要離開嗎？',
    ));

    if (!result) {
      game.overlays.add('homeLevelInspector');
      return result;
    }

    final foreground = HomeForeground();
    foreground.anchor = Anchor.topLeft;
    foreground.position = Vector2(0, 0);
    foreground.size = Vector2(game.size.x, game.size.y);
    foreground.paint = Paint()
      ..color = Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    foreground.makeTransparent();
    foreground.add(
      OpacityEffect.to(
        1,
        EffectController(duration: 1.5),
      ),
    );

    // 只有在enter_way場景中才縮放門
    if (currentScene == 'enter_way') {
      // 直接通過ComponentKey查詢門組件
      final doorComponent = game.findByKey(ComponentKey.named('item_door'));

      if (doorComponent != null && doorComponent is SpriteComponent) {
        // 計算門的中心位置

        // 向門的中心位置縮放
        final recover = preZoomCameraAdjustment();
        game.camera.viewfinder.add(
          SequenceEffect(
            [
              ScaleEffect.to(
                Vector2.all(1.5),
                EffectController(duration: 2),
              ),
              ScaleEffect.to(
                Vector2.all(1),
                EffectController(duration: 0.05),
                onComplete: () {
                  final currentSceneComponent =
                      game.findByKey(ComponentKey.named(currentScene));
                  if (currentSceneComponent != null) {
                    remove(currentSceneComponent);
                  }

                  recover();

                  add(LeaveResult());
                },
              ),
            ],
          ),
        );
      }
    }

    add(foreground);

    return result;
  }
}

class HomeForeground extends PositionComponent
    with HasPaint, HasGameReference<WOTGame> {
  HomeForeground();

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
  }
}
