import 'package:work_on_time_game/enums/character_status.dart';

class EffectCharacterStatus {
  final CharacterStatus statusType;
  final double delta;

  int get deltaDirection => delta > 0 ? 1 : -1;

  EffectCharacterStatus({
    required this.statusType,
    required this.delta,
  });
}
