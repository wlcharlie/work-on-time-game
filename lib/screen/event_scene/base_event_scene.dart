import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:work_on_time_game/components/scene/base_scene.dart';
import 'package:work_on_time_game/components/scene/scene_element.dart';
import 'package:work_on_time_game/components/event/event_flow_controller.dart';
import 'package:work_on_time_game/components/event/event_dialog.dart';
import 'package:work_on_time_game/components/event/event_result_dialog.dart';
import 'package:work_on_time_game/models/event_data.dart';
import 'package:work_on_time_game/enums/character_status.dart';
import 'package:work_on_time_game/providers/character_status.dart';

/// 基礎事件場景類，提供通用的事件處理功能
abstract class BaseEventScene extends BaseScene with RiverpodComponentMixin {
  // 使用默認背景
  @override
  bool get useDefaultBackground => true;

  // Event system components
  EventFlowController? eventController;
  EventDialog? eventDialog;

  // 用於追蹤和取消延時任務
  TimerComponent? _switchSceneTimer;

  // 子類需要提供的配置
  String get eventDataPath;
  String get sceneName;

  @override
  List<SceneElement> defineSceneElements() {
    // 使用默認背景，不需要定義額外的場景元素
    return [];
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // 場景動畫完成後顯示事件對話框
    add(TimerComponent(
      period: 1.0,
      repeat: false,
      onTick: () {
        _loadAndShowEvent();
      },
    ));
  }

  @override
  void onSceneCompleted() {
    // 啟動場景切換計時器
    _switchSceneTimer = TimerComponent(
      period: 2.0,
      repeat: false,
      onTick: () {
        game.router.pushNamed('lobby');
      },
    );
    add(_switchSceneTimer!);
  }

  /// 重置場景到初始狀態，用於重播功能
  @override
  void reset() {
    super.reset();

    // 移除定時器
    if (_switchSceneTimer != null) {
      _switchSceneTimer!.removeFromParent();
      _switchSceneTimer = null;
    }

    // 重置事件對話框
    _resetEventDialog();
  }

  /// 重播場景 - 重置後立即開始播放
  @override
  void replay() {
    reset();
    super.replay();
  }

  /// 簡單清理 EventDialog - 直接置空，下次創建新實例
  void _resetEventDialog() {
    // 移除現有的 eventDialog（如果存在）
    if (eventDialog != null && children.contains(eventDialog!)) {
      remove(eventDialog!);
    }

    // 移除現有的 eventController（如果存在）
    if (eventController != null && children.contains(eventController!)) {
      remove(eventController!);
    }

    // 直接置空，下次需要時會創建全新實例
    eventDialog = null;
    eventController = null;
  }

  /// 加載和顯示事件
  Future<void> _loadAndShowEvent() async {
    try {
      // 加載事件JSON數據
      final String jsonString = await rootBundle.loadString(eventDataPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final EventData eventData = EventData.fromJson(jsonData);

      // 創建事件控制器
      eventController = EventFlowController(
        eventData: eventData,
        ref: ref,
        onEventCompleted: (result, appliedEffects) {
          _showFinalResult(result, appliedEffects);
        },
        onStepChanged: () {
          _updateEventDialog();
        },
      );
      add(eventController!);

      // 顯示初始對話框
      _updateEventDialog();
    } catch (e) {
      print('Error loading $sceneName event: $e');
    }
  }

  /// 更新事件對話框
  void _updateEventDialog() {
    // 移除現有對話框
    if (eventDialog != null && children.contains(eventDialog!)) {
      remove(eventDialog!);
    }

    if (eventController == null) return;

    // 創建新對話框
    eventDialog = EventDialog(
      text: eventController!.currentStep.text,
      choices: eventController!.getVisibleChoices(),
      onChoiceSelected: (choice) {
        eventController!.selectChoice(choice);
      },
      isChoiceAvailable: (choice) {
        return eventController!.isChoiceAvailable(choice);
      },
      getDisabledText: (choice) {
        return choice.availability.disabledText ?? choice.text;
      },
    );

    add(eventDialog!);
  }

  /// 顯示最終結果
  void _showFinalResult(ResultData result, List<EffectData> appliedEffects) {
    // 移除事件對話框
    if (eventDialog != null && children.contains(eventDialog!)) {
      remove(eventDialog!);
    }

    // 應用效果到角色狀態
    _applyEffectsToCharacterStatus(appliedEffects);

    // 顯示結果對話框
    final resultDialog = EventResultDialog(
      result: result,
      appliedEffects: appliedEffects,
    );

    add(resultDialog);
  }

  /// 應用效果到角色狀態
  void _applyEffectsToCharacterStatus(List<EffectData> effects) {
    final characterStatusNotifier = ref.read(characterStatusNotifierProvider.notifier);
    
    for (final effect in effects) {
      if (effect.type == 'character_status') {
        final statusType = CharacterStatus.values.firstWhere(
          (type) => type.name == effect.status,
        );
        characterStatusNotifier.effectCharacterStatus(statusType, effect.delta ?? 0);
      }
    }
  }

  @override
  void onRemove() {
    // 清理定時器
    if (_switchSceneTimer != null) {
      _switchSceneTimer!.removeFromParent();
      _switchSceneTimer = null;
    }

    super.onRemove();
  }
}