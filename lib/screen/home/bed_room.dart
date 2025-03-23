import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/components/background/bed_room.dart';
import 'package:work_on_time_game/components/item/blanket.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/components/item/item_dialog.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/providers/global.dart';
import 'package:work_on_time_game/wot_game.dart';

final List<Map<String, String>> items = [
  {
    'imagePath': images.bag,
    'name': 'bag',
    'position': '1030,677',
    'dialogImagePath': images.bagLg,
    'dialogTitle': '草綠色托特包',
    'dialogDescription': '成為社會新鮮人後，朋友送的禮物，容量很大可以裝很多東西。',
  },
  {
    'imagePath': images.books,
    'name': 'books',
    'position': '589,691',
    'dialogImagePath': images.bookLg,
    'dialogTitle': '書',
    'dialogDescription': '最近常看的書',
  },
  {
    'imagePath': images.hairIron,
    'name': 'hair_iron',
    'position': '7,659',
    'dialogImagePath': images.hairIronLg,
    'dialogTitle': '離子夾',
    'dialogDescription': '要換個造型嗎？',
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
    'dialogImagePath': images.phoneLg,
    'dialogTitle': '手機',
    'dialogDescription': '',
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
class BedRoom extends Component
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  @override
  ComponentKey get key => ComponentKey.named("bed_room");

  @override
  Future<void> onMount() async {
    addToGameWidgetBuild(() {
      ref.listen(globalNotifierProvider, (previous, next) {
        print('globalNotifierProvider: $next');
      });
    });

    super.onMount();

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

  void _onTapDown(String name, TapDownEvent event) async {
    final item = items.firstWhere((element) => element['name'] == name);
    final dialogImagePath = item['dialogImagePath'];
    final dialogTitle = item['dialogTitle'];
    final dialogDescription = item['dialogDescription'];

    if (dialogImagePath != null) {
      final dialog = ItemDialog(
        imagePath: dialogImagePath,
        dialogTitle: dialogTitle ?? '',
        dialogDescription: dialogDescription ?? "",
      );
      game.router.pushAndWait(dialog);
    }
  }
}
