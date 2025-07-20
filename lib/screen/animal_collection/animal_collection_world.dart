import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/wot_game.dart';

class AnimalCollectionWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  static final animalCollectionKey = ComponentKey.named('animal_collection');

  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    
    game.camera.viewport.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2.zero();
    game.camera.viewfinder.anchor = Anchor.topLeft;

    game.overlays.add('animalCollection');
  }

  @override
  void onRemove() {
    super.onRemove();
    game.overlays.remove('animalCollection');
  }
}