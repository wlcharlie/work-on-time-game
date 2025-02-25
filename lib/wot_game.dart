import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
// import 'package:flutter/material.dart' as Material hide Route;
import 'package:work_on_time_game/screen/home/home_world.dart';

class WOTGame extends FlameGame with PanDetector {
  late final RouterComponent router;

  @override
  bool debugMode = true;

  @override
  void onLoad() {
    router = RouterComponent(
      initialRoute: 'home',
      routes: {
        'home': WorldRoute(HomeWorld.new),
        // 'cd': OverlayRoute((context, game) {
        //   return Material.Center(
        //     child: Material.Container(
        //       width: 300,
        //       height: 100,
        //       color: Material.Colors.red,
        //       child: Material.Row(
        //         children: [
        //           Material.Text('我是對話框'),
        //           Material.FilledButton(
        //             onPressed: () {
        //               router.pop();
        //             },
        //             child: Material.Text('關閉'),
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }),
      },
    );
    add(router);

    // 固定解析度(?) 看起來不用出兩倍圖了Ａ＿Ａ
    camera = CameraComponent.withFixedResolution(
      width: 393,
      height: 852,
    );
  }

  // - PanDetector
  // 看起來能只透過FlameGame extends PanDetector 來實現嗎
  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    final currentRoute = router.currentRoute;
    if (currentRoute.name == 'home') {
      camera.moveBy(Vector2(-info.delta.global.x, 0));
    }
  }
}
