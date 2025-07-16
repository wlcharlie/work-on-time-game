import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:work_on_time_game/models/card_model.dart';
import 'package:work_on_time_game/config/images.dart';

const uuid = Uuid();

class CardNotifier extends StateNotifier<List<Card>> {
  CardNotifier()
      : super([
          // 初始假資料，方便測試
          Card(
            id: uuid.v4(),
            name: '大鵝',
            description: '移動到最近的公園，並事件率上升',
            iconPath: Images().goose,
          ),
          Card(
            id: uuid.v4(),
            name: '大鵝',
            description: '移動到最近的公園，並事件率上升',
            iconPath: Images().goose,
          ),
          Card(
            id: uuid.v4(),
            name: '大鵝',
            description: '移動到最近的公園，並事件率上升',
            iconPath: Images().goose,
          ),
        ]);

  void addCard(Card card) {
    state = [...state, card];
  }

  void removeCard(String cardId) {
    state = state.where((card) => card.id != cardId).toList();
  }
}

final cardProvider = StateNotifierProvider<CardNotifier, List<Card>>((ref) {
  return CardNotifier();
});
