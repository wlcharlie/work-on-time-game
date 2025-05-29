import 'dart:math';
import 'package:flutter/material.dart';

class TrafficController extends ChangeNotifier {
  int currentIndex = 0;
  int steps = 3;
  int maxSteps = 3;
  int heart = 3;
  int money = 0;
  int energy = 3;
  final int totalPoints;

  TrafficController({required this.totalPoints});

  void rollDice() {
    if (steps > 0) {
      int dice = Random().nextInt(3) + 1; // 1~3
      currentIndex = (currentIndex + dice).clamp(0, totalPoints - 1);
      steps--;
      notifyListeners();
    }
  }

  void reset() {
    currentIndex = 0;
    steps = maxSteps;
    heart = 3;
    money = 0;
    energy = 3;
    notifyListeners();
  }
}
