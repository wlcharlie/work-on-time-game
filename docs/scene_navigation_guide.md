# 場景導航指南

## 概述

本遊戲使用混合架構來管理場景切換：
- **Flame 遊戲引擎**：管理遊戲內場景（Worlds）
- **Flutter Navigator**：管理全螢幕頁面（如 TrafficScreen）

## 架構說明

### 1. 遊戲實例管理
```dart
// lib/main.dart
final GlobalKey<RiverpodAwareGameWidgetState<WOTGame>> gameWidgetKey =
    GlobalKey<RiverpodAwareGameWidgetState<WOTGame>>();
final gameInstance = WOTGame(); // 單例遊戲實例
```

### 2. 路由結構
```dart
// 遊戲內場景路由（Flame RouterComponent）
routes: {
  'lobby': WorldRoute(LobbyWorld.new),
  'level_home': WorldRoute(LevelHomeWorld.new, maintainState: false),
  'level_traffic': WorldRoute(LevelTrafficWorld.new),
  'event_scene': WorldRoute(EventSceneWorld.new),
  'interaction_capture': WorldRoute(InteractionCaptureWorld.new),
}

// 全螢幕頁面路由（Flutter Navigator）
routes: {
  '/': (context) => Scaffold(body: RiverpodAwareGameWidget<WOTGame>),
  '/traffic': (context) => const TrafficScreen(),
}
```

## 場景切換方法

### 方法一：事件驅動場景切換（推薦）

#### 1. 定義事件類型
```dart
// lib/providers/game_event_provider.dart
enum GameEventType { none, rain, coffee, lucky, question, home }

class GameEvent {
  final GameEventType type;
  final Map<String, dynamic>? data;
  
  GameEvent({this.type = GameEventType.none, this.data});
}
```

#### 2. 觸發事件
在任何地方（包括 Material UI 頁面）：
```dart
// 在 TrafficScreen 或其他 Material UI 頁面中
ref.read(gameEventProvider.notifier).setEvent(GameEventType.rain);
Navigator.of(context).pop(); // 返回遊戲主畫面
```

#### 3. 遊戲自動響應事件
```dart
// lib/wot_game.dart
@override
void update(double dt) {
  super.update(dt);
  
  // 自動檢查事件狀態變化
  final currentEvent = ref.read(gameEventProvider);
  if (currentEvent.type != GameEventType.none && 
      currentEvent.type != _lastEventType) {
    _lastEventType = currentEvent.type;
    router.pushNamed('event_scene'); // 切換到事件場景
    ref.read(gameEventProvider.notifier).clearEvent();
  }
}
```

### 方法二：直接遊戲內場景切換

#### 在 Flame 組件中
```dart
// 在任何 Flame 組件中
game.router.pushNamed('level_traffic');
game.router.pop(); // 返回上一個場景
game.router.pushReplacementNamed('lobby'); // 替換當前場景
```

#### 在 Material UI 頁面中
```dart
// 需要先獲取遊戲實例
final game = gameInstance; // 使用全局單例
game.router.pushNamed('level_traffic');
```

### 方法三：全螢幕頁面導航

#### 從遊戲切換到全螢幕頁面
```dart
// 在 Flame 組件中
Navigator.of(context).pushNamed('/traffic');
```

#### 從全螢幕頁面返回遊戲
```dart
// 在 TrafficScreen 中
Navigator.of(context).pop(); // 返回遊戲主畫面
```

## 實際使用範例

### 範例 1：從 TrafficScreen 觸發雨天事件
```dart
// lib/screen/level_traffic/traffic_screen.dart
void _handlePointEvent(TrafficPointType type) {
  switch (type) {
    case TrafficPointType.card:
      // 1. 設定事件
      ref.read(gameEventProvider.notifier).setEvent(GameEventType.rain);
      // 2. 返回遊戲主畫面
      Navigator.of(context).pop();
      break;
    // ... 其他事件
  }
}
```

### 範例 2：添加新的事件類型
```dart
// 1. 在 game_event_provider.dart 中添加新類型
enum GameEventType { none, rain, coffee, lucky, question, home, newEvent }

// 2. 在 TrafficScreen 中觸發
case TrafficPointType.coffee:
  ref.read(gameEventProvider.notifier).setEvent(GameEventType.newEvent);
  Navigator.of(context).pop();
  break;

// 3. 在 WOTGame 中處理（可選，如果需要特殊邏輯）
if (currentEvent.type == GameEventType.newEvent) {
  router.pushNamed('new_scene');
}
```

### 範例 3：帶數據的事件
```dart
// 觸發帶數據的事件
ref.read(gameEventProvider.notifier).setEvent(
  GameEventType.rain,
  data: {'intensity': 'heavy', 'duration': 30}
);

// 在遊戲中讀取數據
final eventData = currentEvent.data;
if (eventData != null) {
  final intensity = eventData['intensity'];
  final duration = eventData['duration'];
  // 根據數據調整場景
}
```

## 最佳實踐

### 1. 事件驅動優先
- 使用事件驅動的方式進行場景切換，特別是從 Material UI 到 Flame 場景
- 這樣可以避免 GlobalKey 衝突和上下文問題

### 2. 單例遊戲實例
- 始終使用 `gameInstance` 單例，避免創建多個遊戲實例
- 這確保了狀態的一致性和記憶體效率

### 3. 正確的導航模式
- 從全螢幕頁面返回遊戲時，使用 `Navigator.pop()` 而不是 `pushNamed('/')`
- 在遊戲內切換場景時，使用 `router.pushNamed()`

### 4. 事件清理
- 事件處理完成後，記得調用 `clearEvent()` 清理狀態
- 避免重複觸發相同事件

## 故障排除

### 常見問題

1. **GlobalKey 衝突**
   - 確保使用單例遊戲實例
   - 避免使用 `Navigator.pushNamed('/')` 返回遊戲

2. **ref.listen 錯誤**
   - 在 Flame 遊戲中使用 `ref.read` 和手動檢查
   - 避免在生命週期方法中使用 `ref.listen`

3. **場景不切換**
   - 檢查事件類型是否正確設定
   - 確認路由名稱是否匹配
   - 檢查 `update` 方法是否正常執行

### 調試技巧

```dart
// 添加日誌來追蹤事件流程
print('事件觸發: ${currentEvent.type}');
print('路由切換: ${router.currentRoute.name}');
```

## 擴展指南

### 添加新場景
1. 創建新的 World 類別
2. 在 `WOTGame` 的路由中添加新路由
3. 定義對應的事件類型（如需要）
4. 實現場景切換邏輯

### 添加新事件類型
1. 在 `GameEventType` 枚舉中添加新類型
2. 在觸發點設定事件
3. 在 `WOTGame.update` 中處理新事件
4. 實現對應的場景邏輯

這個架構設計為可擴展的，可以輕鬆添加新的場景和事件類型，同時保持代碼的清晰和可維護性。 