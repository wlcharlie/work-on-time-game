import 'package:flame/components.dart';
import 'dart:ui';
import 'package:work_on_time_game/components/status/status_meter.dart';
import 'package:work_on_time_game/config/images.dart';

class MindMeter extends StatusMeter {
  MindMeter({
    double meterLevel = 0.5,
    Vector2? position,
    Vector2? size,
  }) : super(
          iconPath: images.statusMindIcon,
          meterColor: const Color(0xFFFFAC9C),
          meterLevel: meterLevel,
          position: position,
          size: size,
        );
}
