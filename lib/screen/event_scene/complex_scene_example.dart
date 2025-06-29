import 'package:flame/components.dart';
import 'package:work_on_time_game/components/scene/base_scene.dart';
import 'package:work_on_time_game/components/scene/scene_element.dart';
import 'package:work_on_time_game/config/images.dart';

/// 复杂场景示例 - 展示多种动画效果的组合
class ComplexSceneExample extends BaseScene {
  @override
  List<SceneElement> defineSceneElements() {
    return [
      // 背景 - 淡入效果
      SceneElement.background(
        imagePath: images.mrtSceneBackground,
      ),

      // 主角色 - 从底部滑入
      SceneElement.character(
        imagePath: images.mrtSceneCharacters,
        position: Vector2(200, 600), // 屏幕外底部
        animations: [
          SceneAnimation.slideIn(
            startPosition: Vector2(200, 600),
            targetPosition: Vector2(200, 400),
            duration: 1.0,
            delay: 0.5,
          ),
        ],
      ),

      // 右侧事件 - 复杂的组合动画
      SceneElement.event(
        id: 'eventRight',
        imagePath: images.mrtSceneEventRight,
        position: Vector2(500, 100),
        animations: [
          // 1. 从右侧滑入
          SceneAnimation.slideIn(
            startPosition: Vector2(500, 100),
            targetPosition: Vector2(200, 100),
            duration: 1.5,
            delay: 1.0,
          ),
          // 2. 停留2秒后开始淡出
          SceneAnimation.fadeOut(
            duration: 1.0,
            delay: 4.5, // 1.0(延迟) + 1.5(滑入) + 2.0(停留)
          ),
        ],
      ),

      // 左侧事件 - 滑入后循环效果
      SceneElement.event(
        id: 'eventLeft',
        imagePath: images.mrtSceneEventLeft,
        position: Vector2(-200, 300),
        animations: [
          // 1. 从左侧滑入
          SceneAnimation.slideIn(
            startPosition: Vector2(-200, 300),
            targetPosition: Vector2(50, 300),
            duration: 1.5,
            delay: 2.5,
          ),
          // 2. 滑入完成后开始透明度循环
          SceneAnimation.opacityLoop(
            duration: 1.5,
            delay: 4.0, // 2.5(延迟) + 1.5(滑入)
            startOpacity: 0.3,
            targetOpacity: 1.0,
          ),
        ],
      ),

      // 装饰元素1 - 持续的移动循环
      SceneElement.effect(
        id: 'floatingEffect1',
        imagePath: images.star, // 使用星星作为装饰
        position: Vector2(100, 200),
        animations: [
          SceneAnimation.moveLoop(
            moveDistance: Vector2(0, 20),
            duration: 2.0,
            delay: 3.0,
          ),
          SceneAnimation.opacityLoop(
            duration: 3.0,
            delay: 3.0,
            startOpacity: 0.5,
            targetOpacity: 1.0,
          ),
        ],
      ),

      // 装饰元素2 - 不同的循环效果
      SceneElement.effect(
        id: 'floatingEffect2',
        imagePath: images.star,
        position: Vector2(350, 150),
        animations: [
          SceneAnimation.moveLoop(
            moveDistance: Vector2(15, 0),
            duration: 1.5,
            delay: 4.0,
          ),
          SceneAnimation.opacityLoop(
            duration: 2.0,
            delay: 4.0,
            startOpacity: 0.3,
            targetOpacity: 0.8,
          ),
        ],
      ),
    ];
  }

  @override
  void onSceneCompleted() {
    print('复杂场景播放完成！');
    // 可以在这里切换到下一个场景或处理后续逻辑
  }

  @override
  void updateScene(double dt) {
    // 自定义场景逻辑示例

    // 检查特定元素的状态
    final rightEventSprite = getSprite('eventRight');
    if (rightEventSprite != null && rightEventSprite.opacity < 0.1) {
      // 当右侧事件几乎完全淡出时，可以触发其他逻辑
      print('右侧事件已淡出');
    }

    // 可以根据时间或其他条件动态添加动画
    // 例如：在特定时间点为元素添加新的动画效果
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 添加控制按钮
    final replayButton = TextComponent(
      text: 'Replay Complex',
      position: Vector2(50, 50),
      textRenderer: TextPaint(),
    );

    final pauseButton = TextComponent(
      text: 'Pause',
      position: Vector2(50, 80),
      textRenderer: TextPaint(),
    );

    add(replayButton);
    add(pauseButton);
  }

  @override
  void onMount() {
    super.onMount();

    // 设置相机
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.moveTo(Vector2.zero());
  }

  /// 自定义方法：暂停所有动画
  void pauseAllAnimations() {
    setSceneState(SceneState.paused);
    // 可以在这里添加暂停所有动画的逻辑
  }

  /// 自定义方法：恢复所有动画
  void resumeAllAnimations() {
    setSceneState(SceneState.playing);
    // 可以在这里添加恢复所有动画的逻辑
  }

  /// 动态添加新元素的示例
  void addDynamicElement() {
    // 可以在运行时动态添加新的场景元素
    addAnimationToElement(
      'eventLeft',
      SceneAnimation.fadeOut(duration: 2.0),
    );
  }
}
