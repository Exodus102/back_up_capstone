// utils/debouncer.dart
import 'dart:async';
import 'dart:ui';

class Debouncer {
  final Duration delay;
  VoidCallback? _action;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  run(VoidCallback action) {
    _timer?.cancel();
    _action = action;
    _timer = Timer(delay, () {
      _action?.call();
    });
  }

  dispose() {
    _timer?.cancel();
  }
}
