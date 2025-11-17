import 'package:anecdotes/anecdotes.dart';
import 'package:widia/widia.dart';
import 'package:flutter/widgets.dart';

mixin RiveMeasureMixin<T extends StatefulWidget> on MeasureBaseState<T> {
  /// Controller of the [SceneWidget]
  late SceneWidgetController controller;

  /// If true, the scene is already animated before being visible.
  bool get isInitActive => false;

  @mustCallSuper
  @override
  void onPause() {
    controller.active = false;
  }

  @mustCallSuper
  @override
  void onPlay() {
    controller.active = true;
  }

  /// To call in [SceneWidget.onInit]
  @mustCallSuper
  void onSceneInit(SceneWidgetController controller) {
    this.controller = controller..active = isInitActive;
  }
}
