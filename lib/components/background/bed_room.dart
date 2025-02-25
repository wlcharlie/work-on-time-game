import 'package:flame/components.dart';

import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class BedRoomBackground extends SpriteComponent with HasGameReference<WOTGame> {
  static final String imagePath = images.bedRoomBackground;
  static final String name = 'background_bed_room';

  BedRoomBackground({
    Vector2? position,
    int priority = 0,
  }) {
    this.position = position ?? Vector2.zero();
    this.priority = priority;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (!game.images.containsKey(BedRoomBackground.imagePath)) {
      await game.images.load(BedRoomBackground.imagePath);
    }
    final image = game.images.fromCache(BedRoomBackground.imagePath);
    sprite = Sprite(image);
  }
}
