import 'package:flame/components.dart';
import 'package:work_on_time_game/components/background/endless_background.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class LeaveResult extends PositionComponent with HasGameReference<WOTGame> {
  late EndlessBackground _bg;
  @override
  void onLoad() {
    super.onLoad();
    _bg = EndlessBackground(
      image: game.images.fromCache(images.greenDotBackground),
    );
    add(_bg);
  }
}
