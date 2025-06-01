import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/animation.dart'; // 导入Flutter的animation包来使用Curves
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/components/common/button.dart';
import 'package:work_on_time_game/components/common/dialog.dart';
import 'package:work_on_time_game/components/character_status/status_meters.dart';
import 'package:work_on_time_game/config/audio.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/enums/character_status.dart';
import 'package:work_on_time_game/models/effect_character_status.dart';
import 'package:work_on_time_game/providers/character_status.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'package:flame_audio/flame_audio.dart';

// 场景状态枚举
enum RainSceneState {
  initial, // 初始状态
  rightEntering, // 右侧事件正在进入
  waitForLeft, // 等待左侧事件进入
  leftEntering, // 左侧事件正在进入
  allEntered, // 所有事件都已进入
  eventsFadingOut, // 事件正在淡出
  rainingStarted, // 开始下雨效果
  idle, // 雨滴空閒
}

/// TODO: reset 待補，可能動畫需要獨立存起來操作？

class RainScene extends Component with HasGameReference<WOTGame> {
  // 场景当前状态
  RainSceneState _sceneState = RainSceneState.initial;

  double sceneDuration = 0;

  // 计时器，用于状态间的延迟
  double _stateTimer = 0;

  // 组件引用
  late final SpriteComponent eventRight;
  late final SpriteComponent eventLeft;
  late final SpriteComponent rainDrop01;
  late final SpriteComponent rainDrop02;
  late final SpriteComponent rainDrop03;
  late final SpriteComponent rainDrop04;
  late final SpriteComponent bg;
  late final SpriteComponent character;

  // 位置引用
  late final Vector2 eventRightStartPosition;
  late final Vector2 eventRightTargetPosition;
  late final Vector2 eventLeftStartPosition;
  late final Vector2 eventLeftTargetPosition;

  // 選項Dialog
  late final WithoutUmbrellaScene withoutUmbrellaScene;

  // 雨滴一开始应该是不可见的
  bool _rainVisible = false;

  // 是否出門有帶傘
  bool _bringUmbrella = false;

  // 是否顯示過沒帶傘的流程
  bool _showWithoutUmbrellaBranch = false;

  late final AudioPlayer _rainAudioPlayer;

  /// 触发右侧事件的滑入动画
  void _triggerEventRightAnimation() {
    _addSlideInEffect(
      eventRight,
      eventRightStartPosition,
      eventRightTargetPosition,
      1.5, // 持續1.5秒
    );
  }

  /// 触发左侧事件的滑入动画
  void _triggerEventLeftAnimation() {
    _addSlideInEffect(
      eventLeft,
      eventLeftStartPosition,
      eventLeftTargetPosition,
      1.5, // 持续1.5秒
    );
  }

  /// 设置雨滴04的渐变效果
  void _setupRainDrop04Effect() {
    final fadeInDuration = 0.1; // 0.1秒渐入
    final fadeOutDuration = 2.5; // 2.5秒渐出

    // 渐入渐出的无限循环效果
    rainDrop04.add(
      SequenceEffect(
        [
          OpacityEffect.to(1.0, EffectController(duration: fadeInDuration)),
          OpacityEffect.to(0, EffectController(duration: fadeOutDuration)),
        ],
        infinite: true,
      ),
    );
  }

  /// 为雨滴设置下落和淡出效果
  ///
  /// [component] 要添加效果的组件
  /// [duration] 动画持续时间（秒）
  /// [moveDistance] 向下移动的距离
  void _setupRainDropEffect(
      SpriteComponent component, double duration, double moveDistance) {
    // 移动效果
    component.add(
      MoveEffect.by(
        Vector2(0, moveDistance),
        EffectController(
          duration: duration,
          onMax: () {
            // 当效果结束时，重置位置
            component.position = Vector2.zero();
          },
          infinite: true,
        ),
      ),
    );

    // 透明度效果
    component.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: duration,
          onMax: () {
            // 当效果结束时，重置透明度
            component.opacity = 1.0;
          },
          infinite: true,
        ),
      ),
    );
  }

  /// 添加滑入效果
  ///
  /// [component] 要添加效果的组件
  /// [startPosition] 开始位置
  /// [targetPosition] 目标位置
  /// [duration] 动画持续时间（秒）
  void _addSlideInEffect(
    SpriteComponent component,
    Vector2 startPosition,
    Vector2 targetPosition,
    double duration,
  ) {
    // 移动到目标位置的效果
    component.add(
      MoveToEffect(
        targetPosition,
        EffectController(
          duration: duration,
          curve: Curves.easeOutCubic, // 使用缓动函数让动画更自然
        ),
      ),
    );
  }

  /// 触发事件淡出动画
  void _triggerEventsFadeOut() {
    // 添加淡出效果到两个事件元素
    eventRight.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 1.0,
        ),
      ),
    );

    eventLeft.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 1.0,
        ),
      ),
    );
  }

  /// 开始下雨效果
  void _startRainEffects() {
    _rainAudioPlayer.resume();
    // 为雨滴添加淡入效果
    _setupRainDropEffect(
      rainDrop01,
      1.2,
      150.0,
    );
    rainDrop01.add(
      OpacityEffect.to(
        1.0,
        EffectController(
          duration: 1,
          curve: Curves.easeIn,
        ),
      ),
    );

    _setupRainDropEffect(
      rainDrop02,
      0.8,
      200.0,
    );
    rainDrop02.add(
      OpacityEffect.to(
        1.0,
        EffectController(
          duration: 1.5,
          curve: Curves.easeIn,
        ),
      ),
    );

    _setupRainDropEffect(
      rainDrop03,
      1.0,
      180.0,
    );
    rainDrop03.add(
      OpacityEffect.to(
        1.0,
        EffectController(
          duration: 1.8,
          curve: Curves.easeIn,
        ),
      ),
    );

    _setupRainDrop04Effect();

    Future.delayed(Duration(seconds: 3, milliseconds: 500), () {
      _sceneState = RainSceneState.allEntered;
    });
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // // 要直接對音檔進行淡入淡出，就不由程式碼控制音量...
    _rainAudioPlayer = await FlameAudio.loop(audio.rain);
    _rainAudioPlayer.pause();

    final bgImage = await Flame.images.load(images.rainSceneBackground);
    final eventRightImage = await Flame.images.load(images.rainSceneEventRight);
    final eventLeftImage = await Flame.images.load(images.rainSceneEventLeft);
    final characterImage = await Flame.images.load(images.rainSceneCharacter);
    final rainDrop01Image = await Flame.images.load(images.rainSceneRainDrop01);
    final rainDrop02Image = await Flame.images.load(images.rainSceneRainDrop02);
    final rainDrop03Image = await Flame.images.load(images.rainSceneRainDrop03);
    final rainDrop04Image = await Flame.images.load(images.rainSceneRainDrop04);

    bg = SpriteComponent.fromImage(bgImage);

    // 設置eventRight的初始位置和目標位置（在畫面外）
    eventRightTargetPosition =
        Vector2(0.0 + bgImage.width - eventRightImage.width, 130);
    eventRightStartPosition =
        Vector2(bgImage.width.toDouble(), 130); // 開始時在畫面右側外

    eventRight = SpriteComponent.fromImage(
      eventRightImage,
      position: eventRightStartPosition.clone(), // 設置初始位置在畫面外
    );

    // 設置eventLeft的初始位置和目標位置
    eventLeftTargetPosition = Vector2(0, 375);
    eventLeftStartPosition =
        Vector2(-eventLeftImage.width.toDouble(), 375); // 開始時在畫面左側外

    eventLeft = SpriteComponent.fromImage(
      eventLeftImage,
      position: eventLeftStartPosition.clone(), // 設置初始位置在畫面外
    );

    // 创建雨滴组件，但先不添加效果
    rainDrop01 = SpriteComponent.fromImage(
      rainDrop01Image,
      position: Vector2.zero(),
    )..opacity = 0; // 初始时不可见

    rainDrop02 = SpriteComponent.fromImage(
      rainDrop02Image,
      position: Vector2.zero(),
    )..opacity = 0; // 初始时不可见

    rainDrop03 = SpriteComponent.fromImage(
      rainDrop03Image,
      position: Vector2.zero(),
    )..opacity = 0; // 初始时不可见

    rainDrop04 = SpriteComponent.fromImage(
      rainDrop04Image,
      position: Vector2.zero(),
    )..opacity = 0; // 初始时不可见

    // 设置角色位置在屏幕底部中央
    character = SpriteComponent.fromImage(
      characterImage,
      position: Vector2(156, 0.0 + bgImage.height - characterImage.height),
    );

    withoutUmbrellaScene = WithoutUmbrellaScene();

    add(bg);
    add(rainDrop01);
    add(rainDrop02);
    add(rainDrop03);
    add(rainDrop04);
    add(character);
    add(eventRight);
    add(eventLeft);

    // 初始化完成后设置为初始状态
    _sceneState = RainSceneState.initial;
    print('RainScene:onLoad: $_sceneState');
  }

  @override
  void onMount() async {
    print('RainScene:onMount');
    print('_sceneState: $_sceneState');
    super.onMount();
    // 倍數
    game.camera.viewfinder.zoom = 0.5;
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.moveTo(Vector2(0, 0));

    if (_rainVisible) {
      _rainAudioPlayer.resume();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 根据当前状态执行不同的逻辑
    switch (_sceneState) {
      case RainSceneState.initial:
        // 初始状态，立即触发右侧事件滑入
        _triggerEventRightAnimation();
        _sceneState = RainSceneState.rightEntering;
        _stateTimer = 0;
        break;

      case RainSceneState.rightEntering:
        // 右侧事件正在进入，等待1.5秒
        _stateTimer += dt;
        if (_stateTimer >= 1.5) {
          _sceneState = RainSceneState.waitForLeft;
          _stateTimer = 0;
        }
        break;

      case RainSceneState.waitForLeft:
        // 等待1秒后触发左侧事件滑入
        _stateTimer += dt;
        if (_stateTimer >= 1.0) {
          _triggerEventLeftAnimation();
          _sceneState = RainSceneState.leftEntering;
          _stateTimer = 0;
        }
        break;

      case RainSceneState.leftEntering:
        // 左侧事件正在进入，等待1.5秒
        _stateTimer += dt;
        if (_stateTimer >= 1.5) {
          // 两边都进入完成，转到淡出状态
          _sceneState = RainSceneState.eventsFadingOut;
          _triggerEventsFadeOut();
          _stateTimer = 0;
        }
        break;

      case RainSceneState.eventsFadingOut:
        // 事件正在淡出，等待1秒
        _stateTimer += dt;
        if (_stateTimer >= 1.0) {
          // 事件淡出完成，开始下雨
          _sceneState = RainSceneState.rainingStarted;
          _startRainEffects();
        }
        break;

      case RainSceneState.rainingStarted:
        _rainVisible = true;
        break;
      case RainSceneState.allEntered:
        _sceneState = RainSceneState.idle;
        break;
      default:
        break;
    }

    if (_sceneState == RainSceneState.idle &&
        !_bringUmbrella &&
        !_showWithoutUmbrellaBranch) {
      _showWithoutUmbrellaBranch = true;
      add(withoutUmbrellaScene);
    }
  }

  @override
  void onRemove() {
    print('RainScene:onRemove');
    _rainAudioPlayer.pause();
    super.onRemove();
  }
}

class WithoutUmbrellaScene extends Component with HasGameReference<WOTGame> {
  late final SpriteComponent withoutUmbrellaBg;
  late final PositionComponent withoutUmbrellaDialog;
  late final TextComponent titleComponent;

  late final ResultDialog resultDialog;

  void _handleChoice(String choice) {
    resultDialog.choice = choice;
    add(resultDialog);
    remove(withoutUmbrellaDialog);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final withoutUmbrellaBgImage =
        await Flame.images.load(images.rainSceneResultWithoutUmbrella);

    withoutUmbrellaBg = SpriteComponent.fromImage(
      withoutUmbrellaBgImage,
      position: Vector2.zero(),
    );

    titleComponent = TextBoxComponent(
      text: '天空突然下起了傾盆大雨',
      position: Vector2(0, 35),
      align: Anchor.center,
      boxConfig: TextBoxConfig(
        margins: EdgeInsets.zero,
        maxWidth: 330,
      ),
      textRenderer: TextPaint(
        style: typography.tp20
            .withFontWeight(FontWeight.w600)
            .withShadow()
            .copyWith(
              color: const Color(0xFF644C3B),
            ),
      ),
    );

    // 沒帶傘按鈕選項A
    ButtonComponent buttonGoWithoutUmbrella = ButtonComponent(
      size: Vector2(285, 45),
      position: Vector2(22, 86),
      button: Button(
        size: Vector2(285, 45),
        text: '淋雨去公司',
      ),
      onPressed: () {
        print('WithoutUmbrellaScene:buttonGoWithoutUmbrella: onPressed');
        _handleChoice('go');
      },
    );

    // 沒帶傘按鈕選項B
    ButtonComponent buttonBuyUmbrella = ButtonComponent(
      position: Vector2(22, 140),
      size: Vector2(285, 45),
      button: Button(
        size: Vector2(285, 45),
        text: '去超商買傘',
      ),
      onPressed: () {
        print('WithoutUmbrellaScene:buttonBuyUmbrella: onPressed');
        _handleChoice('buy');
      },
    );

    withoutUmbrellaDialog = Dialog(
      size: Vector2(330, 220),
      position: Vector2(64, 1060),
      scale: Vector2.all(2),
      content: [
        titleComponent,
        buttonGoWithoutUmbrella,
        buttonBuyUmbrella,
      ],
    );

    resultDialog = ResultDialog();

    add(withoutUmbrellaBg);
    add(withoutUmbrellaDialog);
  }
}

class ResultDialog extends Component
    with HasGameReference<WOTGame>, RiverpodComponentMixin {
  late final Dialog resultDialog;

  late final Component mindMeter;
  late final Component savingMeter;
  late final Component energyMeter;

  late final TextBoxComponent titleComponent;
  late final TextComponent subTitleComponent;

  String _choice = '';

  ResultDialog();

  set choice(String value) {
    _choice = value;
  }

  String get choiceTitle => switch (_choice) {
        'go' => '淋雨去公司',
        'buy' => '去超商買傘',
        _ => '',
      };

  String get choiceSubTitle => switch (_choice) {
        'go' => '頭髮衣服都濕透了...',
        'buy' => '又花錢買傘了...',
        _ => '',
      };

  List<EffectCharacterStatus> get effectMeters {
    final characterStatusNotifier =
        ref.read(characterStatusNotifierProvider.notifier);
    return switch (_choice) {
      'go' => [
          characterStatusNotifier.effectCharacterStatus(
              CharacterStatus.mind, -10),
          characterStatusNotifier.effectCharacterStatus(
              CharacterStatus.energy, -10),
        ],
      'buy' => [
          characterStatusNotifier.effectCharacterStatus(
              CharacterStatus.mind, -10),
          characterStatusNotifier.effectCharacterStatus(
              CharacterStatus.saving, -10),
        ],
      _ => [],
    };
  }

  @override
  Future<void> onMount() async {
    print('ResultDialog:onLoad');
    super.onMount();

    final firstPoint = Vector2(93, 109);
    final secondPoint = Vector2(167, 109);

    mindMeter = MindStatusMeter(position: Vector2.zero());
    savingMeter = SavingStatusMeter(position: Vector2.zero());
    energyMeter = EnergyStatusMeter(position: Vector2.zero());

    titleComponent = TextBoxComponent(
      text: choiceTitle,
      position: Vector2(0, 35),
      align: Anchor.center,
      boxConfig: TextBoxConfig(
        margins: EdgeInsets.zero,
        maxWidth: 330,
      ),
      textRenderer: TextPaint(
        style: typography.tp20
            .withFontWeight(FontWeight.w600)
            .withShadow()
            .copyWith(
              color: const Color(0xFF644C3B),
            ),
      ),
    );

    subTitleComponent = TextBoxComponent(
      text: choiceSubTitle,
      position: Vector2(0, 70),
      align: Anchor.center,
      boxConfig: TextBoxConfig(
        margins: EdgeInsets.zero,
        maxWidth: 330,
      ),
      textRenderer: TextPaint(
        style: typography.tp16m
            .withFontWeight(FontWeight.w600)
            .withShadow()
            .copyWith(
              color: const Color(0xFF907054),
            ),
      ),
    );

    final meters = effectMeters.mapIndexed((index, effectMeter) {
      Vector2 position = switch (index) {
        0 => firstPoint,
        1 => secondPoint,
        _ => Vector2.zero(),
      };

      return switch (effectMeter.statusType) {
        CharacterStatus.mind => MindStatusMeter(
            position: position, deltaDirection: effectMeter.deltaDirection),
        CharacterStatus.saving => SavingStatusMeter(
            position: position, deltaDirection: effectMeter.deltaDirection),
        CharacterStatus.energy => EnergyStatusMeter(
            position: position, deltaDirection: effectMeter.deltaDirection),
      };
    }).toList();

    resultDialog = Dialog(
      size: Vector2(330, 220),
      position: Vector2(64, 1060),
      scale: Vector2.all(2),
      content: [
        titleComponent,
        subTitleComponent,
        ...meters,
      ],
    );

    add(resultDialog);
  }
}
