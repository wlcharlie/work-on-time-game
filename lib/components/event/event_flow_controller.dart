import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:work_on_time_game/models/event_data.dart';
import 'package:work_on_time_game/enums/character_status.dart';
import 'package:work_on_time_game/providers/character_status.dart';
import 'package:work_on_time_game/providers/inventory.dart';

class EventFlowController extends Component with RiverpodComponentMixin {
  final EventData eventData;
  late String currentStepId;
  final Map<String, FlowStepData> flowSteps = {};
  
  // Callback when event is completed
  final void Function(ResultData result)? onEventCompleted;
  final void Function()? onStepChanged;

  EventFlowController({
    required this.eventData,
    this.onEventCompleted,
    this.onStepChanged,
  }) {
    // Index flow steps by ID for quick lookup
    for (final step in eventData.flow) {
      flowSteps[step.id] = step;
    }
    // Start with first flow step
    currentStepId = eventData.flow.first.id;
  }

  FlowStepData get currentStep => flowSteps[currentStepId]!;

  List<ChoiceData> getVisibleChoices() {
    return currentStep.choices.where((choice) {
      return _checkConditions(choice.visibility.conditions);
    }).toList();
  }

  bool isChoiceAvailable(ChoiceData choice) {
    return _checkConditions(choice.availability.conditions);
  }

  void selectChoice(ChoiceData choice) {
    if (!isChoiceAvailable(choice)) {
      print('Choice ${choice.id} is not available');
      return;
    }

    print('Selected choice: ${choice.id}');

    // Find matching outcome
    final outcome = choice.outcomes.firstWhere(
      (outcome) => _checkConditions(outcome.conditions),
      orElse: () => choice.outcomes.last, // Fallback to last outcome
    );

    print('Applying outcome effects: ${outcome.effects.length} effects');

    // Apply effects
    _applyEffects(outcome.effects);

    // Handle navigation
    if (outcome.goto != null) {
      _navigateToStep(outcome.goto!);
    } else if (outcome.result != null) {
      _showResult(outcome.result!);
    }
  }

  void _navigateToStep(String stepId) {
    if (flowSteps.containsKey(stepId)) {
      print('Navigating to step: $stepId');
      currentStepId = stepId;
      onStepChanged?.call();
    } else {
      print('Warning: Step $stepId not found');
    }
  }

  void _showResult(ResultData result) {
    print('Event completed with result: ${result.title}');
    onEventCompleted?.call(result);
  }

  bool _checkConditions(List<ConditionData> conditions) {
    if (conditions.isEmpty) return true;

    final characterStatus = ref.read(characterStatusNotifierProvider);
    final inventory = ref.read(inventoryNotifierProvider);

    for (final condition in conditions) {
      switch (condition.type) {
        case 'status_min':
          final statusValue = _getCharacterStatusValue(condition.status!, characterStatus);
          if (statusValue < condition.value!) {
            print('Condition failed: ${condition.status} ($statusValue) < ${condition.value}');
            return false;
          }
          break;
        case 'status_max':
          final statusValue = _getCharacterStatusValue(condition.status!, characterStatus);
          if (statusValue > condition.value!) {
            print('Condition failed: ${condition.status} ($statusValue) > ${condition.value}');
            return false;
          }
          break;
        case 'inventory_has':
          if (!inventory.items.contains(condition.item!)) {
            print('Condition failed: missing item ${condition.item}');
            return false;
          }
          break;
        case 'inventory_missing':
          if (inventory.items.contains(condition.item!)) {
            print('Condition failed: has item ${condition.item}');
            return false;
          }
          break;
        case 'random_chance':
          final roll = Random().nextInt(100);
          if (roll > condition.percentage!) {
            print('Condition failed: random roll $roll > ${condition.percentage}');
            return false;
          }
          break;
      }
    }
    return true;
  }

  int _getCharacterStatusValue(String status, Map<CharacterStatus, int> characterStatus) {
    final statusEnum = CharacterStatus.values.firstWhere((e) => e.name == status);
    return characterStatus[statusEnum] ?? 0;
  }

  void _applyEffects(List<EffectData> effects) {
    final characterStatusNotifier = ref.read(characterStatusNotifierProvider.notifier);
    
    for (final effect in effects) {
      switch (effect.type) {
        case 'character_status':
          final statusEnum = CharacterStatus.values.firstWhere((e) => e.name == effect.status!);
          print('Applying effect: ${effect.status} ${effect.delta}');
          characterStatusNotifier.effectCharacterStatus(statusEnum, effect.delta!);
          break;
        case 'inventory_add':
          // TODO: Add inventory effect implementation
          print('TODO: Add inventory item ${effect.item}');
          break;
        case 'inventory_remove':
          // TODO: Remove inventory effect implementation
          print('TODO: Remove inventory item ${effect.item}');
          break;
      }
    }
  }
}