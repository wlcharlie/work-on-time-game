import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:work_on_time_game/components/background/bed_room.dart';
import 'package:work_on_time_game/components/item/blanket.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

final List<Map<String, String>> items = [
  {
    'imagePath': images.bag,
    'name': 'bag',
    'position': '1030,677',
  },
  {
    'imagePath': images.books,
    'name': 'books',
    'position': '589,691',
  },
  {
    'imagePath': images.hairIron,
    'name': 'hair_iron',
    'position': '7,659',
  },
  {
    'imagePath': images.mirror,
    'name': 'mirror',
    'position': '29,271',
  },
  {
    'imagePath': images.painting,
    'name': 'painting',
    'position': '589,150',
  },
  {
    'imagePath': images.paperBall,
    'name': 'paper_ball',
    'position': '264,677',
  },
  {
    'imagePath': images.phone,
    'name': 'phone',
    'position': '703,636',
  },
];

/// 臥室
/// Loop items:
/// bag
/// books
/// hair_iron
/// mirror
/// painting
/// paper_ball
/// phone
///
/// Individual items:
/// bg
/// blanket
///
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
      onTapDownCallback: (event) async {
        print('I am Blanket!!');
        final result = await game.router.pushAndWait(YesNoDialog('Dialog'));
        print('result: ${result.toString()}');
      },
    ));

    for (final item in items) {
      add(ItemComponent(
        imagePath: item['imagePath'] ?? '',
        name: item['name'] ?? '',
        position: Vector2(
          double.parse(item['position']?.split(',')[0] ?? '0'),
          double.parse(item['position']?.split(',')[1] ?? '0'),
        ),
        action: _onTapDown,
      ));
    }
  }

  void _onTapDown(String name, TapDownEvent event) {
    print('!!you tap $name');
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
