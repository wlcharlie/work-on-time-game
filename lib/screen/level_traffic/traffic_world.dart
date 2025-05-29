import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/rendering.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/screen/level_traffic/traffic_board_component.dart';
import 'package:work_on_time_game/screen/level_traffic/traffic_dice_component.dart';
import 'package:work_on_time_game/screen/level_traffic/traffic_player_component.dart';
import 'package:work_on_time_game/screen/level_traffic/traffic_status_component.dart';
import 'package:work_on_time_game/wot_game.dart';

class LevelTrafficWorld extends World
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  late final SpriteComponent cutscene;
  late final TrafficBoardComponent board;
  late final TrafficPlayerComponent player;
  late final TrafficDiceComponent dice;
  late final TrafficStatusComponent status;

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

    // 載入所有 traffic 關卡需要的圖片
    await Flame.images.loadAll(images.allTrafficLevelImages());

    // cutscene
    cutscene = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.loading)),
    );
    cutscene.decorator = PaintDecorator.blur(_cutsceneBlur);

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 1;

    // 初始化遊戲元件（確保圖片已載入）
    board = TrafficBoardComponent();
    player = TrafficPlayerComponent();
    dice = TrafficDiceComponent();
    status = TrafficStatusComponent();

    // 加入遊戲元件
    add(cutscene);
    add(board);
    add(player);
    add(dice);
    add(status);
  }

  @override
  void onMount() {
    super.onMount();
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 1;
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
      _cutsceneOff = true;
    }
  }
}
