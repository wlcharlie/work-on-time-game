# Event System Documentation

## Overview

The event system provides a JSON-driven framework for creating interactive story events with choices, conditions, effects, and results. It consists of three main components:

1. **EventFlowController**: Manages event logic and flow
2. **EventDialog**: Displays choices to the player
3. **EventResultDialog**: Shows the outcome of player choices

## Event JSON Structure

### Basic Event Structure
```json
{
  "id": "event_id",
  "name": "Event Name",
  "preconditions": [],
  "flow": [
    {
      "id": "step_1",
      "text": "What do you want to do?",
      "choices": [...]
    }
  ]
}
```

### Choice Structure
```json
{
  "id": "choice_1",
  "text": "Go to work",
  "visibility": {
    "conditions": []
  },
  "availability": {
    "conditions": []
  },
  "delay": 0,
  "outcomes": [...]
}
```

### Outcome Structure
```json
{
  "conditions": [],
  "effects": [
    {
      "type": "character_status",
      "status": "energy",
      "delta": -10
    }
  ],
  "result": {
    "title": "You went to work",
    "description": "You arrived tired but on time"
  }
}
```

## Component Usage

### EventFlowController

The brain of the event system, managing flow and logic:

```dart
// Load event data
final String jsonString = await rootBundle.loadString('assets/data/event.json');
final Map<String, dynamic> jsonData = json.decode(jsonString);
final EventData eventData = EventData.fromJson(jsonData);

// Create controller
final eventController = EventFlowController(
  eventData: eventData,
  onEventCompleted: (result, appliedEffects) {
    // Show result dialog
  },
  onStepChanged: () {
    // Update dialog with new choices
  },
);

// Add to scene
add(eventController);
```

### EventDialog

Displays choices to the player:

```dart
final currentStep = eventController.currentStep;
final visibleChoices = eventController.getVisibleChoices();

final eventDialog = EventDialog(
  step: currentStep,
  choices: visibleChoices,
  onChoiceSelected: (choice) {
    eventController.selectChoice(choice);
  },
  isChoiceAvailable: (choice) {
    return eventController.isChoiceAvailable(choice);
  },
);

add(eventDialog);
```

### EventResultDialog

Shows the outcome with status changes:

```dart
final resultDialog = EventResultDialog(
  result: result,
  appliedEffects: appliedEffects,
  position: Vector2(0, 639),
);

add(resultDialog);
```

## Condition Types

### Status Conditions
```json
{
  "type": "status_min",
  "status": "energy",
  "value": 50
}
```

```json
{
  "type": "status_max",
  "status": "mind",
  "value": 80
}
```

### Inventory Conditions
```json
{
  "type": "inventory_has",
  "item": "umbrella"
}
```

```json
{
  "type": "inventory_missing",
  "item": "coffee"
}
```

### Random Conditions
```json
{
  "type": "random_chance",
  "percentage": 30
}
```

## Effect Types

### Character Status Effects
```json
{
  "type": "character_status",
  "status": "mind",    // mind, energy, saving
  "delta": -10         // positive or negative
}
```

### Inventory Effects (TODO)
```json
{
  "type": "inventory_add",
  "item": "umbrella"
}
```

## Complete Example

### Rain Event JSON
```json
{
  "id": "without_umbrella_rain_event",
  "name": "Without Umbrella Rain Event",
  "flow": [
    {
      "id": "rain_question",
      "text": "It's suddenly pouring rain",
      "choices": [
        {
          "id": "go_without_umbrella",
          "text": "Walk in the rain",
          "visibility": { "conditions": [] },
          "availability": { "conditions": [] },
          "outcomes": [
            {
              "conditions": [],
              "effects": [
                { "type": "character_status", "status": "mind", "delta": -10 },
                { "type": "character_status", "status": "energy", "delta": -10 }
              ],
              "result": {
                "title": "Soaked",
                "description": "You're completely drenched..."
              }
            }
          ]
        },
        {
          "id": "buy_umbrella",
          "text": "Buy an umbrella",
          "visibility": { "conditions": [] },
          "availability": { 
            "conditions": [
              { "type": "status_min", "status": "saving", "value": 10 }
            ] 
          },
          "outcomes": [
            {
              "conditions": [],
              "effects": [
                { "type": "character_status", "status": "saving", "delta": -10 }
              ],
              "result": {
                "title": "Stayed Dry",
                "description": "You bought an umbrella and stayed dry"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Scene Implementation
```dart
class RainScene extends BaseScene {
  EventFlowController? eventController;
  EventDialog? eventDialog;

  @override
  void onSceneCompleted() {
    _loadAndShowEvent();
  }

  Future<void> _loadAndShowEvent() async {
    // Load JSON
    final jsonString = await rootBundle.loadString(
      'assets/data/without_umbrella_rain_event.json'
    );
    final eventData = EventData.fromJson(json.decode(jsonString));

    // Create controller
    eventController = EventFlowController(
      eventData: eventData,
      onEventCompleted: (result, effects) => _showResult(result, effects),
      onStepChanged: () => _updateDialog(),
    );
    add(eventController!);

    // Show initial dialog
    _updateDialog();
  }

  void _updateDialog() {
    // Remove old dialog
    if (eventDialog != null) {
      remove(eventDialog!);
    }

    // Create new dialog
    final step = eventController!.currentStep;
    final choices = eventController!.getVisibleChoices();

    eventDialog = EventDialog(
      step: step,
      choices: choices,
      onChoiceSelected: (choice) {
        eventController!.selectChoice(choice);
      },
      isChoiceAvailable: (choice) {
        return eventController!.isChoiceAvailable(choice);
      },
    );
    add(eventDialog!);
  }

  void _showResult(ResultData result, List<EffectData> effects) {
    // Remove event dialog
    remove(eventDialog!);

    // Show result
    final resultDialog = EventResultDialog(
      result: result,
      appliedEffects: effects,
    );
    add(resultDialog);
  }
}
```

## UI Customization

### EventDialog Styling

The dialog uses the game's consistent visual style:
- Brown textured background with border
- White text with shadow for questions
- Brown/gray buttons with state-based colors

### EventResultDialog Layout

- Title at top (y: 100)
- Description below (y: 152)
- Status meters centered at bottom (y: 200)
- Fixed width TextBoxComponents for consistent layout

## Best Practices

1. **Validate JSON**: Always validate your event JSON structure
2. **Test Conditions**: Test all condition combinations
3. **Balance Effects**: Keep status changes reasonable (-10 to +10)
4. **Clear Text**: Use concise, clear choice text
5. **Meaningful Results**: Result descriptions should reflect the choice made

## Debugging Tips

- Enable print statements in EventFlowController
- Check console for condition evaluation results
- Verify all choice IDs are unique
- Test with different character status values
- Use the event system playground to test JSON files