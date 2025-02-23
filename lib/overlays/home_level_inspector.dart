import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/icons.dart';
import 'package:work_on_time_game/config/style.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';

class HomeLevelInspector extends StatefulWidget {
  final WOTGame game;
  const HomeLevelInspector({super.key, required this.game});

  @override
  State<HomeLevelInspector> createState() => _HomeLevelInspectorState();
}

class _HomeLevelInspectorState extends State<HomeLevelInspector> {
  String sceneText = '';

  @override
  void initState() {
    super.initState();
    sceneText = getSceneText();
  }

  String getSceneText() {
    return widget.game.homeWorld.currentScene == 'living_room' ? '客廳' : '臥室';
  }

  void onSwitchScene() {
    final scene = widget.game.homeWorld.currentScene == 'living_room'
        ? 'bed_room'
        : 'living_room';

    widget.game.homeWorld.switchScene(scene);
    setState(() {
      sceneText = getSceneText();
    });
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
              ignoring: true,
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
                  child: GestureDetector(
                    onTap: onSwitchScene,
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
                          Icon(
                            gIcons.navLeft,
                            color: Color(0xFF887768),
                          ),
                          Text(
                            getSceneText(),
                            style: typography.tp20,
                          ),
                          Icon(
                            gIcons.navRight,
                            color: Color(0xFF887768),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
