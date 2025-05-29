import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic.g.dart';
part 'traffic.freezed.dart';

@freezed
sealed class TrafficState with _$TrafficState {
  const TrafficState._();

  const factory TrafficState({
    @Default(0) int currentIndex,
    @Default(3) int steps,
    @Default(3) int maxSteps,
    @Default(3) int heart,
    @Default(0) int money,
    @Default(3) int energy,
    @Default(3) int maxHeart,
    @Default(10) int maxMoney,
    @Default(3) int maxEnergy,
  }) = _TrafficState;

  factory TrafficState.fromJson(Map<String, dynamic> json) =>
      _$TrafficStateFromJson(json);
}

class TrafficNotifier extends StateNotifier<TrafficState> {
  TrafficNotifier() : super(const TrafficState());

  void rollDice() {
    if (state.steps > 0) {
      final rand = Random();
      final dice = rand.nextInt(3) + 1; // 1~3
      state = state.copyWith(
        currentIndex: (state.currentIndex + dice).clamp(0, 19),
        steps: state.steps - 1,
      );
    }
  }

  void reset() {
    state = const TrafficState();
  }
}

final trafficProvider =
    StateNotifierProvider<TrafficNotifier, TrafficState>((ref) {
  return TrafficNotifier();
});
