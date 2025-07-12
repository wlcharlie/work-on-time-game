import 'package:flame/components.dart';

extension Vector2Extension on Vector2 {
  Vector2 get center => Vector2(x / 2, y / 2);
  Vector2 get doubled => Vector2(x * 2, y * 2);

  /// 計算在此尺寸容器中央的位置
  Vector2 centerPosition(Vector2 objectSize, {Vector2? offset}) {
    final offsetValue = offset ?? Vector2.zero();
    return Vector2(
      (x - objectSize.x) / 2 + offsetValue.x,
      (y - objectSize.y) / 2 + offsetValue.y,
    );
  }

  /// 計算在此尺寸容器左上角的位置
  Vector2 topLeftPosition({Vector2? offset}) {
    final offsetValue = offset ?? Vector2.zero();
    return Vector2(offsetValue.x, offsetValue.y);
  }

  /// 計算在此尺寸容器右上角的位置
  Vector2 topRightPosition(Vector2 objectSize, {Vector2? offset}) {
    final offsetValue = offset ?? Vector2.zero();
    return Vector2(
      x - objectSize.x - offsetValue.x,
      offsetValue.y,
    );
  }

  /// 計算在此尺寸容器左下角的位置
  Vector2 bottomLeftPosition(Vector2 objectSize, {Vector2? offset}) {
    final offsetValue = offset ?? Vector2.zero();
    return Vector2(
      offsetValue.x,
      y - objectSize.y - offsetValue.y,
    );
  }

  /// 計算在此尺寸容器右下角的位置
  Vector2 bottomRightPosition(Vector2 objectSize, {Vector2? offset}) {
    final offsetValue = offset ?? Vector2.zero();
    return Vector2(
      x - objectSize.x - offsetValue.x,
      y - objectSize.y - offsetValue.y,
    );
  }

  /// 計算僅水平置中的位置
  Vector2 horizontalCenterPosition(Vector2 objectSize, double y) {
    return Vector2(
      (x - objectSize.x) / 2,
      y,
    );
  }

  /// 計算僅垂直置中的位置
  Vector2 verticalCenterPosition(Vector2 objectSize, double x) {
    return Vector2(
      x,
      (y - objectSize.y) / 2,
    );
  }
}

extension PositionComponentExtension on PositionComponent {
  /// 將組件置於遊戲畫面正中心
  void centerInGame() {
    if (this is HasGameReference) {
      final gameRef = this as HasGameReference;
      position = gameRef.game.size.centerPosition(size);
    }
  }

  /// 將組件置於遊戲畫面正中心（使用錨點方式）
  void centerInGameWithAnchor() {
    if (this is HasGameReference) {
      final gameRef = this as HasGameReference;
      anchor = Anchor.center;
      position = gameRef.game.size / 2;
    }
  }

  /// 將組件置於指定區域的中心
  void centerInArea(Vector2 areaSize, {Vector2? areaPosition}) {
    final area = areaPosition ?? Vector2.zero();
    position = area + areaSize.centerPosition(size);
  }

  /// 將組件置於另一個組件的中心
  void centerInComponent(PositionComponent parentComponent) {
    position =
        parentComponent.position + parentComponent.size.centerPosition(size);
  }

  /// 將組件置於遊戲畫面的四個角落
  void positionTopLeftInGame({Vector2? offset}) {
    if (this is HasGameReference) {
      final gameRef = this as HasGameReference;
      position = gameRef.game.size.topLeftPosition(offset: offset);
    }
  }

  void positionTopRightInGame({Vector2? offset}) {
    if (this is HasGameReference) {
      final gameRef = this as HasGameReference;
      position = gameRef.game.size.topRightPosition(size, offset: offset);
    }
  }

  void positionBottomLeftInGame({Vector2? offset}) {
    if (this is HasGameReference) {
      final gameRef = this as HasGameReference;
      position = gameRef.game.size.bottomLeftPosition(size, offset: offset);
    }
  }

  void positionBottomRightInGame({Vector2? offset}) {
    if (this is HasGameReference) {
      final gameRef = this as HasGameReference;
      position = gameRef.game.size.bottomRightPosition(size, offset: offset);
    }
  }

  /// 將組件置於指定區域的四個角落
  void positionTopLeftInArea(Vector2 areaSize,
      {Vector2? areaPosition, Vector2? offset}) {
    final area = areaPosition ?? Vector2.zero();
    position = area + areaSize.topLeftPosition(offset: offset);
  }

  void positionTopRightInArea(Vector2 areaSize,
      {Vector2? areaPosition, Vector2? offset}) {
    final area = areaPosition ?? Vector2.zero();
    position = area + areaSize.topRightPosition(size, offset: offset);
  }

  void positionBottomLeftInArea(Vector2 areaSize,
      {Vector2? areaPosition, Vector2? offset}) {
    final area = areaPosition ?? Vector2.zero();
    position = area + areaSize.bottomLeftPosition(size, offset: offset);
  }

  void positionBottomRightInArea(Vector2 areaSize,
      {Vector2? areaPosition, Vector2? offset}) {
    final area = areaPosition ?? Vector2.zero();
    position = area + areaSize.bottomRightPosition(size, offset: offset);
  }

  /// 將組件置於另一個組件的四個角落
  void positionTopLeftInComponent(PositionComponent parentComponent,
      {Vector2? offset}) {
    position = parentComponent.position +
        parentComponent.size.topLeftPosition(offset: offset);
  }

  void positionTopRightInComponent(PositionComponent parentComponent,
      {Vector2? offset}) {
    position = parentComponent.position +
        parentComponent.size.topRightPosition(size, offset: offset);
  }

  void positionBottomLeftInComponent(PositionComponent parentComponent,
      {Vector2? offset}) {
    position = parentComponent.position +
        parentComponent.size.bottomLeftPosition(size, offset: offset);
  }

  void positionBottomRightInComponent(PositionComponent parentComponent,
      {Vector2? offset}) {
    position = parentComponent.position +
        parentComponent.size.bottomRightPosition(size, offset: offset);
  }
}
