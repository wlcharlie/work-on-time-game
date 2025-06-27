import 'dart:ui';
import 'package:work_on_time_game/components/character/status_meter.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/enums/character_status.dart';

class MindStatusMeter extends StatusMeter {
  final CharacterStatus statusType = CharacterStatus.mind;

  MindStatusMeter({
    super.meterLevel,
    super.position,
    super.size,
    super.deltaDirection,
  }) : super(
          iconPath: images.statusMindIcon,
          meterColor: const Color(0xFFFFAC9C),
        );
}
