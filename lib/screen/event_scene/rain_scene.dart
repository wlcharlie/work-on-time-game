import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/components/common/button.dart';
import 'package:work_on_time_game/components/common/dialog.dart';
import 'package:work_on_time_game/components/character/status_meters.dart';
import 'package:work_on_time_game/components/scene/base_scene.dart';
import 'package:work_on_time_game/components/scene/scene_element.dart';
import 'package:work_on_time_game/config/audio.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/enums/character_status.dart';
import 'package:work_on_time_game/models/effect_character_status.dart';
import 'package:work_on_time_game/providers/character_status.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'package:flame_audio/flame_audio.dart';

// 雨滴场景状态枚举
enum RainSceneState {
  waitingToStart, // 等待开始
  showingDialog, // 显示对话框
  completed, // 场景完成
}

class RainScene extends BaseScene {
  // 场景状态 - 暂时保留，可能后续会用到
  // RainSceneState _rainSceneState = RainSceneState.waitingToStart;

  // 選項Dialog
  WithoutUmbrellaScene? withoutUmbrellaScene;

  // 是否正在下雨
  bool _rainVisible = false;

  // 用于追踪和取消延时任务
  Timer? _switchSceneTimer;

  late final AudioPlayer _rainAudioPlayer;

  // 位置引用
  late final Vector2 eventRightStartPosition;
  late final Vector2 eventRightTargetPosition;
  late final Vector2 eventLeftStartPosition;
  late final Vector2 eventLeftTargetPosition;
  late final Vector2 characterPosition;
  late final Vector2 backgroundSize;

  @override
  List<SceneElement> defineSceneElements() {
    return [
      // 背景
      SceneElement.background(
        imagePath: images.rainSceneBackground,
        position: Vector2.zero(),
      ),
      // 右侧事件
      SceneElement.event(
        id: 'eventRight',
        imagePath: images.rainSceneEventRight,
        position: eventRightStartPosition,
        animations: [
          SceneAnimation.slideIn(
            startPosition: eventRightStartPosition,
            targetPosition: eventRightTargetPosition,
            duration: 1.5,
          ),
          SceneAnimation.fadeOut(
            delay: 4.0,
            duration: 1.0,
          ),
        ],
      ),
      // 左侧事件
      SceneElement.event(
        id: 'eventLeft',
        imagePath: images.rainSceneEventLeft,
        position: eventLeftStartPosition,
        animations: [
          SceneAnimation.slideIn(
            startPosition: eventLeftStartPosition,
            targetPosition: eventLeftTargetPosition,
            duration: 1.5,
            delay: 2.5,
          ),
          SceneAnimation.fadeOut(
            delay: 4.0,
            duration: 1.0,
          ),
        ],
      ),

      // 雨滴1
      SceneElement.effect(
        id: 'rainDrop01',
        imagePath: images.rainSceneRainDrop01,
        position: Vector2.zero(),
        opacity: 0.0,
        animations: [
          SceneAnimation.fadeIn(
            delay: 5.0,
            duration: 1.0,
            onStart: () {
              // 雨滴动画开始时播放音频
              _rainVisible = true;
              _rainAudioPlayer.resume();
            },
          ),
          SceneAnimation.moveLoop(
            moveDistance: Vector2(0, 150.0),
            duration: 1.2,
            delay: 5.0,
            resetPosition: Vector2.zero(),
          ),
        ],
      ),
      // 雨滴2
      SceneElement.effect(
        id: 'rainDrop02',
        imagePath: images.rainSceneRainDrop02,
        position: Vector2.zero(),
        opacity: 0.0,
        animations: [
          SceneAnimation.fadeIn(
            delay: 5.0,
            duration: 1.5,
          ),
          SceneAnimation.moveLoop(
            moveDistance: Vector2(0, 200.0),
            duration: 0.8,
            delay: 5.0,
            resetPosition: Vector2.zero(),
          ),
        ],
      ),
      // 雨滴3
      SceneElement.effect(
        id: 'rainDrop03',
        imagePath: images.rainSceneRainDrop03,
        position: Vector2.zero(),
        opacity: 0.0,
        animations: [
          SceneAnimation.fadeIn(
            delay: 5.0,
            duration: 1.8,
          ),
          SceneAnimation.moveLoop(
            moveDistance: Vector2(0, 180.0),
            duration: 1.0,
            delay: 5.0,
            resetPosition: Vector2.zero(),
          ),
        ],
      ),
      // 雨滴4
      SceneElement.effect(
        id: 'rainDrop04',
        imagePath: images.rainSceneRainDrop04,
        position: Vector2.zero(),
        opacity: 0.0,
        animations: [
          SceneAnimation.opacityLoop(
            delay: 5.0,
            duration: 2.6,
          ),
        ],
      ),

      // 角色
      SceneElement.character(
        imagePath: images.rainSceneCharacter,
        position: characterPosition,
      ),
    ];
  }

  @override
  void onSceneCompleted() {
    super.onSceneCompleted();
    // 场景完成，音频已经在雨滴动画开始时播放

    // 3.5秒后显示对话框
    _switchSceneTimer = Timer(3.5, onTick: () {
      add(withoutUmbrellaScene = WithoutUmbrellaScene());
    });
  }

  /// 重置场景到初始状态，用于重播功能
  @override
  void reset() {
    super.reset();

    // 重置雨滴场景特有的状态
    _rainVisible = false;

    // 停止音频
    _rainAudioPlayer.pause();

    // 取消定时器
    _switchSceneTimer?.stop();
    _switchSceneTimer = null;

    // 重置对话框
    _resetWithoutUmbrellaScene();
  }

  /// 重播场景 - 重置后立即开始播放
  @override
  void replay() {
    reset();
    super.replay();
  }

  /// 简单清理 WithoutUmbrellaScene - 直接置空，下次创建新实例
  void _resetWithoutUmbrellaScene() {
    // 移除现有的 withoutUmbrellaScene（如果存在）
    if (withoutUmbrellaScene != null &&
        children.contains(withoutUmbrellaScene!)) {
      remove(withoutUmbrellaScene!);
    }

    // 直接置空，下次需要时会创建全新实例
    withoutUmbrellaScene = null;
  }

  @override
  Future<void> onLoad() async {
    // 初始化音频播放器
    _rainAudioPlayer = await FlameAudio.loop(audio.rain);
    _rainAudioPlayer.pause();

    // 预加载图片以获取尺寸信息
    final bgImage = await Flame.images.load(images.rainSceneBackground);
    final eventRightImage = await Flame.images.load(images.rainSceneEventRight);
    final eventLeftImage = await Flame.images.load(images.rainSceneEventLeft);
    final characterImage = await Flame.images.load(images.rainSceneCharacter);

    // 计算位置
    backgroundSize =
        Vector2(bgImage.width.toDouble(), bgImage.height.toDouble());
    eventRightTargetPosition =
        Vector2(bgImage.width - eventRightImage.width.toDouble(), 130);
    eventRightStartPosition = Vector2(bgImage.width.toDouble(), 130);
    eventLeftTargetPosition = Vector2(0, 375);
    eventLeftStartPosition = Vector2(-eventLeftImage.width.toDouble(), 375);
    characterPosition =
        Vector2(156, bgImage.height - characterImage.height.toDouble());

    // 调用父类的onLoad，这会触发场景元素的加载
    await super.onLoad();

    // 开发用的重置按钮
    ButtonComponent resetButton = ButtonComponent(
      priority: 99999,
      size: Vector2(100, 100),
      position: Vector2(100, 100),
      button: TextComponent(
        text: 'replay',
      ),
      onPressed: () {
        replay();
      },
    );

    add(resetButton);
  }

  @override
  void onMount() async {
    super.onMount();
    // 倍數
    // game.camera.viewfinder.zoom = 0.5;
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.moveTo(Vector2(0, 0));

    if (_rainVisible) {
      _rainAudioPlayer.resume();
    }
  }

  @override
  void updateScene(double dt) {
    super.updateScene(dt);

    // 更新场景完成计时器
    if (_switchSceneTimer?.isRunning() == true) {
      _switchSceneTimer!.update(dt);
    }
  }

  @override
  void onRemove() {
    _rainAudioPlayer.pause();

    // 清理所有计时器
    _switchSceneTimer?.stop();

    super.onRemove();
  }
}

class WithoutUmbrellaScene extends Component with HasGameReference<WOTGame> {
  late final SpriteComponent withoutUmbrellaBg;
  late final PositionComponent withoutUmbrellaDialog;
  late final TextComponent titleComponent;

  late ResultDialog resultDialog;

  /// 重置 WithoutUmbrellaScene 到初始状态
  void reset() {
    // 移除 resultDialog 如果存在
    if (children.contains(resultDialog)) {
      resultDialog.reset();
      remove(resultDialog);
    }

    // 重新添加 withoutUmbrellaDialog 如果不存在
    if (!children.contains(withoutUmbrellaDialog)) {
      add(withoutUmbrellaDialog);
    }

    // 重新创建 resultDialog 实例以确保完全干净的状态
    resultDialog = ResultDialog();
  }

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

  /// 重置 ResultDialog 到初始状态
  void reset() {
    _choice = '';

    // 移除 resultDialog 如果存在
    if (children.contains(resultDialog)) {
      remove(resultDialog);
    }
  }

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
