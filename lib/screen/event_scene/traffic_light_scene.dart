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

/// 红绿灯倒数事件场景
class TrafficLightScene extends BaseScene with RiverpodComponentMixin {
  // 使用默认背景
  @override
  bool get useDefaultBackground => true;

  // Event system components
  EventFlowController? eventController;
  EventDialog? eventDialog;

  // 用于追踪和取消延时任务
  TimerComponent? _switchSceneTimer;

  @override
  List<SceneElement> defineSceneElements() {
    // 使用默认背景，不需要定义额外的场景元素
    return [];
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // 场景动画完成后显示事件对话框
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
    // 启动场景切换计时器
    _switchSceneTimer = TimerComponent(
      period: 2.0,
      repeat: false,
      onTick: () {
        game.router.pushNamed('lobby');
      },
    );
    add(_switchSceneTimer!);
  }

  /// 重置场景到初始状态，用于重播功能
  @override
  void reset() {
    super.reset();

    // 移除定时器
    if (_switchSceneTimer != null) {
      _switchSceneTimer!.removeFromParent();
      _switchSceneTimer = null;
    }

    // 重置事件对话框
    _resetEventDialog();
  }

  /// 重播场景 - 重置后立即开始播放
  @override
  void replay() {
    reset();
    super.replay();
  }

  /// 简单清理 EventDialog - 直接置空，下次创建新实例
  void _resetEventDialog() {
    // 移除现有的 eventDialog（如果存在）
    if (eventDialog != null && children.contains(eventDialog!)) {
      remove(eventDialog!);
    }

    // 移除现有的 eventController（如果存在）
    if (eventController != null && children.contains(eventController!)) {
      remove(eventController!);
    }

    // 直接置空，下次需要时会创建全新实例
    eventDialog = null;
    eventController = null;
  }

  /// 加载和显示事件
  Future<void> _loadAndShowEvent() async {
    try {
      // 加载事件JSON数据
      final String jsonString = await rootBundle.loadString(
        'assets/data/traffic_light_event.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final EventData eventData = EventData.fromJson(jsonData);

      // 创建事件控制器
      eventController = EventFlowController(
        eventData: eventData,
        onEventCompleted: (result, appliedEffects) {
          _showFinalResult(result, appliedEffects);
        },
        onStepChanged: () {
          _updateEventDialog();
        },
      );
      add(eventController!);

      // 显示初始对话框
      _updateEventDialog();
    } catch (e) {
      print('Error loading traffic light event: $e');
    }
  }

  /// 更新事件对话框
  void _updateEventDialog() {
    // 移除现有对话框
    if (eventDialog != null && children.contains(eventDialog!)) {
      remove(eventDialog!);
    }

    if (eventController == null) return;

    // 创建新对话框
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

  /// 显示最终结果
  void _showFinalResult(ResultData result, List<EffectData> appliedEffects) {
    // 移除事件对话框
    if (eventDialog != null && children.contains(eventDialog!)) {
      remove(eventDialog!);
    }

    // 应用效果到角色状态
    _applyEffectsToCharacterStatus(appliedEffects);

    // 显示结果对话框
    final resultDialog = EventResultDialog(
      result: result,
      appliedEffects: appliedEffects,
    );

    add(resultDialog);
  }

  /// 应用效果到角色状态
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
    // 清理定时器
    if (_switchSceneTimer != null) {
      _switchSceneTimer!.removeFromParent();
      _switchSceneTimer = null;
    }

    super.onRemove();
  }
}