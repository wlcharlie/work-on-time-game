# Brain Storming

This is a note to record some ideas...

## Event System

"Event" is a part of the game where the player will encounter a event and to make choice to effect the character's status or the plot.

### How the system work

- Whenever the player encounter a event, the event will display a short period of animation.
- Once all the animation finished, the question with options will pop up.
- Once the player make a choice, will come up with a result.
- Usually only one question per event, but some event might have multiple questions (sequential or related).
- Each event will only give one result. The result might effect character's status or nothing happened.

### Event Controller Architecture Design

#### Design Patterns & Structure

**1. Strategy Pattern - Event Type Strategies**
```dart
abstract class EventStrategy {
  Future<EventResult> execute(EventContext context);
}

class SimpleChoiceStrategy extends EventStrategy {
  // Single question with immediate result
}

class SequentialQuestionsStrategy extends EventStrategy {
  // Multiple related questions in sequence
}

class ConditionalEventStrategy extends EventStrategy {
  // Questions that change based on player state/inventory
}
```

**2. Factory Pattern - Event Creation**
```dart
class EventFactory {
  static GameEvent createRainEvent() {
    return GameEvent.builder()
      .withId('rain_event')
      .withAnimation(RainSceneAnimation())
      .withStrategy(SimpleChoiceStrategy())
      .withQuestions([
        EventQuestion(
          text: '天空突然下起了傾盆大雨',
          choices: [
            EventChoice('go', '淋雨去公司', [MindEffect(-10), EnergyEffect(-10)]),
            EventChoice('buy', '去超商買傘', [MindEffect(-10), SavingEffect(-10)]),
          ]
        )
      ])
      .build();
  }
}
```

**3. Command Pattern - Choice Effects**
```dart
abstract class EffectCommand {
  void execute(CharacterStatusNotifier notifier);
  void undo();
}

class StatusEffectCommand extends EffectCommand {
  final CharacterStatus statusType;
  final int delta;
  
  void execute(CharacterStatusNotifier notifier) {
    notifier.effectCharacterStatus(statusType, delta);
  }
}

class InventoryEffectCommand extends EffectCommand {
  final String item;
  final bool add;
  
  void execute(CharacterStatusNotifier notifier) {
    // Handle inventory changes
  }
}
```

**4. State Pattern - Event Flow Management**
```dart
abstract class EventState {
  void enter(EventController controller);
  void update(double dt, EventController controller);
  void exit(EventController controller);
}

class AnimationState extends EventState {
  // Playing scene animations using existing BaseScene
}

class QuestionState extends EventState {
  // Displaying question dialog and waiting for choice
}

class ResultState extends EventState {
  // Showing result and applying effects
}

class CompletedState extends EventState {
  // Event finished, ready to transition
}
```

**5. Builder Pattern - Event Configuration**
```dart
class EventBuilder {
  EventBuilder withId(String id) { ... }
  EventBuilder withAnimation(SceneAnimation animation) { ... }
  EventBuilder withStrategy(EventStrategy strategy) { ... }
  EventBuilder withQuestions(List<EventQuestion> questions) { ... }
  EventBuilder withPreconditions(List<EventPrecondition> conditions) { ... }
  GameEvent build() { ... }
}
```

#### Main Controller Structure

**EventController** - Central coordinator
```dart
class EventController extends Component {
  EventState _currentState;
  GameEvent _currentEvent;
  EventStrategy _strategy;
  
  void startEvent(GameEvent event) {
    _currentEvent = event;
    _strategy = event.strategy;
    _changeState(AnimationState());
  }
  
  void handleChoice(EventChoice choice) {
    // Apply effects via command pattern
    for (final effect in choice.effects) {
      effect.execute(characterStatusNotifier);
    }
    
    _changeState(ResultState());
  }
  
  void _changeState(EventState newState) {
    _currentState?.exit(this);
    _currentState = newState;
    _currentState.enter(this);
  }
}
```

#### Integration with Existing Code

**Extending BaseScene for Events**
```dart
abstract class EventScene extends BaseScene {
  late final EventController eventController;
  
  @override
  void onSceneCompleted() {
    // Trigger question phase when animation completes
    eventController.transitionToQuestionState();
  }
  
  // Define event-specific scene elements
  List<SceneElement> defineSceneElements();
  
  // Define event configuration
  GameEvent defineEvent();
}
```

#### Benefits of This Design

1. **Separation of Concerns**: Animation, logic, and effects are separated
2. **Extensibility**: Easy to add new event types via strategy pattern
3. **Reusability**: Commands can be reused across different events
4. **Maintainability**: Clear state transitions and responsibilities
5. **Testability**: Each component can be tested independently
6. **Integration**: Works with existing BaseScene animation system

#### Usage Example

```dart
class RainEventScene extends EventScene {
  @override
  List<SceneElement> defineSceneElements() {
    return [
      SceneElement.background(imagePath: images.rainSceneBackground),
      SceneElement.event(
        id: 'rainDrops',
        imagePath: images.rainDrops,
        animations: [SceneAnimation.opacityLoop(duration: 2.0)]
      ),
    ];
  }
  
  @override
  GameEvent defineEvent() {
    return EventFactory.createRainEvent();
  }
}
```

This architecture provides a clean, extensible foundation for your event system while leveraging your existing BaseScene infrastructure.

### JSON Data Structure

#### Advanced Event JSON Schema with Flow Control

```json
{
  "id": "coffee_morning_event",
  "name": "Morning Coffee Decision",
  "preconditions": [],
  "flow": [
    {
      "id": "coffee_shop",
      "text": "路過咖啡店，要買咖啡嗎？",
      "choices": [
        {
          "id": "buy_expensive",
          "text": "買高級咖啡 ($20)",
          "visibility": {
            "conditions": [
              {"type": "status_min", "status": "mind", "value": 10}
            ]
          },
          "availability": {
            "conditions": [
              {"type": "status_min", "status": "saving", "value": 20}
            ],
            "disabled_text": "買高級咖啡 (錢不夠)"
          },
          "delay": 0,
          "outcomes": [
            {
              "conditions": [
                {"type": "status_min", "status": "saving", "value": 20}
              ],
              "effects": [
                {"type": "character_status", "status": "saving", "delta": -20},
                {"type": "character_status", "status": "mind", "delta": 15}
              ],
              "goto": "expensive_coffee_success"
            }
          ]
        },
        {
          "id": "wait_for_discount",
          "text": "等等看有沒有折扣",
          "visibility": {
            "conditions": [
              {"type": "inventory_has", "item": "phone"}
            ]
          },
          "availability": {
            "conditions": []
          },
          "delay": 3.0,
          "outcomes": [
            {
              "conditions": [
                {"type": "random_chance", "percentage": 60}
              ],
              "goto": "discount_appears"
            },
            {
              "conditions": [],
              "goto": "no_discount"
            }
          ]
        },
        {
          "id": "ask_friend_money",
          "text": "打電話借錢",
          "visibility": {
            "conditions": [
              {"type": "inventory_has", "item": "phone"},
              {"type": "status_max", "status": "saving", "value": 19}
            ]
          },
          "availability": {
            "conditions": []
          },
          "delay": 2.0,
          "outcomes": [
            {
              "conditions": [
                {"type": "status_min", "status": "mind", "value": 15}
              ],
              "effects": [
                {"type": "character_status", "status": "saving", "delta": 15}
              ],
              "goto": "borrowed_money"
            },
            {
              "conditions": [],
              "effects": [
                {"type": "character_status", "status": "mind", "delta": -10}
              ],
              "result": {
                "title": "被拒絕",
                "description": "朋友也沒錢借你..."
              }
            }
          ]
        }
      ]
    },
    {
      "id": "expensive_coffee_success",
      "text": "享受了高級咖啡，遇到老闆也在這家店",
      "choices": [
        {
          "id": "observe_boss",
          "text": "偷偷觀察老闆",
          "visibility": {
            "conditions": []
          },
          "availability": {
            "conditions": []
          },
          "delay": 1.5,
          "outcomes": [
            {
              "conditions": [],
              "effects": [
                {"type": "character_status", "status": "mind", "delta": 5}
              ],
              "result": {
                "title": "學到經驗",
                "description": "觀察到老闆的生活習慣，對未來工作有幫助"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

#### Choice Control Mechanics

**1. Visibility Control**
- `visibility.conditions`: When choice appears/disappears
- Empty conditions `[]` = always visible
- Multiple conditions = all must be met

**2. Availability Control** 
- `availability.conditions`: When choice can be clicked
- `disabled_text`: Text shown when choice is disabled
- Disabled choices are grayed out but still visible

**3. Timing Control**
- `delay`: Seconds before choice appears (0 = immediate)
- Allows dramatic timing and prevents rushed decisions

**4. Conditional Outcomes**
- Multiple `outcomes` per choice with different `conditions`
- First matching condition is executed
- Last outcome with empty conditions `[]` = fallback

**5. Flow Navigation**
- `goto`: Jump to another flow step
- `result`: End event with final message
- `effects`: Modify character status/inventory before navigation

#### Condition Types

```json
// Status checks
{"type": "status_min", "status": "saving", "value": 20}
{"type": "status_max", "status": "mind", "value": 10}

// Inventory checks  
{"type": "inventory_has", "item": "phone"}
{"type": "inventory_missing", "item": "umbrella"}

// Random events
{"type": "random_chance", "percentage": 60}

// Choice history (future extension)
{"type": "choice_was", "choice_id": "buy_expensive"}
```
```

#### Loading Events at Runtime

**1. Simplified Event Data Models**

```dart
// lib/models/event_data.dart
class EventData {
  final String id;
  final String name;
  final List<PreconditionData> preconditions;
  final QuestionData question;

  EventData({
    required this.id,
    required this.name,
    required this.preconditions,
    required this.question,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'],
      name: json['name'],
      preconditions: (json['preconditions'] as List)
          .map((e) => PreconditionData.fromJson(e))
          .toList(),
      question: QuestionData.fromJson(json['question']),
    );
  }
}

class PreconditionData {
  final String type;
  final String? item;
  final String? status;
  final int? value;
  
  PreconditionData({
    required this.type,
    this.item,
    this.status,
    this.value,
  });
  
  factory PreconditionData.fromJson(Map<String, dynamic> json) {
    return PreconditionData(
      type: json['type'],
      item: json['item'],
      status: json['status'],
      value: json['value'],
    );
  }
}

class QuestionData {
  final String text;
  final List<ChoiceData> choices;
  
  QuestionData({required this.text, required this.choices});
  
  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      text: json['text'],
      choices: (json['choices'] as List)
          .map((e) => ChoiceData.fromJson(e))
          .toList(),
    );
  }
}

class ChoiceData {
  final String id;
  final String text;
  final List<EffectData> effects;
  final ResultData result;
  
  ChoiceData({
    required this.id,
    required this.text,
    required this.effects,
    required this.result,
  });
  
  factory ChoiceData.fromJson(Map<String, dynamic> json) {
    return ChoiceData(
      id: json['id'],
      text: json['text'],
      effects: (json['effects'] as List)
          .map((e) => EffectData.fromJson(e))
          .toList(),
      result: ResultData.fromJson(json['result']),
    );
  }
}

class EffectData {
  final String type;
  final String? status;
  final int? delta;
  final String? item;
  
  EffectData({required this.type, this.status, this.delta, this.item});
  
  factory EffectData.fromJson(Map<String, dynamic> json) {
    return EffectData(
      type: json['type'],
      status: json['status'],
      delta: json['delta'],
      item: json['item'],
    );
  }
}

class ResultData {
  final String title;
  final String description;
  
  ResultData({required this.title, required this.description});
  
  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      title: json['title'],
      description: json['description'],
    );
  }
}
```

**2. Event Manager Service**

```dart
// lib/services/event_manager.dart
class EventManager {
  static EventManager? _instance;
  static EventManager get instance => _instance ??= EventManager._();
  EventManager._();

  Map<String, EventData> _events = {};
  
  Future<void> loadEvents() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/events.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _events.clear();
      for (final eventJson in jsonData['events']) {
        final event = EventData.fromJson(eventJson);
        _events[event.id] = event;
      }
      
      print('Loaded ${_events.length} events');
    } catch (e) {
      print('Error loading events: $e');
    }
  }
  
  EventData? getEvent(String eventId) {
    return _events[eventId];
  }
  
  List<EventData> getAllEvents() {
    return _events.values.toList();
  }
  
  List<EventData> getAvailableEvents(
    Map<CharacterStatus, int> characterStatus,
    List<String> inventory,
  ) {
    return _events.values.where((event) {
      return _checkPreconditions(event.preconditions, characterStatus, inventory);
    }).toList();
  }
  
  bool _checkPreconditions(
    List<PreconditionData> preconditions,
    Map<CharacterStatus, int> characterStatus,
    List<String> inventory,
  ) {
    for (final precondition in preconditions) {
      switch (precondition.type) {
        case 'inventory_missing':
          if (inventory.contains(precondition.item!)) return false;
          break;
        case 'inventory_has':
          if (!inventory.contains(precondition.item!)) return false;
          break;
        case 'status_min':
          final status = CharacterStatus.values.byName(precondition.status!);
          if ((characterStatus[status] ?? 0) < precondition.value!) return false;
          break;
        case 'status_max':
          final status = CharacterStatus.values.byName(precondition.status!);
          if ((characterStatus[status] ?? 0) > precondition.value!) return false;
          break;
      }
    }
    return true;
  }
}
```

**3. Simplified Event Factory**

```dart
// Updated EventFactory
class EventFactory {
  static GameEvent createFromData(EventData data) {
    return GameEvent(
      id: data.id,
      name: data.name,
      question: data.question,
      preconditions: data.preconditions,
    );
  }
}
```

**4. Usage in Game**

```dart
// In main.dart or game initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load event data
  await EventManager.instance.loadEvents();
  
  runApp(
    ProviderScope(
      child: MaterialApp(
        // ... rest of app
      ),
    ),
  );
}

// In your event scene
class RandomEventTrigger extends Component with RiverpodComponentMixin {
  void triggerRandomEvent() {
    final characterStatus = ref.read(characterStatusNotifierProvider);
    final inventory = ref.read(inventoryNotifierProvider);
    
    final availableEvents = EventManager.instance.getAvailableEvents(
      characterStatus,
      inventory.items,
    );
    
    if (availableEvents.isNotEmpty) {
      final randomEvent = availableEvents[Random().nextInt(availableEvents.length)];
      final gameEvent = EventFactory.createFromData(randomEvent);
      
      // Start the event
      game.eventController.startEvent(gameEvent);
    }
  }
}
```

**5. Asset Configuration**

Add to `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/data/events.json
```

#### Benefits of Simplified JSON Approach

- **Data-driven events**: Easy to modify game logic without code changes
- **Clean separation**: UI/animation logic stays in code, game logic in JSON
- **Designer-friendly**: Simple structure for non-programmers to create events
- **Easy testing**: Can quickly add new events and test game balance
- **Localization ready**: Text can be easily translated
- **Minimal overhead**: Only essential data, no UI details
