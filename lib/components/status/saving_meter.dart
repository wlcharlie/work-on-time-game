import 'package:flame/components.dart';
import 'dart:ui';
import 'package:work_on_time_game/components/status/status_meter.dart';
import 'package:work_on_time_game/config/images.dart';

class SavingMeter extends StatusMeter {
  SavingMeter({
    double meterLevel = 0.5,
    Vector2? position,
    Vector2? size,
  }) : super(
          iconPath: images.statusSavingIcon,
          meterColor: const Color(0xFF93D9BF),
          meterLevel: meterLevel,
          position: position,
          size: size,
        );
}
