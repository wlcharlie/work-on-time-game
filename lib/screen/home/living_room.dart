import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

final List<Map<String, String>> items = [
  {
    'imagePath': images.bill,
    'name': 'bill',
    'position': '1001,594',
  },
  {
    'imagePath': images.box,
    'name': 'box',
    'position': '67,541',
  },
  {
    'imagePath': images.calendar,
    'name': 'calendar',
    'position': '704,548',
  },
  {
    'imagePath': images.clock,
    'name': 'clock',
    'position': '161,159',
  },
  {
    'imagePath': images.coat,
    'name': 'coat',
    'position': '791,283',
    'priority': "1",
  },
  {
    'imagePath': images.picFrame,
    'name': 'picFrame',
    'position': '797,542',
  },
  {
    'imagePath': images.scarf,
    'name': 'scarf',
    'position': '964,327',
  },
  {
    'imagePath': images.tv,
    'name': 'tv',
    'position': '356,416',
  },
  {
    'imagePath': images.vase,
    'name': 'vase',
    'position': '0,416',
  },
];

// 這一頁的做法是用 ItemComponent 來處理每個物件的互動事件
// 可以將每個物件的資訊放在 List<Map<String, String>> 中
// 可以省去建立每個元件的功 但無法處理特有邏輯

class LivingRoom extends Component with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("living_room");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.livingRoomBackground)),
    );
    add(background);

    final width = background.sprite?.src.width ?? 0;
    final size = Vector2(width, game.size.y);
    // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
    // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
    game.camera.setBounds(Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0));

    // add(ItemComponent(
    //   imagePath: images.vase,
    //   name: 'vase',
    //   position: Vector2(0, 416),
    //   action: _onTapDown,
    // ));
    for (final item in items) {
      add(ItemComponent(
        imagePath: item['imagePath'] ?? '',
        name: item['name'] ?? '',
        position: Vector2(
          double.parse(item['position']?.split(',')[0] ?? '0'),
          double.parse(item['position']?.split(',')[1] ?? '0'),
        ),
        priority: int.parse(item['priority'] ?? '0'),
        action: _onTapDown,
      ));
    }
  }

  void _onTapDown(String name, TapDownEvent event) {
    print('!!you tap $name');
  }
}
