# Character System Documentation

## Overview

The character system in Work On Time Game tracks and displays the player's status through three core attributes that affect gameplay decisions and outcomes. The system integrates with events, UI components, and state management to create a cohesive character progression experience.

## Core Attributes

The character has three primary attributes:

| Attribute | Description | Color | Icon |
|-----------|-------------|-------|------|
| **Mind** | Mental/emotional state | #FFAC9C (Light Coral) | `mind.png` |
| **Energy** | Physical stamina | #FFE77A (Light Yellow) | `energy.png` |
| **Saving** | Financial resources | #93D9BF (Mint Green) | `saving.png` |

## State Management

### CharacterStatus Enum
```dart
enum CharacterStatus {
  mind,
  energy,
  saving,
}
```

### Character Status Provider

The character state is managed using Riverpod:

```dart
// Watch character status
final characterStatus = ref.watch(characterStatusNotifierProvider);
final mindValue = characterStatus[CharacterStatus.mind] ?? 0;

// Apply status effects
final notifier = ref.read(characterStatusNotifierProvider.notifier);
notifier.effectCharacterStatus(CharacterStatus.energy, -10);
```

### Initial Values
All attributes start at 0 by default:
```dart
{
  CharacterStatus.mind: 0,
  CharacterStatus.energy: 0,
  CharacterStatus.saving: 0,
}
```

## Visual Components

### StatusMeter

The base component for displaying character attributes:

```dart
// Basic status meter
final energyMeter = EnergyStatusMeter(
  position: Vector2(100, 100),
  size: Vector2(80, 80),
  meterLevel: 0.7,  // 70% filled
);
```

### Status Meter with Direction

Show attribute changes with directional arrows:

```dart
// Meter with decrease indicator
final mindMeter = MindStatusMeter(
  position: Vector2(100, 100),
  deltaDirection: -1,  // Down arrow
  meterLevel: 0.5,
);

// Meter with increase indicator  
final savingMeter = SavingStatusMeter(
  position: Vector2(200, 100),
  deltaDirection: 1,   // Up arrow
  meterLevel: 0.8,
);
```

### Attribute Components

Text-based attribute display:

```dart
// Simple attribute text
final attribute = Attribute(
  text: "Energy",
  position: Vector2(300, 200),
  deltaDirection: -1,  // Optional arrow
);

// Horizontal meter with label
final meter = AttributeMeter(
  attributeName: "Mind",
  value: 0.6,  // 60%
  position: Vector2(100, 300),
);
```

## Effect System

### Applying Effects

Effects modify character attributes through the event system:

```dart
// In EventFlowController
characterStatusNotifier.effectCharacterStatus(
  CharacterStatus.mind, 
  -10  // Decrease by 10
);
```

### Effect Data Structure

In event JSON files:
```json
{
  "effects": [
    {
      "type": "character_status",
      "status": "energy",
      "delta": -20
    },
    {
      "type": "character_status", 
      "status": "saving",
      "delta": 15
    }
  ]
}
```

### Effect Results

The `effectCharacterStatus` method returns details about the change:

```dart
final result = notifier.effectCharacterStatus(CharacterStatus.mind, -5);
// result.statusType = CharacterStatus.mind
// result.delta = -5
// result.deltaDirection = -1
```

## Integration Examples

### In Event Result Dialog

Display status changes after an event:

```dart
final resultDialog = EventResultDialog(
  result: ResultData(
    title: "Exhausted",
    description: "You pushed yourself too hard"
  ),
  appliedEffects: [
    EffectData(
      type: 'character_status',
      status: 'energy',
      delta: -30,
    ),
    EffectData(
      type: 'character_status',
      status: 'mind',
      delta: -10,
    ),
  ],
);
```

This automatically creates status meters with appropriate arrows showing the changes.

### In Game Events

Define character impacts in event JSON:

```json
{
  "id": "coffee_break",
  "choices": [
    {
      "id": "drink_coffee",
      "text": "Grab a coffee",
      "outcomes": [
        {
          "effects": [
            {
              "type": "character_status",
              "status": "energy", 
              "delta": 20
            },
            {
              "type": "character_status",
              "status": "saving",
              "delta": -5
            }
          ],
          "result": {
            "title": "Energized!",
            "description": "The coffee gives you a boost"
          }
        }
      ]
    }
  ]
}
```

### Conditional Choices

Make choices available based on character status:

```json
{
  "id": "expensive_option",
  "text": "Take a taxi",
  "availability": {
    "conditions": [
      {
        "type": "status_min",
        "status": "saving",
        "value": 20
      }
    ]
  }
}
```

## Visual Design Guidelines

### Colors
- **Mind**: Light coral (#FFAC9C) - warm, emotional
- **Energy**: Light yellow (#FFE77A) - bright, energetic  
- **Saving**: Mint green (#93D9BF) - cool, financial

### Sizes
- Standard status meter: 80x80 pixels
- Arrow indicators: Positioned 9px to the right of meters
- Consistent spacing: 100-130px between multiple meters

### Layout Examples

Horizontal layout (in EventResultDialog):
```
[Mind ↓]    [Energy ↓]    [Saving ↑]
  -10         -20          +15
```

Vertical layout (in game UI):
```
Mind    [████████░░] 80%
Energy  [██████░░░░] 60%  
Saving  [███░░░░░░░] 30%
```

## Best Practices

1. **Balance Effects**: Keep status changes reasonable (-30 to +30 range)
2. **Visual Feedback**: Always show direction arrows for changes
3. **Clear Consequences**: Make status impacts obvious in choice text
4. **Multiple Effects**: Consider how combined effects impact gameplay
5. **Threshold Design**: Use status minimums for meaningful choices

## Common Patterns

### Energy Management
```json
{
  "effects": [
    { "type": "character_status", "status": "energy", "delta": -20 },
    { "type": "character_status", "status": "mind", "delta": 10 }
  ]
}
```
Trade energy for mental benefits (rest, relaxation).

### Financial Decisions
```json
{
  "effects": [
    { "type": "character_status", "status": "saving", "delta": -15 },
    { "type": "character_status", "status": "energy", "delta": 20 }
  ]
}
```
Spend money to save energy (transportation, food).

### Stress Events
```json
{
  "effects": [
    { "type": "character_status", "status": "mind", "delta": -15 },
    { "type": "character_status", "status": "energy", "delta": -10 }
  ]
}
```
Challenging situations affect both mind and energy.

## Debugging

Check current character status:
```dart
// In a component with RiverpodComponentMixin
final status = ref.read(characterStatusNotifierProvider);
print('Mind: ${status[CharacterStatus.mind]}');
print('Energy: ${status[CharacterStatus.energy]}');
print('Saving: ${status[CharacterStatus.saving]}');
```

## Future Considerations

The character system is designed to be extensible:
- Add new status types by extending the enum
- Create custom status meters by extending StatusMeter
- Implement status-based achievements or unlocks
- Add temporary status effects or buffs
- Create status visualization overlays