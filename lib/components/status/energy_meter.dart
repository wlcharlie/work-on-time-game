import 'package:flame/components.dart';
import 'dart:ui';
import 'package:work_on_time_game/components/status/status_meter.dart';
import 'package:work_on_time_game/config/images.dart';

class EnergyMeter extends StatusMeter {
  EnergyMeter({
    double meterLevel = 0.5,
    Vector2? position,
    Vector2? size,
  }) : super(
          iconPath: images.statusEnergyIcon,
          meterColor: const Color(0xFFFFE77A),
          meterLevel: meterLevel,
          position: position,
          size: size,
        );
}
