import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
// import 'package:flutter/material.dart' as M hide Route;
import 'package:work_on_time_game/components/background/bed_room.dart';
import 'package:work_on_time_game/components/item/blanket.dart';
import 'package:work_on_time_game/components/item/paper_ball.dart';
import 'package:work_on_time_game/wot_game.dart';

// 這一頁的做法是用將每個物件獨立建一個 component
// 好處可以在裡面寫邏輯 或是 利用 callback 處理一些互動事件
// 壞處就是有一個弄一個
class BedRoom extends Component with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("bed_room");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final background = BedRoomBackground();
    add(background);
    await background.onLoad();

    final width = background.sprite?.src.width ?? 0;
    final size = Vector2(width, game.size.y);
    // // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
    // // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
    game.camera.setBounds(Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0));

    add(Blanket(
      position: Vector2(438, 483),
      onTapDownCallback: (event) {
        print('I am Blanket!!');
      },
    ));
    add(PaperBall(
      position: Vector2(264, 677),
      onTapDownCallback: (event) async {
        // ValueRoute 已開 issue 希望作者可以趕快修ＸＤ
        print('PaperBall!!');
        final result = await game.router.pushAndWait(YesNoDialog('Dialog'));
        print('result: ${result.toString()}');
      },
    ));
  }
}

class YesNoDialog extends ValueRoute<bool> {
  YesNoDialog(this.text) : super(value: false);
  final String text;

  @override
  Component build() {
    return PositionComponent(
      size: Vector2(300, 100),
      position: Vector2(264, 677),
      children: [
        RectangleComponent(
          size: Vector2(300, 100),
          position: Vector2(0, 0),
          paint: Paint()..color = Color(0xFFFF0000),
        ),
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
