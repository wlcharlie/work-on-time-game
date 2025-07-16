import 'package:flame/components.dart';
import 'package:work_on_time_game/components/scene/base_scene.dart';
import 'package:work_on_time_game/components/scene/scene_element.dart';

/// 简单事件场景示例 - 使用默认背景
class SimpleEventExample extends BaseScene {
  // 这个场景将自动使用 EndlessBackground 作为背景
  // 如果不想使用默认背景，可以重写此方法返回 false
  // @override
  // bool get useDefaultBackground => false;

  @override
  List<SceneElement> defineSceneElements() {
    return [
      // 不需要定义背景元素，将自动使用 EndlessBackground
      
      // 只需要定义其他场景元素
      SceneElement.character(
        imagePath: 'character.png',
        position: Vector2(393, 800),
        animations: [
          SceneAnimation.fadeIn(
            duration: 1.0,
            delay: 0.5,
          ),
        ],
      ),
      
      // 可以添加其他元素...
    ];
  }
  
  @override
  void onSceneCompleted() {
    // 场景完成后的处理
    game.router.pushNamed('lobby');
  }
}