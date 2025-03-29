import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/components/item/door.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/components/item/item_dialog.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/items.dart';
import 'package:work_on_time_game/models/item.dart';
import 'package:work_on_time_game/providers/inventory.dart';
import 'package:work_on_time_game/wot_game.dart';

final List<Item> ITEMS =
    items.where((element) => element.sceneName == 'enter_way').toList();

class EnterWay extends Component
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  @override
  ComponentKey get key => ComponentKey.named("enter_way");

  @override
  Future<void> onMount() async {
    super.onMount();

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

    for (final item in ITEMS) {
      add(ItemComponent(
        imagePath: item.imagePath,
        name: item.name,
        position: item.position,
        priority: item.priority,
        action: _onTapDown,
      ));
    }
  }

  void _onTapDown(String name, TapDownEvent event) async {
    final inventory = ref.read(inventoryNotifierProvider.notifier);

    final item = ITEMS.firstWhere((element) => element.name == name);
    final dialogImagePath = item.imagePathLg;
    final dialogTitle = item.title;
    final dialogDescription = item.description;

    if (dialogImagePath != null) {
      final dialog = ItemDialog(
        imagePath: dialogImagePath,
        dialogTitle: dialogTitle ?? '',
        dialogDescription: dialogDescription ?? "",
      );
      final result = await game.router.pushAndWait(dialog);
      if (result == false) return;
      inventory.addItem(name);
    }
  }
}
