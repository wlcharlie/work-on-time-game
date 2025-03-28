/// 背包的功能
/// 通常只有三格
/// 關鍵道具會增到九格
class Inventory {
  // 先存 string, 不製作貧血模型
  final List<String> _items = [];
  // 背包容量
  int _capacity = 3;
  get items => List.unmodifiable(_items);
  // 背包容量
  get capacity => _capacity;
  // 背包目前容量
  get currentCount => _items.length;

  Inventory();

  Inventory addItem(String item) {
    if (_items.contains(item)) return this;
    if (_items.length >= _capacity) return this;

    if (item == 'bag') {
      _capacity = 9;
    }
    _items.add(item);
    return this;
  }

  Inventory removeItem(String item) {
    _items.remove(item);
    return this;
  }

  bool hasItem(String item) {
    return _items.contains(item);
  }
}
