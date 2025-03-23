import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global.g.dart';

@Riverpod(keepAlive: true)
class GlobalNotifier extends _$GlobalNotifier {
  // @override
  // String build() {
  //   return 'Hello';
  // }

  @override
  Stream<int> build() async* {
    for (var i = 0; i < 10; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
  }
}
