import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/screen/home/bed_room.dart';
import 'package:work_on_time_game/screen/home/living_room.dart';
import 'package:work_on_time_game/wot_game.dart';

class HomeWorld extends World with HasGameReference<WOTGame> {
  final initialScene = 'bed_room';
  final bedRoom = BedRoom();
  final livingRoom = LivingRoom();
  String currentScene = ''; // living_room, bed_room

  static ComponentKey componentKey = ComponentKey.named("home_world");

  @override
  ComponentKey get key => componentKey;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll([
      images.livingRoomBackground,
      images.bill,
      images.box,
      images.calendar,
      images.clock,
      images.coat,
      images.picFrame,
      images.scarf,
      images.tv,
      images.vase,
      images.bedRoomBackground,
      images.bag,
      images.blanketDo,
      images.blanketUndo,
      images.books,
      images.hairIron,
      images.mirror,
      images.painting,
      images.paperBall,
      images.phone,
    ]);

    game.camera.viewfinder.anchor = Anchor.topLeft;
    switchScene(initialScene);

    game.overlays.add('homeLevelInspector');
  }

  void switchScene(String scene) async {
    // currentScene = scene;
    if (scene == currentScene) return;

    if (scene == 'living_room') {
      currentScene = 'living_room';
      if (game.findByKey(bedRoom.key) != null) {
        remove(bedRoom);
      }
      add(livingRoom);
    } else if (scene == 'bed_room') {
      currentScene = 'bed_room';
      if (game.findByKey(livingRoom.key) != null) {
        remove(livingRoom);
      }
      add(bedRoom);
    }

    game.camera.moveTo(Vector2(0, 0));
  }
}
