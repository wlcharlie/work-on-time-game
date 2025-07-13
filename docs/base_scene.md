# BaseScene Component Documentation

## Overview

`BaseScene` is a powerful declarative scene component for the Flame game engine that simplifies creating animated scenes with multiple elements. It provides automatic animation management, state control, and lifecycle hooks.

## Key Features

- **Declarative Scene Definition**: Define your entire scene structure in a single method
- **Automatic Animation Management**: Handles animation timing and state transitions
- **Built-in State Management**: Tracks scene state (not started, playing, completed)
- **Flexible Animation Support**: Supports various animation types (move, scale, fade, etc.)
- **Audio Integration**: Easy audio playback tied to animations
- **Scene Completion Callbacks**: Get notified when animations complete

## Basic Usage

```dart
class MyScene extends BaseScene {
  @override
  List<SceneElement> defineSceneElements() {
    return [
      SceneElement(
        path: 'background.png',
        size: Vector2(786, 1704),
        position: Vector2(0, 0),
        startTime: 0,
      ),
      SceneElement(
        path: 'character.png',
        size: Vector2(200, 300),
        position: Vector2(300, 800),
        startTime: 1.0,
        animations: [
          SceneAnimation(
            type: AnimationType.fade,
            from: 0.0,
            to: 1.0,
            duration: 2.0,
          ),
        ],
      ),
    ];
  }
}
```

## SceneElement Properties

| Property | Type | Description |
|----------|------|-------------|
| `path` | String | Path to the image asset |
| `size` | Vector2 | Size of the element |
| `position` | Vector2 | Initial position |
| `startTime` | double | When to start showing this element (in seconds) |
| `animations` | List<SceneAnimation> | Animations to apply |
| `loop` | bool | Whether animations should loop |
| `resetPosition` | Vector2? | Position to reset to when looping |
| `onStart` | Function? | Callback when element starts |

## Animation Types

### Fade Animation
```dart
SceneAnimation(
  type: AnimationType.fade,
  from: 0.0,  // Start opacity
  to: 1.0,    // End opacity
  duration: 2.0,
)
```

### Move Animation
```dart
SceneAnimation(
  type: AnimationType.move,
  to: Vector2(500, 800),  // Target position
  duration: 3.0,
)
```

### Scale Animation
```dart
SceneAnimation(
  type: AnimationType.scale,
  from: 0.5,  // Start scale
  to: 1.5,    // End scale
  duration: 1.5,
)
```

### MoveLoop Animation
```dart
SceneAnimation(
  type: AnimationType.moveLoop,
  to: Vector2(0, 1800),  // Move distance
  duration: 5.0,
)
```

## Advanced Features

### Audio Integration
```dart
SceneElement(
  path: 'rain_drop.png',
  // ... other properties
  onStart: () {
    game.audioPool.playSfx('rain_sound.mp3');
  },
)
```

### Loop with Reset Position
```dart
SceneElement(
  path: 'rain_drop.png',
  position: Vector2(100, -50),
  animations: [
    SceneAnimation(
      type: AnimationType.moveLoop,
      to: Vector2(0, 1800),
      duration: 5.0,
    ),
  ],
  loop: true,
  resetPosition: Vector2(100, -50),  // Reset to top when animation completes
)
```

### Scene State Management

Override these methods to handle different scene states:

```dart
class MyScene extends BaseScene {
  @override
  void updateScene(double dt) {
    // Called only during SceneState.playing
    // Use for scene-specific logic
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    // Called always, regardless of state
    // Use for timers or other continuous logic
  }
  
  @override
  void onSceneCompleted() {
    // Called when all animations complete
    // Use to transition to next scene or show UI
  }
}
```

## Complete Example: Rain Scene

```dart
class RainScene extends BaseScene {
  Timer? eventTimer;

  @override
  List<SceneElement> defineSceneElements() {
    return [
      // Background
      SceneElement(
        path: images.rainSceneBackground,
        size: Vector2(786, 1704),
        position: Vector2(0, 0),
        startTime: 0,
      ),
      // Character with fade-in
      SceneElement(
        path: images.rainSceneCharacter,
        size: Vector2(290, 559),
        position: Vector2(248, 800),
        startTime: 0.5,
        animations: [
          SceneAnimation(
            type: AnimationType.fade,
            from: 0.0,
            to: 1.0,
            duration: 2.0,
          ),
        ],
      ),
      // Looping raindrops
      ...List.generate(3, (i) => SceneElement(
        path: 'rain_drop_${i+1}.png',
        size: Vector2(30, 60),
        position: Vector2(100 + i * 200, -100),
        startTime: i * 0.5,
        animations: [
          SceneAnimation(
            type: AnimationType.moveLoop,
            to: Vector2(0, 1900),
            duration: 3.0 + i * 0.5,
          ),
        ],
        loop: true,
        resetPosition: Vector2(100 + i * 200, -100),
        onStart: () => game.audioPool.playSfx('rain_drop.mp3'),
      )),
    ];
  }

  @override
  void onSceneCompleted() {
    // Show event dialog after scene completes
    eventTimer = Timer(3.0)..start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    eventTimer?.update(dt);
    if (eventTimer?.finished ?? false) {
      // Show event dialog
      eventTimer = null;
    }
  }
}
```

## Best Practices

1. **Keep defineSceneElements() Pure**: Don't perform side effects in this method
2. **Use startTime for Sequencing**: Control the order of element appearances
3. **Leverage onStart Callbacks**: Perfect for audio or particle effects
4. **Override update() Carefully**: Always call super.update(dt) first
5. **Clean Up Resources**: Remove timers and listeners in onRemove()

## Tips

- Use `AnimationType.moveLoop` with `resetPosition` for continuous animations like rain or snow
- Combine multiple animations on a single element for complex effects
- Use `onSceneCompleted()` to transition to interactive elements or next scenes
- Keep heavy logic in `update()` rather than `updateScene()` if it needs to run after scene completion