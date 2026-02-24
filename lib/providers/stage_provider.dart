import 'package:flutter_riverpod/flutter_riverpod.dart';

class StageNotifier extends Notifier<int> {
  @override
  int build() => 1; // 1 = Input Form, 2 = Results

  void setStage(int stage) {
    state = stage;
  }
}

final stageProvider = NotifierProvider<StageNotifier, int>(
  () => StageNotifier(),
);
