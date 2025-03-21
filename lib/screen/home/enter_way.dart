import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:work_on_time_game/components/item/door.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

final List<Map<String, String>> items = [
  {
    'imagePath': images.boots,
    'name': 'boots',
    'position': '279,461',
    'dialogImagePath': images.bootLg,
    'dialogTitle': '黑色長筒靴',
    'dialogDescription': '還蠻耐走的！很適合搭配可愛的 衣服穿去逛街。',
  },
  {
    'imagePath': images.idCard,
    'name': 'id_card',
    'position': '48,373',
    'dialogImagePath': images.idCardLg,
    'dialogTitle': '公司識別證',
    'dialogDescription': '進公司大門和打卡的時候會 用到，千萬不能忘記帶了！',
  },
  {
    'imagePath': images.maryJanes,
    'name': 'mary_janes',
    'position': '318,475',
    'dialogImagePath': images.maryJanesLg,
    'dialogTitle': '棕色瑪莉珍鞋',
    'dialogDescription': '唯一的一雙比較正式的鞋子。',
  },
  {
    'imagePath': images.shoppingList,
    'name': 'shopping_list',
    'position': '3,379',
    'dialogImagePath': images.shoppingListLg,
    'dialogTitle': '超市購物清單',
    'dialogDescription': '回家的時候再順便 去買個菜吧！',
  },
  {
    'imagePath': images.sneakers,
    'name': 'sneakers',
    'position': '280,537',
    'dialogImagePath': images.sneakerLg,
    'dialogTitle': '白色帆布鞋',
    'dialogDescription': '偶爾運動會穿出門…不過已經好久沒有出門運動了。',
  },
  {
    'imagePath': images.umbrella,
    'name': 'umbrella',
    'position': '263,408',
    'dialogImagePath': images.umbrellaLg,
    'dialogTitle': '折傘',
    'dialogDescription': '今天會下雨嗎？',
  },
];

class EnterWay extends Component with HasGameReference<WOTGame> {
  @override
  ComponentKey get key => ComponentKey.named("enter_way");

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.enterWay)),
    );
    add(background);

    final width = background.sprite?.src.width ?? 0;
    final size = Vector2(width, game.size.y);
    game.camera.setBounds(Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0));

    add(Door(
      position: Vector2(86, 253),
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
