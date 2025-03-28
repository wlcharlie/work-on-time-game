import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work_on_time_game/models/inventory.dart';

part 'inventory.g.dart';

@Riverpod(keepAlive: true)
class InventoryNotifier extends _$InventoryNotifier {
  @override
  Inventory build() => Inventory();

  void addItem(String item) {
    state = state.addItem(item);
  }

  void removeItem(String item) {
    state = state.removeItem(item);
  }

  bool hasItem(String item) {
    return state.hasItem(item);
  }
}
