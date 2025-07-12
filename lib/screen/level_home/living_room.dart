import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/components/common/inventory_listener_mixin.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/components/item/item_dialog.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/items.dart';
import 'package:work_on_time_game/models/item.dart';
import 'package:work_on_time_game/providers/inventory.dart';
import 'package:work_on_time_game/screen/level_home/home_world.dart';
import 'package:work_on_time_game/screen/level_home/weather_forecast.dart';
import 'package:work_on_time_game/wot_game.dart';

final List<Item> ITEMS =
    items.where((element) => element.sceneName == 'living_room').toList();

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
class LivingRoom extends Component
    with
        HasGameReference<WOTGame>,
        HasWorldReference<LevelHomeWorld>,
        RiverpodComponentMixin,
        InventoryListenerMixin {
  @override
  ComponentKey get key => ComponentKey.named("living_room");

  @override
  List<Item> get roomItems => ITEMS;

  @override
  Future<void> onMount() async {
    setupInventoryListener();
    super.onMount();

    final background = SpriteComponent(
      sprite: Sprite(game.images.fromCache(images.livingRoomBackground)),
    );
    add(background);

    final width = background.sprite?.src.width ?? 0;
    final size = Vector2(width, game.size.y);
    // 提供給camera的可視範圍，減去遊戲視窗（裝置）的寬度
    // 由於預設高度同遊戲視窗（裝置），所以可移動高度設為0
    game.camera.setBounds(Rectangle.fromLTWH(0, 0, size.x - game.size.x, 0));

    final inventory = ref.read(inventoryNotifierProvider);
    final itemNotInInventory = ITEMS
        .where((element) => !inventory.items.contains(element.name))
        .toList();
    for (final item in itemNotInInventory) {
      add(ItemComponent(
        imagePath: item.imagePath,
        name: item.name,
        position: item.position * 2,
        priority: item.priority,
        action: onItemTapDown,
      ));
    }
  }

  @override
  void onItemTapDown(String name, event) async {
    final inventory = ref.read(inventoryNotifierProvider.notifier);

    final item = ITEMS.firstWhere((element) => element.name == name);

    if (item.name == 'tv') {
      // 顯示另外的內容
      game.overlays.remove('homeLevelInspector');
      final weatherForecast = WeatherForecast(onTap: () {
        game.overlays.add('homeLevelInspector');
      });
      world.add(weatherForecast);
      return;
    }

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
