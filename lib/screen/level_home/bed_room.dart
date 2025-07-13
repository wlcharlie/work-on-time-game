import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/components/background/bed_room.dart';
import 'package:work_on_time_game/components/common/inventory_listener_mixin.dart';
import 'package:work_on_time_game/components/item/blanket.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/components/item/item_dialog.dart';
import 'package:work_on_time_game/components/item/paper_ball.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/items.dart';
import 'package:work_on_time_game/config/priority.dart';
import 'package:work_on_time_game/models/item.dart';
import 'package:work_on_time_game/providers/inventory.dart';
import 'package:work_on_time_game/screen/level_home/mirror_view.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'package:work_on_time_game/extension/position.dart';

final List<Item> ITEMS =
    items.where((element) => element.sceneName == 'bed_room').toList();

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
    with
        HasGameReference<WOTGame>,
        RiverpodComponentMixin,
        InventoryListenerMixin {
  @override
  ComponentKey get key => ComponentKey.named("bed_room");

  @override
  List<Item> get roomItems => ITEMS;

  @override
  Future<void> onMount() async {
    setupInventoryListener();
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
      position: Vector2(438, 483).doubled,
      onTapDownCallback: (event) async {
        print('I am Blanket!!');
      },
    ));
    add(PaperBall(
      position: Vector2(264, 677).doubled,
    ));

    final inventory = ref.read(inventoryNotifierProvider);
    final itemNotInInventory = ITEMS
        .where((element) => !inventory.items.contains(element.name))
        .toList();
    for (final item in itemNotInInventory) {
      add(ItemComponent(
        imagePath: item.imagePath,
        name: item.name,
        position: item.position.doubled,
        priority: item.priority,
        action: onItemTapDown,
      ));
    }
  }

  @override
  void onItemTapDown(String name, event) async {
    if (name == 'mirror') {
      // remove the overlay
      game.overlays.remove('homeLevelInspector');
      late final MirrorView mirrorView;
      mirrorView = MirrorView(onTap: () {
        game.overlays.add('homeLevelInspector');
        mirrorView.removeFromParent();
      });
      mirrorView.priority = Priority.dialog;
      add(mirrorView);
      return;
    }

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
