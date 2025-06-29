import 'package:flame/components.dart';
import 'package:work_on_time_game/components/scene/base_scene.dart';
import 'package:work_on_time_game/components/scene/scene_element.dart';
import 'package:work_on_time_game/config/images.dart';

class MrtScene extends BaseScene {
  @override
  List<SceneElement> defineSceneElements() {
    return [
      // 背景 - 优先级最低
      SceneElement.background(
        imagePath: images.mrtSceneBackground,
      ),

      // 右侧事件 - 从右边滑入
      SceneElement.event(
        id: 'eventRight',
        imagePath: images.mrtSceneEventRight,
        position: Vector2(800, 110), // 屏幕外的起始位置
        animations: [
          SceneAnimation.slideIn(
            startPosition: Vector2(800, 110), // 从屏幕右侧外开始
            targetPosition: Vector2(217, 110), // 滑到目标位置
            duration: 1.5,
            delay: 0.5, // 延迟0.5秒开始
          ),
        ],
      ),

      // 左侧事件 - 从左边滑入，稍后开始
      SceneElement.event(
        id: 'eventLeft',
        imagePath: images.mrtSceneEventLeft,
        position: Vector2(0, 506), // 屏幕外的起始位置
        anchor: Anchor.topRight,
        animations: [
          SceneAnimation.slideIn(
            startPosition: Vector2(0, 506), // 从屏幕左侧外开始
            targetPosition: Vector2(589, 506), // 滑到目标位置
            duration: 1.5,
            delay: 2.0, // 延迟2秒开始，让右侧先进入
          ),
        ],
      ),

      // 角色 - 放在底部中央
      SceneElement.character(
        imagePath: images.mrtSceneCharacters,
        position: Vector2(0, 0),
        opacity: 0,
        animations: [
          SceneAnimation.fadeIn(
            duration: 1.5,
            delay: 3.5,
          ),
        ],
      ),
    ];
  }

  @override
  void onSceneCompleted() {
    // 场景完成后的回调
    print('MRT场景播放完成');

    game.router.pushNamed('interaction_capture');
  }

  @override
  void updateScene(double dt) {
    // 自定义场景逻辑
    // 例如：检查是否所有动画都完成了

    // 可以在这里添加场景特有的逻辑
    // 比如状态切换、用户交互等
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 添加重播按钮用于测试
    final replayButton = TextComponent(
      text: 'Replay MRT',
      position: Vector2(50, 50),
      textRenderer: TextPaint(),
    );

    add(replayButton);
  }

  @override
  void onMount() {
    super.onMount();

    // 设置相机
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.moveTo(Vector2.zero());
  }
}
