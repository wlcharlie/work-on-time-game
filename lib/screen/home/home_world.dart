import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/screen/common/dialog.dart';
import 'package:work_on_time_game/screen/home/bed_room.dart';
import 'package:work_on_time_game/screen/home/enter_way.dart';
import 'package:work_on_time_game/screen/home/living_room.dart';
import 'package:work_on_time_game/wot_game.dart';

class HomeWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  late final SpriteComponent cutscene;

  final initialScene = 'bed_room';
  final bedRoom = BedRoom();
  final livingRoom = LivingRoom();
  final enterWay = EnterWay();
  String currentScene = ''; // living_room, bed_room, enter_way

  double _cutsceneBlur = 10;
  double _cutsceneSpeed = 3;
  bool _cutsceneOff = false;

  static ComponentKey componentKey = ComponentKey.named("home_world");

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
  }

  @override
  void onMount() async {
    super.onMount();
    switchScene(initialScene);
    add(cutscene);
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
        add(livingRoom);
        break;
      case 'bed_room':
        add(bedRoom);
        break;
      case 'enter_way':
        add(enterWay);
        break;
    }
    currentScene = scene;

    game.camera.moveTo(Vector2(0, 0));
  }

  Future<bool> leaveWorld() async {
    game.overlays.remove('homeLevelInspector');
    final result = await game.router.pushAndWait(CommonDialog(
      dialogTitle: '確定要離開嗎？',
    ));

    if (!result) {
      game.overlays.add('homeLevelInspector');
    }

    return result;
  }
}
