# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter game called "Work On Time Game" built with the Flame engine. It's a time management game where players collect items at home and navigate through various scenes and challenges.

Please aware that although this project use the game engine `Flame`, some part of code like overlays might use `material`.

## Development Commands

### Build and Run

```bash
# Run the app in development mode
flutter run

# Build for release
flutter build apk           # Android
flutter build ios           # iOS

# Run tests
flutter test

# Analyze code
flutter analyze

# Check for outdated dependencies
flutter pub outdated

# Update dependencies
flutter pub upgrade
```

### Code Generation

```bash
# Generate Riverpod providers (run after modifying provider files)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter packages pub run build_runner watch
```

### Linting

```bash
# Run linter
flutter analyze

# Run custom lints (includes riverpod_lint)
flutter pub run custom_lint
```

## Architecture

### Core Game Structure

- **Entry Point**: `main.dart` - App initialization with Riverpod provider scope
- **Game Instance**: `wot_game.dart` - Main FlameGame class with router and camera setup
- **Router**: Uses Flame's RouterComponent for scene navigation with routes:
  - `lobby` - Initial lobby screen
  - `level_home` - Home level where players collect items
  - `level_traffic` - Traffic navigation level
  - `event_scene` - Event scene management
  - `interaction_capture` - Camera interaction mode

### State Management

Uses Riverpod with code generation for state management:

- **Global**: `lib/providers/global.dart` - Global app state
- **Inventory**: `lib/providers/inventory.dart` - Player inventory management
- **Character Status**: `lib/providers/character_status.dart` - Player attributes (mind, saving, energy)

### Directory Structure

- `lib/components/` - Reusable Flame components
- `lib/config/` - Game configuration (colors, images, audio, etc.)
- `lib/models/` - Data models
- `lib/overlays/` - Flutter overlays that appear over the game
- `lib/providers/` - Riverpod state management
- `lib/screen/` - Game worlds and screens
- `lib/routes/` - Route definitions (currently empty)
- `assets/` - Game assets (images, audio, fonts)

### Key Features

- **Camera System**: Fixed resolution (786x1704) with pan support for home level
- **Tap Detection**: Global tap detection with visual feedback (TapCircle)
- **Inventory System**: Item collection and management
- **Character Attributes**: Mind, saving, and energy meters
- **Audio**: Background music and sound effects
- **Custom Fonts**: TaiwanPearl font family

### Game Scenes

- **Home Levels**: Bed room, living room, entrance way with interactive items
- **Traffic System**: Dice-based navigation with game board
- **Event Scenes**: Rain scene, MRT scene with dynamic events
- **Photo Capture**: Camera-like interaction system

## Development Notes

### Asset Management

Images are organized by scene/type in `assets/images/` and configured in `pubspec.yaml`. Audio files are in `assets/audio/`.

### Code Generation

The project uses `build_runner` for generating Riverpod providers. Always run code generation after modifying provider files.

### Debug Mode

Debug mode is enabled by default in `WOTGame` class. Visual debug information is available through overlays.

### Pan Controls

Camera panning is context-aware - only works in the home level (`level_home`) and can be disabled via the `isPannable` flag.
