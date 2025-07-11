import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/models/event_data.dart';

class EventDialog extends Component with HasGameReference {
  final String text;
  final List<ChoiceData> choices;
  final void Function(ChoiceData choice) onChoiceSelected;
  final bool Function(ChoiceData choice) isChoiceAvailable;
  final String Function(ChoiceData choice) getDisabledText;

  late final RectangleComponent background;
  late final TextComponent titleText;
  final List<ChoiceButton> choiceButtons = [];
  final Map<ChoiceData, Timer> delayTimers = {};

  EventDialog({
    required this.text,
    required this.choices,
    required this.onChoiceSelected,
    required this.isChoiceAvailable,
    required this.getDisabledText,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Create semi-transparent background
    background = RectangleComponent(
      size: Vector2(game.size.x, game.size.y),
      paint: Paint()..color = const Color(0x80000000), // Semi-transparent black
    );
    add(background);

    // Create dialog container
    final dialogWidth = 600.0;
    final dialogHeight = 400.0;
    final dialogX = (game.size.x - dialogWidth) / 2;
    final dialogY = (game.size.y - dialogHeight) / 2;

    final dialogContainer = RectangleComponent(
      position: Vector2(dialogX, dialogY),
      size: Vector2(dialogWidth, dialogHeight),
      paint: Paint()..color = const Color(0xFFFFFFFF), // White background
    );
    add(dialogContainer);

    // Add border
    final dialogBorder = RectangleComponent(
      position: Vector2(dialogX - 2, dialogY - 2),
      size: Vector2(dialogWidth + 4, dialogHeight + 4),
      paint: Paint()
        ..color = const Color(0xFF000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    add(dialogBorder);

    // Add title text
    titleText = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: typography.tp20.copyWith(
          color: const Color(0xFF000000),
        ),
      ),
      position: Vector2(dialogX + 20, dialogY + 20),
      size: Vector2(dialogWidth - 40, 100),
    );
    add(titleText);

    // Add choice buttons
    _createChoiceButtons(dialogX, dialogY, dialogWidth);
  }

  void _createChoiceButtons(double dialogX, double dialogY, double dialogWidth) {
    const buttonHeight = 50.0;
    const buttonSpacing = 10.0;
    final startY = dialogY + 120;

    for (int i = 0; i < choices.length; i++) {
      final choice = choices[i];
      final buttonY = startY + i * (buttonHeight + buttonSpacing);

      final button = ChoiceButton(
        choice: choice,
        position: Vector2(dialogX + 20, buttonY),
        size: Vector2(dialogWidth - 40, buttonHeight),
        onPressed: () => _handleChoicePressed(choice),
        isAvailable: () => isChoiceAvailable(choice),
        getText: () => _getButtonText(choice),
      );

      choiceButtons.add(button);

      // Handle delayed choices
      if (choice.delay > 0) {
        button.removeFromParent();
        delayTimers[choice] = Timer(choice.delay, onTick: () {
          if (!isMounted) return;
          add(button);
          delayTimers.remove(choice);
        });
      } else {
        add(button);
      }
    }
  }


  String _getButtonText(ChoiceData choice) {
    if (!isChoiceAvailable(choice) && choice.availability.disabledText != null) {
      return choice.availability.disabledText!;
    }
    return choice.text;
  }

  void _handleChoicePressed(ChoiceData choice) {
    if (!isChoiceAvailable(choice)) {
      print('Choice ${choice.id} is disabled');
      return;
    }

    print('Choice pressed: ${choice.id}');
    onChoiceSelected(choice);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update delay timers
    for (final timer in delayTimers.values) {
      timer.update(dt);
    }
  }

  @override
  void onRemove() {
    // Clean up timers
    for (final timer in delayTimers.values) {
      timer.stop();
    }
    delayTimers.clear();
    super.onRemove();
  }
}

class ChoiceButton extends PositionComponent with TapCallbacks {
  final ChoiceData choice;
  final VoidCallback onPressed;
  final bool Function() isAvailable;
  final String Function() getText;

  late final RectangleComponent background;
  late final TextComponent buttonText;

  ChoiceButton({
    required this.choice,
    required this.onPressed,
    required this.isAvailable,
    required this.getText,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // Background rectangle
    background = RectangleComponent(
      size: size,
      paint: Paint()..color = _getButtonColor(),
    );
    add(background);

    // Button text
    buttonText = TextComponent(
      text: getText(),
      textRenderer: TextPaint(
        style: typography.tp16m.copyWith(
          color: _getTextColor(),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(buttonText);

    // Border
    final border = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = const Color(0xFF000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    add(border);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update appearance based on availability
    background.paint.color = _getButtonColor();
    buttonText.textRenderer = TextPaint(
      style: typography.tp16m.copyWith(
        color: _getTextColor(),
      ),
    );
    buttonText.text = getText();
  }

  Color _getButtonColor() {
    if (!isAvailable()) {
      return const Color(0xFFCCCCCC); // Gray for disabled
    }
    return const Color(0xFF4CAF50); // Green for available
  }

  Color _getTextColor() {
    if (!isAvailable()) {
      return const Color(0xFF666666); // Dark gray for disabled
    }
    return const Color(0xFFFFFFFF); // White for available
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (isAvailable()) {
      background.paint.color = const Color(0xFF45A049); // Darker green for pressed
      return true;
    }
    return false;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    if (isAvailable()) {
      background.paint.color = _getButtonColor(); // Reset color
      onPressed();
      return true;
    }
    return false;
  }

  @override
  bool onTapCancel(TapCancelEvent event) {
    background.paint.color = _getButtonColor(); // Reset color
    return true;
  }
}