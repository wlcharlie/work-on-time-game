import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work_on_time_game/enums/character_status.dart';
import 'package:work_on_time_game/models/effect_character_status.dart';
part 'character_status.g.dart';

@Riverpod(keepAlive: true)
class CharacterStatusNotifier extends _$CharacterStatusNotifier {
  @override
  Map<CharacterStatus, int> build() => {
        CharacterStatus.mind: 0,
        CharacterStatus.saving: 0,
        CharacterStatus.energy: 0,
      };

  EffectCharacterStatus effectCharacterStatus(
      CharacterStatus status, int delta) {
    final currentStatus = state[status];
    final newStatus = currentStatus! + delta;

    state = {
      ...state,
      status: newStatus,
    };

    return EffectCharacterStatus(
      statusType: status,
      delta: delta.toDouble(),
    );
  }
}
