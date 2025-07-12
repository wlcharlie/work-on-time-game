import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/config/priority.dart';
import 'package:work_on_time_game/models/event_data.dart';
import 'package:work_on_time_game/wot_game.dart';

class EventDialog extends Component with HasGameReference<WOTGame> {
  final String text;
  final List<ChoiceData> choices;
  final void Function(ChoiceData choice) onChoiceSelected;
  final bool Function(ChoiceData choice) isChoiceAvailable;
  final String Function(ChoiceData choice) getDisabledText;

  late final RectangleComponent overlay;
  late final EventDialogContainer gameDialog;

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

    priority = Priority.dialog;

    // Create semi-transparent overlay covering full screen
    // overlay = RectangleComponent(
    //   size: Vector2(game.size.x, game.size.y),
    //   paint: Paint()..color = const Color(0x80000000),
    // );
    // add(overlay);

    // Create dialog container with all dialog content
    gameDialog = EventDialogContainer(
      text: text,
      choices: choices,
      onChoiceSelected: onChoiceSelected,
      isChoiceAvailable: isChoiceAvailable,
      getDisabledText: getDisabledText,
    );
    add(gameDialog);
  }
}

class EventDialogContainer extends PositionComponent
    with HasGameReference<WOTGame> {
  final String text;
  final List<ChoiceData> choices;
  final void Function(ChoiceData choice) onChoiceSelected;
  final bool Function(ChoiceData choice) isChoiceAvailable;
  final String Function(ChoiceData choice) getDisabledText;

  late final GameDialogBackground background;
  late final TextComponent titleText;
  final List<ButtonComponent> choiceButtons = [];
  final Map<ChoiceData, Timer> delayTimers = {};

  // Dialog dimensions - can be easily adjusted
  static const double dialogWidth = 660.0;
  static const double dialogHeight = 440.0;
  static const double buttonWidth = 570.0;
  static const double buttonHeight = 90.0;

  EventDialogContainer({
    required this.text,
    required this.choices,
    required this.onChoiceSelected,
    required this.isChoiceAvailable,
    required this.getDisabledText,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Position the dialog container - easily adjustable
    position = Vector2(
      (game.size.x - dialogWidth) / 2,
      1200.0,
    );
    size = Vector2(dialogWidth, dialogHeight);

    // Create background (positioned at 0,0 relative to container)
    background = GameDialogBackground(
      size: Vector2(dialogWidth, dialogHeight),
    );
    add(background);

    // Create title text (positioned relative to container)
    titleText = TextBoxComponent(
      text: text,
      textRenderer: TextPaint(
        style: typography.tp40
            .withColor(AppColors.brown700)
            .withFontWeight(FontWeight.w600),
      ),
      boxConfig: TextBoxConfig(maxWidth: 542),
      align: Anchor.center,
      anchor: Anchor.topLeft,
      position: Vector2((dialogWidth - 542) / 2, 78),
    );
    add(titleText);

    // Create choice buttons (positioned relative to container)
    _createChoiceButtons();
  }

  void _createChoiceButtons() {
    const buttonSpacing = 32.0;
    const startY = 175.0;

    for (int i = 0; i < choices.length; i++) {
      final choice = choices[i];
      final buttonY = startY + i * (buttonHeight + buttonSpacing);

      final button = ButtonComponent(
        position: Vector2((dialogWidth - buttonWidth) / 2, buttonY),
        size: Vector2(buttonWidth, buttonHeight),
        onPressed: () => _handleChoicePressed(choice),
        button: SimpleButtonState(
          size: Vector2(buttonWidth, buttonHeight),
          text: _getButtonText(choice),
          backgroundColor: isChoiceAvailable(choice)
              ? const Color(0xFF907054)
              : const Color(0xFF999999),
          textColor: isChoiceAvailable(choice)
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFCCCCCC),
        ),
        buttonDown: SimpleButtonState(
          size: Vector2(buttonWidth, buttonHeight),
          text: _getButtonText(choice),
          backgroundColor: isChoiceAvailable(choice)
              ? const Color(0xFF6B5440)
              : const Color(0xFF999999),
          textColor: isChoiceAvailable(choice)
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFCCCCCC),
        ),
      );

      choiceButtons.add(button);

      // Handle delayed choices
      if (choice.delay > 0) {
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
    if (!isChoiceAvailable(choice) &&
        choice.availability.disabledText != null) {
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

// Simple button state component for ButtonComponent
class SimpleButtonState extends PositionComponent {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  late Paint _bgPaint;
  late RRect _rrect;
  late TextComponent _textComponent;

  SimpleButtonState({
    required Vector2 size,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  }) : super(size: size);

  @override
  Future<void> onLoad() async {
    _rrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      const Radius.circular(20),
    );

    _bgPaint = Paint()
      ..color = backgroundColor
      ..strokeJoin = StrokeJoin.round;

    _textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: typography.tp40
            .withColor(textColor)
            .withFontWeight(FontWeight.w600),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(_textComponent);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
  }
}

// Dialog background component matching game's Dialog.dart exactly
class GameDialogBackground extends PositionComponent
    with HasGameReference<WOTGame> {
  late Image _bgImage;
  late Paint _bgPaint;
  late Paint _borderPaint;
  late RRect _rrect;

  GameDialogBackground({
    required Vector2 size,
  }) : super(size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await game.images.load(images.dialogBg);
    _bgImage = game.images.fromCache(images.dialogBg);

    _borderPaint = Paint()
      ..color = const Color(0xFFA9886C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round;

    // Convert Float32List to Float64List
    final matrix4Storage = Matrix4.identity().storage;
    final Float64List float64Storage = Float64List.fromList(matrix4Storage);

    _bgPaint = Paint()
      ..shader = ImageShader(
        _bgImage,
        TileMode.repeated,
        TileMode.repeated,
        float64Storage,
      )
      ..color = const Color.fromRGBO(255, 255, 255, 0.85);

    _rrect = RRect.fromLTRBR(
      0,
      0,
      size.x,
      size.y,
      const Radius.circular(6),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
  }
}
