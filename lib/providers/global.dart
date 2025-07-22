import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global.g.dart';

@Riverpod(keepAlive: true)
class GlobalNotifier extends _$GlobalNotifier {
  @override
  Map<String, String> build() {
    return Map<String, String>.fromEntries([
      MapEntry('currentEventScene', 'rain'),
    ]);
  }

  void setCurrentEventScene(String scene) {
    // combine current state and new state
    state = {
      ...state,
      'currentEventScene': scene,
    };
  }

  void clearCurrentEventScene() {
    state = {
      ...state,
      'currentEventScene': '',
    };
  }
}
