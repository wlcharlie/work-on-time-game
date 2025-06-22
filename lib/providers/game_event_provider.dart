import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/providers/game_event_provider.dart';

enum GameEventType { none, rain }

class GameEvent {
  final GameEventType type;
  final Map<String, dynamic>? data;

  GameEvent({this.type = GameEventType.none, this.data});
}

class GameEventNotifier extends StateNotifier<GameEvent> {
  GameEventNotifier() : super(GameEvent());

  void setEvent(GameEventType type, {Map<String, dynamic>? data}) {
    state = GameEvent(type: type, data: data);
  }

  void clearEvent() {
    state = GameEvent();
  }
}

final gameEventProvider =
    StateNotifierProvider<GameEventNotifier, GameEvent>((ref) {
  return GameEventNotifier();
});
