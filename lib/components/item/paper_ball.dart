import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/wot_game.dart';

enum PaperBallState {
  idle,
  rising,
  falling,
}

class PaperBall extends SpriteComponent
    with HasGameReference<WOTGame>, TapCallbacks {
  static final String imagePaths = images.paperBall;
  static final String name = 'item_paper_ball';

  final void Function(TapDownEvent event)? onTapDownCallback;

  final double gravity = 15;
  final double jumpSpeed = 610;
  final double terminalVelocity = 150;

  // 可調整下降加速的參數
  final double fallingGravityMultiplier = 1.05; // 下降時的重力倍數，使下降更快

  // 旋轉相關參數
  final double minRotationSpeed = 1.0; // 最小旋轉速度（弧度/秒）
  final double maxRotationSpeed = 3.0; // 最大旋轉速度（弧度/秒）
  double _rotationSpeed = 0; // 當前旋轉速度
  final Random _random = Random(); // 隨機數生成器

  // 降落範圍
  final double minLandingY = 677.0 * 2; // 最小降落高度
  final double maxLandingY = 760.0 * 2; // 最大降落高度
  double _targetLandingY = 0; // 當前目標降落高度

  bool hasJumped = false;
  double _velocity = 0;
  double _initialY = 0;

  PaperBallState _state = PaperBallState.idle;
  PaperBallState get state => _state;

  PaperBall({
    required Vector2 position,
    int priority = 0,
    this.onTapDownCallback,
  }) : super(position: position, priority: priority) {
    _initialY = position.y;
    anchor = Anchor.center; // 設置錨點為中心，使旋轉看起來更自然
    // 初始化第一個目標降落位置
    _targetLandingY = _getRandomLandingY();
  }

  // 生成隨機的降落 Y 坐標
  double _getRandomLandingY() {
    return minLandingY + _random.nextDouble() * (maxLandingY - minLandingY);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (!game.images.containsKey(PaperBall.imagePaths)) {
      await game.images.load(PaperBall.imagePaths);
    }
    final image = game.images.fromCache(PaperBall.imagePaths);
    sprite = Sprite(image);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapDownCallback?.call(event);
    // Start the jump when tapped
    jump();
  }

  void jump() {
    // Only allow jumping if the paper ball is in idle state
    if (_state == PaperBallState.idle) {
      _state = PaperBallState.rising;
      _velocity = -jumpSpeed;
      hasJumped = true;

      // 每次跳躍時設定一個新的目標降落位置
      _targetLandingY = _getRandomLandingY();

      // 設置隨機旋轉速度和方向
      // 隨機決定旋轉方向（順時針或逆時針）
      double direction = _random.nextBool() ? 1.0 : -1.0;
      // 在最小和最大旋轉速度之間隨機選擇一個值
      _rotationSpeed = direction *
          (_random.nextDouble() * (maxRotationSpeed - minRotationSpeed) +
              minRotationSpeed);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state != PaperBallState.idle) {
      // 方案 1: 使用不同的重力效果用於上升和下降 (推薦)
      if (_velocity >= 0) {
        // 下降階段時使用更大的重力，讓下降加速更明顯
        _velocity += gravity * fallingGravityMultiplier * dt * 60;
      } else {
        // 上升階段保持原有的重力
        _velocity += gravity * dt * 60;
      }

      // 方案 2: 保持原始代碼，但使用更大的終端速度
      // _velocity += gravity * dt * 60;
      // _velocity = _velocity.clamp(-double.infinity, terminalVelocity * 2);

      // 方案 3: 完全移除終端速度限制，讓紙球自然加速下落
      // _velocity += gravity * dt * 60;
      // 不限制終端速度

      // 更新旋轉
      angle += _rotationSpeed * dt;

      // Update position
      position.y += _velocity * dt;

      // Update state based on velocity
      if (_velocity < 0) {
        _state = PaperBallState.rising;
      } else {
        _state = PaperBallState.falling;
      }

      // Check if the paper ball has returned to its target landing position
      if (_state == PaperBallState.falling && position.y >= _targetLandingY) {
        position.y = _targetLandingY;
        _velocity = 0;
        _state = PaperBallState.idle;
        _rotationSpeed = 0; // 停止旋轉
        // 不再重置角度，保持旋轉後的角度
      }
    }
  }
}
