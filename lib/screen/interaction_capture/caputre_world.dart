import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flame/input.dart';
import 'package:flutter/animation.dart';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:work_on_time_game/components/animal/penguin.dart';
import 'package:work_on_time_game/components/background/endless_background.dart';
import 'package:work_on_time_game/components/camera/framing_crosshair.dart';
import 'package:work_on_time_game/components/character/attribute_meter.dart';
import 'package:work_on_time_game/components/common/button.dart';
import 'package:work_on_time_game/components/common/dialog.dart';
import 'package:work_on_time_game/components/photo_instax.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'package:work_on_time_game/components/event/event_result_dialog.dart';
import 'package:work_on_time_game/models/event_data.dart';

class InteractionCaptureWorld extends World
    with HasGameReference<WOTGame>, HasCollisionDetection, TapCallbacks {
  // common
  late final EndlessBackground _bg;
  late final ButtonComponent _okButton;

  // 第一階段 拍照元件
  SnapshotComponent? _snapshotComponent;
  late final FramingCrosshair _framingCrosshair;
  late final SpriteComponent _movingPenguin;
  late final TimerComponent _penguinRandomPositionTimerComponent;
  Vector2 _penguinNextRandomPosition = Vector2(0, 0);

  // 第二階段 顯示拍照結果元件
  late final NewTag _newTag;
  late final PhotoInstax _photoInstax;
  late final FinishBanner _finishBanner;

  // 第三階段 顯示事件結果元件
  late final Dialog _dialog;
  late final EventResultDialog _eventResultDialog;
  late final AttributeMeter _attributeMeter;

  // state
  bool _canCapture = true;

  // 未來換不同動物可能取名就跟著改？
  void _updatePenguinRandomPosition() {
    // Generate new random position

    _penguinNextRandomPosition = Vector2(
      -150 + (600) * Random().nextDouble(),
      -150 + (600) * Random().nextDouble(),
    );

    // Create a MoveToEffect that takes exactly 2 seconds
    final moveEffect = MoveToEffect(
      _penguinNextRandomPosition,
      EffectController(duration: 1, curve: Curves.easeOut),
    );

    // Remove any existing move effects and add the new one
    _movingPenguin.removeWhere((component) => component is MoveToEffect);
    _movingPenguin.add(moveEffect);

    // _framingCrosshair.position = _movingPenguin.position + Vector2(150, 600);

    final frameMoveEffect = MoveToEffect(
      _penguinNextRandomPosition +
          Vector2(100 + Random().nextInt(50).toDouble(),
              550 + Random().nextInt(50).toDouble()),
      EffectController(
          duration: 1.5, curve: Curves.decelerate, startDelay: 0.5),
    );

    _framingCrosshair.removeWhere((component) => component is MoveToEffect);
    _framingCrosshair.add(frameMoveEffect);
  }

  void _seeResult() {
    _okButton.onPressed = null;
    // remove phase 2
    remove(_newTag);
    remove(_photoInstax);
    remove(_finishBanner);

    // add phase 3
    add(_dialog);
    add(_eventResultDialog);
    add(_attributeMeter);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // common
    final image = await game.images.load(images.greenDotBackground);
    _bg = EndlessBackground(image: image);
    _okButton = ButtonComponent(
      size: Vector2(570, 90),
      position: Vector2(109, 1531),
      button: Button(
        size: Vector2(570, 90),
        text: "ＯＫ",
      ),
    );

    // 第一階段 拍照元件
    _framingCrosshair = FramingCrosshair();
    _movingPenguin = Penguin();
    _penguinRandomPositionTimerComponent = TimerComponent(
      period: 2,
      onTick: _updatePenguinRandomPosition,
      repeat: true,
    );

    // 第二階段 顯示拍照結果元件
    _newTag = NewTag();
    _photoInstax = PhotoInstax(
        subjectBuilder: (size) => Penguin(withHitbox: false)..size = size);
    _photoInstax.anchor = Anchor.topLeft;
    _photoInstax.position = Vector2(60, 243);

    _finishBanner = FinishBanner();
    _finishBanner.anchor = Anchor.topLeft;
    _finishBanner.position = Vector2(0, 1258);

    // 第三階段 顯示事件結果元件
    _dialog = Dialog.title(
      title: "事件結算",
      size: Vector2(657, 100),
      position: Vector2(62, 112),
    );

    // Create result data for the event
    final resultData = ResultData(
      title: "企鵝幫忙",
      description: "真是太好了 ...",
    );

    // Create effect data for mind status increase
    final appliedEffects = [
      EffectData(
        type: 'character_status',
        status: 'mind',
        delta: 10, // Positive delta for increase
      ),
    ];

    _eventResultDialog = EventResultDialog(
      result: resultData,
      appliedEffects: appliedEffects,
      position: Vector2(0, 639),
    );

    _attributeMeter = AttributeMeter(
      attributeName: "自信",
      value: 0.5,
      position: Vector2(350, 1008),
    );
  }

  @override
  void onMount() {
    super.onMount();
    debugMode = true;
    _canCapture = true;
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.zoom = 1;
    add(_bg);

    // 第一階段 拍照元件
    _movingPenguin.position = Vector2(1000, 1000);
    _movingPenguin.anchor = Anchor.center;

    _snapshotComponent = SnapshotComponent()
      ..anchor = Anchor.center
      ..size = Vector2(300, 300)
      ..position = Vector2(game.size.x / 2, game.size.y / 2)
      ..add(_movingPenguin);

    _framingCrosshair.position = Vector2(
      -500,
      -500,
    );

    add(_snapshotComponent!);
    add(_penguinRandomPositionTimerComponent);
    add(_framingCrosshair);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (!_canCapture) return;
    _canCapture = false;

    // 截圖ㄉ 之後可以拿來顯示玩家拍到什麼
    // _snapshotComponent.takeSnapshot();
    // final image = _snapshotComponent.snapshotAsImage(
    //   300,
    //   300,
    // );
    // final imageContainer = RectangleComponent();
    // imageContainer.paint = Paint()..color = const Color(0xFFFFFFFF);
    // imageContainer.size = Vector2(300, 300);
    // final imageComponent = SpriteComponent.fromImage(image);
    // imageContainer.add(imageComponent);
    // imageContainer.position = Vector2(100, 1200);
    // add(imageContainer);

    // remove 拍照元素
    remove(_framingCrosshair);
    remove(_snapshotComponent!);
    remove(_penguinRandomPositionTimerComponent);

    // 閃白
    add(
      FlashEffect(
        onComplete: () {
          add(_newTag);
          add(_photoInstax);
          add(_finishBanner);
          _okButton.onPressed = () {
            _seeResult();
          };
          add(_okButton);
        },
      ),
    );
  }
}

// temp 暫時放在這裡
class SnapshotComponent extends PositionComponent
    with HasGameReference<WOTGame>, Snapshot {
  SnapshotComponent() {
    renderSnapshot = false;
  }
}

class FlashEffect extends RectangleComponent with HasGameReference<WOTGame> {
  late final VoidCallback onComplete;

  FlashEffect({required this.onComplete}) {
    position = Vector2.zero();
    paint = Paint()..color = const Color(0xFFFFFFFF);
    opacity = 1.0;
  }

  @override
  void onMount() {
    super.onMount();

    size = game.size;

    add(
      SequenceEffect(
        [
          OpacityEffect.to(
              0.0, EffectController(duration: 2.0, startDelay: 0.5)),
          RemoveEffect(),
        ],
        onComplete: onComplete,
      ),
    );
  }
}

class NewTag extends PositionComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Background rectangle
    final background = RectangleComponent(
      size: Vector2(151, 58),
      paint: Paint()..color = const Color(0xFFE9D686),
    )
      ..anchor = Anchor.topLeft
      ..position = Vector2(60, 160);
    add(background);

    // Text component
    final text = TextComponent(
      text: "new",
      textRenderer: TextPaint(
        style: typography.tp48.withColor(Color(0xFFFFFFFF)),
      ),
    );
    text.anchor = Anchor.center;
    text.position =
        Vector2(60 + 151 / 2, 160 + 58 / 2); // Center text on background
    add(text);
  }
}

class FinishBanner extends PositionComponent with HasGameReference<WOTGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // full width, 157 height, bg #BE936B
    // with "完成拍照" tp64 color white

    position = Vector2(0, 1258);

    final background = RectangleComponent(
      size: Vector2(game.size.x, 157),
      paint: Paint()..color = const Color(0xFFBE936B),
    )
      ..anchor = Anchor.topLeft
      ..position = Vector2(0, 0);
    add(background);

    final text = TextComponent(
      text: "完成拍照",
      textRenderer: TextPaint(
        style: typography.tp64.withColor(Color(0xFFFFFFFF)),
      ),
    );
    text.anchor = Anchor.center;
    text.position = Vector2(game.size.x / 2, 157 / 2);
    add(text);
  }
}
