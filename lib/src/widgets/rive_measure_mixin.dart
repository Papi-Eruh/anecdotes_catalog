import 'package:anecdotes/anecdotes.dart';
import 'package:flutter/widgets.dart';
import 'package:widia/widia.dart';

mixin RiveMeasureMixin<M extends Measure, W extends MeasureBaseWidget<M>>
    on MeasureBaseState<M, W> {
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
