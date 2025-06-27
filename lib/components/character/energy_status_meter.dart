import 'dart:ui';
import 'package:work_on_time_game/components/character/status_meter.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/enums/character_status.dart';

class EnergyStatusMeter extends StatusMeter {
  final CharacterStatus statusType = CharacterStatus.energy;

  EnergyStatusMeter({
    super.meterLevel,
    super.position,
    super.size,
    super.deltaDirection,
  }) : super(
          iconPath: images.statusEnergyIcon,
          meterColor: const Color(0xFFFFE77A),
        );
}
