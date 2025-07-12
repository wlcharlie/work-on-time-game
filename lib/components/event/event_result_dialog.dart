import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:work_on_time_game/components/common/dialog.dart';
import 'package:work_on_time_game/components/character/status_meters.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/models/event_data.dart';

const double dialogWidth = 660.0;
const double dialogHeight = 330.0;

class EventResultDialog extends PositionComponent {
  final ResultData result;
  final List<EffectData> appliedEffects;
  late Dialog _dialog;

  EventResultDialog({
    required this.result,
    required this.appliedEffects,
    Vector2? position,
    Vector2? scale,
  }) {
    this.position = position ?? Vector2(0, 1200);
    this.scale = scale ?? Vector2.all(1);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Create status meters
    final statusMeters = _createStatusMeters();

    // Create title with fixed width and center alignment
    final titleComponent = TextBoxComponent(
      text: result.title,
      textRenderer: TextPaint(
        style: typography.tp40
            .withFontWeight(FontWeight.w600)
            .withColor(AppColors.brown700),
      ),
      boxConfig: TextBoxConfig(
        maxWidth: 600, // Fixed width for consistent layout
        margins: EdgeInsets.zero,
      ),
      position: Vector2(dialogWidth / 2, 100), // Center horizontally
      anchor: Anchor.center,
      align: Anchor.center,
    );

    // Create description with fixed width and center alignment
    final descriptionComponent = TextBoxComponent(
      text: result.description,
      textRenderer: TextPaint(
        style: typography.tp32
            .withFontWeight(FontWeight.w600)
            .withColor(AppColors.brown500)
            .withShadow(),
      ),
      boxConfig: TextBoxConfig(
        maxWidth: 600, // Fixed width for consistent layout
        margins: EdgeInsets.zero,
      ),
      position: Vector2(dialogWidth / 2, 152), // Center horizontally
      anchor: Anchor.center,
      align: Anchor.center,
    );

    // Create the dialog with all content
    _dialog = Dialog(
      size: Vector2(dialogWidth, dialogHeight),
      position:
          Vector2.zero(), // Position is relative to parent EventResultDialog
      content: [
        titleComponent,
        descriptionComponent,
        ...statusMeters,
      ],
    );

    add(_dialog);
  }

  /// 根据应用的效果创建状态表组件
  List<Component> _createStatusMeters() {
    final statusMeters = <Component>[];

    // 过滤出字符状态效果
    final statusEffects = appliedEffects
        .where((effect) => effect.type == 'character_status')
        .toList();

    if (statusEffects.isEmpty) return statusMeters;

    for (int i = 0; i < statusEffects.length; i++) {
      final effect = statusEffects[i];
      final deltaDirection = effect.delta! > 0 ? 1 : -1;

      // 计算位置 - 在对话框中央下方排列
      final baseX = dialogWidth / 2; // 对话框中央
      final spacing = 130.0; // 状态表之间的间距
      final totalWidth = (statusEffects.length - 1) * spacing;
      final startX = baseX - (totalWidth / 2);
      final positionX = startX + (i * spacing);
      final positionY = 200.0; // 在文本下方

      Component? statusMeter;

      switch (effect.status) {
        case 'mind':
          statusMeter = MindStatusMeter(
            position: Vector2(positionX - 40, positionY), // 居中对齐
            deltaDirection: deltaDirection,
            size: Vector2(80, 80),
          );
          break;
        case 'saving':
          statusMeter = SavingStatusMeter(
            position: Vector2(positionX - 40, positionY), // 居中对齐
            deltaDirection: deltaDirection,
            size: Vector2(80, 80),
          );
          break;
        case 'energy':
          statusMeter = EnergyStatusMeter(
            position: Vector2(positionX - 40, positionY), // 居中对齐
            deltaDirection: deltaDirection,
            size: Vector2(80, 80),
          );
          break;
      }

      if (statusMeter != null) {
        statusMeters.add(statusMeter);
      }
    }

    return statusMeters;
  }
}
