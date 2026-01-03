import 'package:anecdotes/anecdotes.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

mixin RiveMeasureMixin<M extends Measure, W extends MeasureBaseWidget<M>>
    on MeasureBaseState<M, W> {
  late RiveWidgetController controller;

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

  @mustCallSuper
  void onSceneInit(RiveWidgetController controller) {
    this.controller = controller..active = isInitActive;
  }
}
