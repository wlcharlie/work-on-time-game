import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

class TrafficWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  late final SpriteComponent cutscene;

  final initialScene = 'traffic_screen';
  String currentScene = '';

  double _cutsceneBlur = 10;
  double _cutsceneSpeed = 3;
  bool _cutsceneOff = false;

  static ComponentKey componentKey = ComponentKey.named("traffic_world");

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
    await Flame.images.loadAll(images.allTrafficLevelImages());

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 1;
  }

  @override
  void onMount() async {
    super.onMount();
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 1;
    add(cutscene);
  }
}
