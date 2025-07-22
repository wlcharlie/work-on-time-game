import 'package:flame/components.dart';

/// 场景元素动画类型
enum SceneAnimationType {
  slideIn, // 滑入动画
  fadeIn, // 淡入动画
  fadeOut, // 淡出动画
  moveLoop, // 循环移动
  opacityLoop, // 透明度循环
  scaleIn, // 缩放动画
}

/// 场景动画配置
class SceneAnimation {
  final SceneAnimationType type;
  final double duration;
  final Vector2? startPosition;
  final Vector2? targetPosition;
  final double? startOpacity;
  final double? targetOpacity;
  final double? startScale;
  final double? targetScale;
  final Vector2? moveDistance;
  final Vector2? resetPosition;
  final bool infinite;
  final double delay;
  final void Function()? onStart;

  const SceneAnimation({
    required this.type,
    required this.duration,
    this.startPosition,
    this.targetPosition,
    this.startOpacity,
    this.targetOpacity,
    this.startScale,
    this.targetScale,
    this.moveDistance,
    this.resetPosition,
    this.infinite = false,
    this.delay = 0,
    this.onStart,
  });

  /// 滑入动画
  static SceneAnimation slideIn({
    required Vector2 startPosition,
    required Vector2 targetPosition,
    double duration = 1.5,
    double delay = 0,
  }) =>
      SceneAnimation(
        type: SceneAnimationType.slideIn,
        duration: duration,
        startPosition: startPosition,
        targetPosition: targetPosition,
        delay: delay,
      );

  /// 淡入动画
  static SceneAnimation fadeIn({
    double duration = 1.0,
    double delay = 0,
    double startOpacity = 0.0,
    double targetOpacity = 1.0,
    void Function()? onStart,
  }) =>
      SceneAnimation(
        type: SceneAnimationType.fadeIn,
        duration: duration,
        startOpacity: startOpacity,
        targetOpacity: targetOpacity,
        delay: delay,
        onStart: onStart,
      );

  /// 淡出动画
  static SceneAnimation fadeOut({
    double duration = 1.0,
    double delay = 0,
    double startOpacity = 1.0,
    double targetOpacity = 0.0,
  }) =>
      SceneAnimation(
        type: SceneAnimationType.fadeOut,
        duration: duration,
        startOpacity: startOpacity,
        targetOpacity: targetOpacity,
        delay: delay,
      );

  /// 循环移动动画
  static SceneAnimation moveLoop({
    required Vector2 moveDistance,
    double duration = 1.0,
    double delay = 0,
    Vector2? resetPosition,
    void Function()? onStart,
  }) =>
      SceneAnimation(
        type: SceneAnimationType.moveLoop,
        duration: duration,
        moveDistance: moveDistance,
        resetPosition: resetPosition,
        infinite: true,
        delay: delay,
        onStart: onStart,
      );

  /// 透明度循环动画
  static SceneAnimation opacityLoop({
    double duration = 2.0,
    double delay = 0,
    double startOpacity = 0.0,
    double targetOpacity = 1.0,
    void Function()? onStart,
  }) =>
      SceneAnimation(
        type: SceneAnimationType.opacityLoop,
        duration: duration,
        startOpacity: startOpacity,
        targetOpacity: targetOpacity,
        infinite: true,
        delay: delay,
        onStart: onStart,
      );

  static SceneAnimation scaleIn({
    double duration = 1.0,
    double delay = 0,
    double startScale = 0.0,
    double targetScale = 1.0,
  }) =>
      SceneAnimation(
        type: SceneAnimationType.scaleIn,
        duration: duration,
        startScale: startScale,
        targetScale: targetScale,
        infinite: false,
        delay: delay,
      );
}

/// 场景元素配置
class SceneElement {
  final String id;
  final String imagePath;
  final Vector2 position;
  final Anchor? anchor;
  final Vector2? scale;
  final double opacity;
  final int priority;
  final List<SceneAnimation> animations;

  const SceneElement({
    required this.id,
    required this.imagePath,
    required this.position,
    this.anchor,
    this.scale,
    this.opacity = 1.0,
    this.priority = 0,
    this.animations = const [],
  });

  /// 创建背景元素
  static SceneElement background({
    required String imagePath,
    Vector2? position,
    Anchor? anchor,
    Vector2? scale,
  }) =>
      SceneElement(
        id: 'background',
        imagePath: imagePath,
        position: position ?? Vector2.zero(),
        anchor: anchor,
        scale: scale,
        priority: -1,
      );

  /// 创建角色元素
  static SceneElement character({
    String? id,
    required String imagePath,
    required Vector2 position,
    Anchor? anchor,
    Vector2? scale,
    double opacity = 1.0,
    List<SceneAnimation> animations = const [],
  }) =>
      SceneElement(
        id: id ?? 'character',
        imagePath: imagePath,
        position: position,
        anchor: anchor,
        scale: scale,
        opacity: opacity,
        animations: animations,
      );

  /// 创建事件元素
  static SceneElement event({
    required String id,
    required String imagePath,
    required Vector2 position,
    Anchor? anchor,
    Vector2? scale,
    List<SceneAnimation> animations = const [],
  }) =>
      SceneElement(
        id: id,
        imagePath: imagePath,
        position: position,
        anchor: anchor,
        scale: scale,
        animations: animations,
      );

  /// 创建效果元素（如雨滴等）
  static SceneElement effect({
    required String id,
    required String imagePath,
    Vector2? position,
    Anchor? anchor,
    Vector2? scale,
    double opacity = 0.0,
    List<SceneAnimation> animations = const [],
  }) =>
      SceneElement(
        id: id,
        imagePath: imagePath,
        position: position ?? Vector2.zero(),
        anchor: anchor,
        scale: scale,
        opacity: opacity,
        animations: animations,
      );
}
