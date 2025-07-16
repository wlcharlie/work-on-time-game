import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/animation.dart';
import 'package:work_on_time_game/components/background/endless_background.dart';
import 'package:work_on_time_game/components/scene/scene_element.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

/// 场景状态
enum SceneState {
  initial, // 初始状态
  loading, // 加载中
  playing, // 播放中
  paused, // 暂停
  completed, // 完成
}

/// 通用场景基类
abstract class BaseScene extends Component with HasGameReference<WOTGame> {
  // 场景状态
  SceneState _sceneState = SceneState.initial;
  SceneState get sceneState => _sceneState;

  // 场景元素
  final Map<String, SpriteComponent> _spriteComponents = {};
  final Map<String, SceneElement> _sceneElements = {};

  // 动画计时器
  final Map<String, Timer> _animationTimers = {};

  // 重置标志
  bool _isResetting = false;

  // 场景完成计时器
  Timer? _sceneCompletionTimer;

  // 背景组件
  EndlessBackground? _backgroundComponent;

  /// 子类需要实现：定义场景元素
  List<SceneElement> defineSceneElements();

  /// 子类可选择重写：是否使用默认背景
  bool get useDefaultBackground => true;

  /// 子类可选择重写：场景完成后的回调
  void onSceneCompleted() {
    print('场景完成');
  }

  /// 子类可选择重写：自定义场景逻辑
  void updateScene(double dt) {}

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadScene();
  }

  /// 加载场景
  Future<void> _loadScene() async {
    _sceneState = SceneState.loading;

    // 添加默认背景（如果启用）
    if (useDefaultBackground) {
      await _addDefaultBackground();
    }

    final elements = defineSceneElements();

    // 按优先级排序
    elements.sort((a, b) => a.priority.compareTo(b.priority));

    // 加载所有图片并创建组件
    for (final element in elements) {
      final image = await Flame.images.load(element.imagePath);
      final sprite = SpriteComponent.fromImage(
        image,
        position: element.position.clone(),
        scale: element.scale?.clone(),
        anchor: element.anchor,
      )..opacity = element.opacity;

      _spriteComponents[element.id] = sprite;
      _sceneElements[element.id] = element;

      add(sprite);
    }

    _sceneState = SceneState.playing;
    _startAnimations();
  }

  /// 添加默认背景
  Future<void> _addDefaultBackground() async {
    final images = Images();
    await game.images.load(images.greenDotBackground);
    
    _backgroundComponent = EndlessBackground(
      image: game.images.fromCache(images.greenDotBackground),
    );
    
    // 设置背景的优先级为最低，确保它在所有其他元素后面
    _backgroundComponent!.priority = -1000;
    
    add(_backgroundComponent!);
  }

  /// 开始所有动画
  void _startAnimations() {
    double maxEndTime = 0.0;

    for (final element in _sceneElements.values) {
      final sprite = _spriteComponents[element.id];
      if (sprite == null) continue;

      for (final animation in element.animations) {
        _applyAnimation(sprite, animation);

        // 计算这个动画的结束时间（排除无限循环动画）
        if (!animation.infinite) {
          final endTime = animation.delay + animation.duration;
          if (endTime > maxEndTime) {
            maxEndTime = endTime;
          }
        }
      }
    }

    // 设置场景完成计时器
    if (maxEndTime > 0) {
      print('场景将在 ${maxEndTime + 0.1} 秒后完成');
      _sceneCompletionTimer = Timer(
        maxEndTime + 0.1, // 额外加0.1秒确保所有动画都完成
        onTick: () {
          print('场景动画全部完成，触发 onSceneCompleted');
          setSceneState(SceneState.completed);
        },
      );
    }
  }

  /// 应用动画效果
  void _applyAnimation(SpriteComponent sprite, SceneAnimation animation) {
    void executeAnimation() {
      // 调用onStart回调
      animation.onStart?.call();
      
      switch (animation.type) {
        case SceneAnimationType.slideIn:
          _applySlideInAnimation(sprite, animation);
          break;
        case SceneAnimationType.fadeIn:
          _applyFadeInAnimation(sprite, animation);
          break;
        case SceneAnimationType.fadeOut:
          _applyFadeOutAnimation(sprite, animation);
          break;
        case SceneAnimationType.moveLoop:
          _applyMoveLoopAnimation(sprite, animation);
          break;
        case SceneAnimationType.opacityLoop:
          _applyOpacityLoopAnimation(sprite, animation);
          break;
      }
    }

    if (animation.delay > 0) {
      final timerId = '${sprite.hashCode}_${animation.hashCode}';
      _animationTimers[timerId] =
          Timer(animation.delay, onTick: executeAnimation);
    } else {
      executeAnimation();
    }
  }

  /// 滑入动画
  void _applySlideInAnimation(
      SpriteComponent sprite, SceneAnimation animation) {
    if (animation.startPosition != null) {
      sprite.position = animation.startPosition!.clone();
    }

    if (animation.targetPosition != null) {
      sprite.add(
        MoveToEffect(
          animation.targetPosition!,
          EffectController(
            duration: animation.duration,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    }
  }

  /// 淡入动画
  void _applyFadeInAnimation(SpriteComponent sprite, SceneAnimation animation) {
    if (animation.startOpacity != null) {
      sprite.opacity = animation.startOpacity!;
    }

    sprite.add(
      OpacityEffect.to(
        animation.targetOpacity ?? 1.0,
        EffectController(
          duration: animation.duration,
          curve: Curves.easeIn,
        ),
      ),
    );
  }

  /// 淡出动画
  void _applyFadeOutAnimation(
      SpriteComponent sprite, SceneAnimation animation) {
    if (animation.startOpacity != null) {
      sprite.opacity = animation.startOpacity!;
    }

    sprite.add(
      OpacityEffect.to(
        animation.targetOpacity ?? 0.0,
        EffectController(
          duration: animation.duration,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  /// 循环移动动画
  void _applyMoveLoopAnimation(
      SpriteComponent sprite, SceneAnimation animation) {
    if (animation.moveDistance == null) return;

    sprite.add(
      MoveEffect.by(
        animation.moveDistance!,
        EffectController(
          duration: animation.duration,
          infinite: animation.infinite,
          onMax: () {
            // 重置位置：如果指定了resetPosition就使用，否则使用默认行为
            if (animation.resetPosition != null) {
              sprite.position = animation.resetPosition!.clone();
            } else {
              sprite.position -= animation.moveDistance!;
            }
          },
        ),
      ),
    );
  }

  /// 透明度循环动画
  void _applyOpacityLoopAnimation(
      SpriteComponent sprite, SceneAnimation animation) {
    sprite.add(
      SequenceEffect(
        [
          OpacityEffect.to(
            animation.targetOpacity ?? 1.0,
            EffectController(duration: animation.duration / 2),
          ),
          OpacityEffect.to(
            animation.startOpacity ?? 0.0,
            EffectController(duration: animation.duration / 2),
          ),
        ],
        infinite: animation.infinite,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isResetting) return;

    // 更新动画计时器
    _updateTimers(dt);

    // 调用子类的自定义逻辑
    if (_sceneState == SceneState.playing) {
      updateScene(dt);
    }
  }

  /// 更新计时器
  void _updateTimers(double dt) {
    final timersToRemove = <String>[];

    for (final entry in _animationTimers.entries) {
      final timer = entry.value;
      if (timer.isRunning()) {
        timer.update(dt);
      } else {
        timersToRemove.add(entry.key);
      }
    }

    // 清理已完成的计时器
    for (final key in timersToRemove) {
      _animationTimers.remove(key);
    }

    // 更新场景完成计时器
    if (_sceneCompletionTimer?.isRunning() == true) {
      _sceneCompletionTimer!.update(dt);
    }
  }

  /// 获取场景元素的 Sprite 组件
  SpriteComponent? getSprite(String elementId) {
    return _spriteComponents[elementId];
  }

  /// 获取场景元素配置
  SceneElement? getElement(String elementId) {
    return _sceneElements[elementId];
  }

  /// 为特定元素添加动画
  void addAnimationToElement(String elementId, SceneAnimation animation) {
    final sprite = _spriteComponents[elementId];
    if (sprite != null) {
      _applyAnimation(sprite, animation);
    }
  }

  /// 重置场景
  void reset() {
    _isResetting = true;

    // 停止所有计时器
    for (final timer in _animationTimers.values) {
      timer.stop();
    }
    _animationTimers.clear();

    // 停止场景完成计时器
    _sceneCompletionTimer?.stop();
    _sceneCompletionTimer = null;

    // 清除所有效果
    _forceCleanAllEffects();

    // 重置组件属性
    _resetComponentProperties();

    // 重置状态
    _sceneState = SceneState.initial;

    _isResetting = false;
  }

  /// 重播场景
  void replay() {
    reset();
    _sceneState = SceneState.playing;
    _startAnimations();
  }

  /// 强制清除所有效果
  void _forceCleanAllEffects() {
    for (final sprite in _spriteComponents.values) {
      final effects = sprite.children.whereType<Effect>().toList();
      for (final effect in effects) {
        effect.removeFromParent();
      }
    }
  }

  /// 重置组件属性
  void _resetComponentProperties() {
    for (final entry in _sceneElements.entries) {
      final elementId = entry.key;
      final element = entry.value;
      final sprite = _spriteComponents[elementId];

      if (sprite != null) {
        sprite.position = element.position.clone();
        sprite.opacity = element.opacity;
        sprite.scale = element.scale?.clone() ?? Vector2.all(1.0);
      }
    }
  }

  /// 设置场景状态
  void setSceneState(SceneState state) {
    _sceneState = state;

    if (state == SceneState.completed) {
      onSceneCompleted();
    }
  }

  @override
  void onRemove() {
    // 清理所有计时器
    for (final timer in _animationTimers.values) {
      timer.stop();
    }
    _animationTimers.clear();

    // 清理场景完成计时器
    _sceneCompletionTimer?.stop();
    _sceneCompletionTimer = null;

    super.onRemove();
  }
}
