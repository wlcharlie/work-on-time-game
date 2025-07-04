import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/config/icons.dart';
import 'package:work_on_time_game/config/style.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/providers/inventory.dart';
import 'package:work_on_time_game/screen/level_home/home_world.dart';
import 'package:work_on_time_game/wot_game.dart';

/// living_room 客廳
/// bed_room 臥室
/// enter_way 玄關
class HomeLevelInspector extends ConsumerStatefulWidget {
  final WOTGame game;
  const HomeLevelInspector({super.key, required this.game});

  @override
  ConsumerState<HomeLevelInspector> createState() => _HomeLevelInspectorState();
}

class _HomeLevelInspectorState extends ConsumerState<HomeLevelInspector> {
  List<String> scenes = ['living_room', 'bed_room', 'enter_way'];
  String sceneText = '';
  late LevelHomeWorld homeWorld;

  @override
  void initState() {
    super.initState();
    homeWorld =
        widget.game.findByKey(LevelHomeWorld.componentKey) as LevelHomeWorld;
    sceneText = getSceneText();
  }

  String getSceneText() {
    return switch (homeWorld.currentScene) {
      'living_room' => '客廳',
      'bed_room' => '臥室',
      'enter_way' => '玄關',
      _ => '',
    };
  }

  /// index should be +1 or -1
  void onSwitchScene(int delta) {
    final currentIndex = scenes.indexOf(homeWorld.currentScene);
    var newIndex = currentIndex + delta;
    if (newIndex < 0) {
      newIndex = scenes.length - 1;
    } else if (newIndex >= scenes.length) {
      newIndex = 0;
    }

    homeWorld.switchScene(scenes[newIndex]);
    setState(() {
      sceneText = getSceneText();
    });
  }

  void onOpenInventory() {
    widget.game.overlays.add('inventory');

    // debug print
    // final inventory
    final inventory = ref.read(inventoryNotifierProvider);
    print(inventory.items);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 9, 18, 0),
            child: Container(
              height: 47,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: style.defaultBoxDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '關卡',
                    style: typography.tp20m,
                  ),
                  Text(
                    '手機、錢包、鑰匙',
                    style: typography.tp20m,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: IgnorePointer(
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 47,
                  width: 47,
                  decoration: style.defaultBoxDecoration.copyWith(
                    color: Color(0xCCFFFFFF),
                  ),
                  child: Icon(
                    gIcons.menu,
                    color: Color(0xFF887768),
                    size: 28,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 47,
                    decoration: style.defaultBoxDecoration.copyWith(
                      color: Color(0xCCFFFFFF),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => onSwitchScene(-1),
                          child: Icon(
                            gIcons.navLeft,
                            color: Color(0xFF887768),
                          ),
                        ),
                        Text(
                          getSceneText(),
                          style: typography.tp20,
                        ),
                        GestureDetector(
                          onTap: () => onSwitchScene(1),
                          child: Icon(
                            gIcons.navRight,
                            color: Color(0xFF887768),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onOpenInventory,
                  child: Container(
                    height: 47,
                    width: 47,
                    decoration: style.defaultBoxDecoration.copyWith(
                      color: Color(0xCCFFFFFF),
                    ),
                    child: Center(
                      child: Text(
                        '道具',
                        style: typography.tp14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
