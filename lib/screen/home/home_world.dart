import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/screen/home/bed_room.dart';
import 'package:work_on_time_game/screen/home/enter_way.dart';
import 'package:work_on_time_game/screen/home/living_room.dart';
import 'package:work_on_time_game/wot_game.dart';

class HomeWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  final initialScene = 'bed_room';
  final bedRoom = BedRoom();
  final livingRoom = LivingRoom();
  final enterWay = EnterWay();
  String currentScene = ''; // living_room, bed_room, enter_way

  static ComponentKey componentKey = ComponentKey.named("home_world");

  @override
  ComponentKey get key => componentKey;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(images.allImages());

    game.camera.viewfinder.anchor = Anchor.topLeft;
    switchScene(initialScene);
  }

  @override
  void onMount() {
    super.onMount();
    game.overlays.add('homeLevelInspector');
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
}
