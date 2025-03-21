import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

final List<Map<String, String>> items = [
  {
    'imagePath': images.bill,
    'name': 'bill',
    'position': '1001,594',
    'dialogImagePath': images.billLg,
    'dialogTitle': '信用卡帳單',
    'dialogDescription': '……繳費期限好像過了',
  },
  {
    'imagePath': images.box,
    'name': 'box',
    'position': '67,541',
    'dialogImagePath': images.boxLg,
    'dialogTitle': '金屬吊飾',
    'dialogDescription': '看起來有些老舊的盒子，裡面放著一個寫著英文的金屬 吊飾。',
  },
  {
    'imagePath': images.calendar,
    'name': 'calendar',
    'position': '704,548',
    'dialogImagePath': images.calendarLg,
    'dialogTitle': '月曆',
    'dialogDescription': '這個星期六…有什麼計劃嗎？',
  },
  {
    'imagePath': images.clock,
    'name': 'clock',
    'position': '161,159',
    'dialogImagePath': images.clockLg,
    'dialogTitle': '時鐘',
    'dialogDescription': '現在 9 點。必須在 9點半前出門',
  },
  {
    'imagePath': images.coat,
    'name': 'coat',
    'position': '791,283',
    'priority': "1",
    'dialogImagePath': images.coatLg,
    'dialogTitle': '日系長大衣',
    'dialogDescription': '穿了好幾年所以有些舊舊的 ，但穿起來還是非常舒服。',
  },
  {
    'imagePath': images.picFrame,
    'name': 'picFrame',
    'position': '797,542',
    'dialogImagePath': images.phoneLg,
    'dialogTitle': '小時候的照片',
    'dialogDescription': '某一次全家旅行得時候，爸爸用相機拍的。',
  },
  {
    'imagePath': images.scarf,
    'name': 'scarf',
    'position': '964,327',
    'dialogImagePath': images.scarfLg,
    'dialogTitle': '大地色圍巾',
    'dialogDescription': '羊毛織的圍巾，適合天氣特 別冷的時候戴上它。',
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

/// 客廳
/// Loop items:
/// bill
/// box
/// calendar
/// clock
/// coat
/// pic_frame
/// scarf
/// tv
/// vase
///
/// Individual items:
/// bg
///
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

  void _onTapDown(String name, TapDownEvent event) async {}
}
