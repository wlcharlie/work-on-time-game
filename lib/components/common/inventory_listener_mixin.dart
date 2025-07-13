import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/components/item/item_component.dart';
import 'package:work_on_time_game/models/item.dart';
import 'package:work_on_time_game/providers/inventory.dart';

/// A mixin that provides inventory listening functionality for room components.
///
/// This mixin handles the logic for listening to inventory changes and
/// updating the items in the room accordingly (adding or removing them).
mixin InventoryListenerMixin on Component, RiverpodComponentMixin {
  /// The list of items that belong to this room.
  /// Must be implemented by the class using this mixin.
  List<Item> get roomItems;

  /// Sets up inventory listener that reacts to inventory changes.
  ///
  /// Call this in the onMount method of the component.
  void setupInventoryListener() {
    addToGameWidgetBuild(() {
      ref.listen(inventoryNotifierProvider, (previous, next) {
        print('inventoryListener');
        final previousNameOfItems = previous!.items;
        final nextNameOfItems = next.items;

        // 如果previous有東西代表要加回畫面
        // 如果next有東西代表有東西要從畫面移除

        // check what item is added/removed
        final addItemNames = nextNameOfItems
            .toSet()
            .difference(previousNameOfItems.toSet())
            .toList();

        final removeItemNames = previousNameOfItems
            .toSet()
            .difference(nextNameOfItems.toSet())
            .toList();

        if (addItemNames.isNotEmpty) {
          final addItemName = addItemNames.first;
          // Remove the item from this scene
          final itemComponents = children.query<ItemComponent>();

          final itemComponent = itemComponents.firstWhereOrNull((element) {
            return element.name == addItemName;
          });

          if (itemComponent != null) {
            itemComponent.add(
              OpacityEffect.to(
                0,
                EffectController(duration: 0.5),
                onComplete: () {
                  itemComponent.removeFromParent();
                },
              ),
            );
          }
          return;
        }

        if (removeItemNames.isNotEmpty) {
          final removeItemName = removeItemNames.first;
          final item =
              roomItems.firstWhere((element) => element.name == removeItemName);
          final itemComponent = ItemComponent(
            imagePath: item.imagePath,
            name: item.name,
            position: item.position * 2,
            priority: item.priority,
            action: onItemTapDown,
          );
          itemComponent.makeTransparent();
          itemComponent.add(
            OpacityEffect.to(
              1,
              EffectController(duration: 0.5, startDelay: 0.5),
              onComplete: () {
                RemoveEffect();
              },
            ),
          );
          add(itemComponent);
        }
      });
    });
  }

  /// Callback for when an item is tapped.
  /// Must be implemented by the class using this mixin.
  void onItemTapDown(String name, dynamic event);
}
