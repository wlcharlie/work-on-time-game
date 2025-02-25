import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
// import 'package:flutter/material.dart' as M hide Route;
import 'package:work_on_time_game/components/background/bed_room.dart';
import 'package:work_on_time_game/components/item/mirror.dart';
import 'package:work_on_time_game/components/item/paper_ball.dart';
import 'package:work_on_time_game/wot_game.dart';

class BedRoom extends Component with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("bed_room");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // final background = BedRoomBackground();
    // add(background);
    // await background.onLoad();

    // final width = background.sprite?.src.width ?? 0;
    // size = Vector2(width, game.size.y);
    // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
    // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
    // game.camera.setBounds(Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0));
    // print('background priority: ${background.priority}');

    add(Mirror(
      position: Vector2(29, 271),
      onTapDownCallback: (event) {
        print('我是鏡子！');
      },
    ));
    add(PaperBall(
      position: Vector2(264, 677),
      priority: 1000,
      onTapDownCallback: (event) async {
        print('我是紙球！');
        // game.router.pushOverlay('cd');
        await showYesNoDialog();
      },
    ));
  }

  Future<void> showYesNoDialog() async {
    print("!!");
    await game.router.pushAndWait(YesNoDialog('我是對話框'));
  }
}

// 這好像沒用不知道為啥...一直顯示在後面...
class YesNoDialog extends ValueRoute<bool> with HasGameReference<WOTGame> {
  YesNoDialog(this.text) : super(value: false);
  final String text;

  @override
  Component build() {
    // size = Vector2(300, 100);
    // position = Vector2(game.size.x / 2, game.size.y / 2);
    // anchor = Anchor.center;
    priority = 1000;
    return PositionComponent(
      size: Vector2(300, 100),
      position: Vector2(game.size.x / 2, game.size.y / 2),
      anchor: Anchor.center,
      priority: 100000,
      children: [
        RectangleComponent(),
        TextComponent(text: text),
        // Button(
        //   text: 'Yes',
        //   action: () => completeWith(true),
        // ),
        // Button(
        //   text: 'No',
        //   action: () => completeWith(false),
        // ),
      ],
    );
  }
}

// class Dialog extends M.StatelessWidget {
//   final WOTGame game;
//   Dialog({required this.game});
//   @override
//   M.Widget build(M.BuildContext context) {
//     return M.Center(
//       child: M.Container(
//         width: 300,
//         height: 100,
//         color: M.Colors.red,
//         child: M.Row(
//           children: [
//             M.Text('我是對話框'),
//             M.FilledButton(
//               onPressed: () {
//                 game.router.pop();
//               },
//               child: M.Text('關閉'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
