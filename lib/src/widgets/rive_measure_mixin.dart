import 'package:anecdotes/anecdotes.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

/// A mixin for [MeasureBaseState] to handle Rive animations.
///
/// This mixin provides the basic functionality for controlling a Rive
/// animation, including pausing, playing, and initializing the scene.
mixin RiveMeasureMixin<M extends Measure, W extends MeasureBaseWidget<M>>
    on MeasureBaseState<M, W> {
  /// The controller for the Rive animation widget.
  late RiveWidgetController controller;

  /// If true, the scene is already animated before being visible.
  ///
  /// Defaults to false.
  bool get isInitActive => false;

  /// Pauses the Rive animation.
  ///
  /// This method should be called when the measure is paused.
  @mustCallSuper
  @override
  void onPause() {
    controller.active = false;
  }

  /// Plays the Rive animation.
  ///
  /// This method should be called when the measure is played.
  @mustCallSuper
  @override
  void onPlay() {
    controller.active = true;
  }

  /// Initializes the Rive scene.
  ///
  /// This method should be called when the Rive scene is initialized.
  /// It sets the [controller] and its initial active state.
  @mustCallSuper
  void onSceneInit(RiveWidgetController controller) {
    this.controller = controller..active = isInitActive;
  }
}
