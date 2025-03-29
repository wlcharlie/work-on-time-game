/// 背包的功能
/// 通常只有三格
/// 關鍵道具會增到九格
class Inventory {
  // 先存 string, 不製作貧血模型
  List<String> _items = [];
  // 背包容量
  int _capacity = 3;
  List<String> get items => List.unmodifiable(_items);

  // 背包容量
  int get capacity => _capacity;
  // 背包目前容量
  int get currentCount => _items.length;

  Inventory();

  Inventory.copy(Inventory other) {
    _capacity = other._capacity;
    _items = List.from(other._items);
  }

  Inventory addItem(String item) {
    if (_items.contains(item)) return this;
    if (_items.length >= _capacity) return this;

    final newInventory = Inventory.copy(this);

    if (item == 'bag') {
      newInventory._capacity = 9;
    }
    newInventory._items.add(item);
    return newInventory;
  }

  Inventory removeItem(String item) {
    final newInventory = Inventory.copy(this);
    newInventory._items.remove(item);
    return newInventory;
  }

  bool hasItem(String item) {
    return _items.contains(item);
  }
}
