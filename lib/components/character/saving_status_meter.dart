import 'dart:ui';
import 'package:work_on_time_game/components/character/status_meter.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/enums/character_status.dart';

class SavingStatusMeter extends StatusMeter {
  final CharacterStatus statusType = CharacterStatus.saving;

  SavingStatusMeter({
    super.meterLevel,
    super.position,
    super.size,
    super.deltaDirection,
  }) : super(
          iconPath: images.statusSavingIcon,
          meterColor: const Color(0xFF93D9BF),
        );
}
