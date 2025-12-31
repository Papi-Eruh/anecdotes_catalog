import 'dart:async';

import 'package:anecdotes/anecdotes.dart';
import 'package:anecdotes_catalog/anecdotes_catalog.dart';
import 'package:widia/widia.dart';
import 'package:flutter/material.dart' hide ValueChanged;

class LoopingRiveMeasureWidget extends MeasureBaseWidget<LoopingRiveMeasure> {
  const LoopingRiveMeasureWidget({required super.measure, super.key});

  @override
  MeasureBaseState<MeasureBaseWidget<LoopingRiveMeasure>> createState() {
    return _LoopingRiveMeasureWidgetState();
  }
}

class _LoopingRiveMeasureWidgetState
    extends MeasureBaseState<MeasureBaseWidget<LoopingRiveMeasure>>
    with MeasureMusicCompletedMixin, RiveMeasureMixin {
  final _completer = Completer<void>();

  @override
  void onSceneInit(SceneWidgetController controller) {
    super.onSceneInit(controller);
    _completer.complete();
  }

  @override
  Future<void> prepareBeforeReady() {
    return _completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return ColoredBox(
      color: surfaceColor,
      child: SceneWidget(
        fileSource: widget.measure.riveSource,
        fit: BoxFit.cover,
        onInit: onSceneInit,
      ),
    );
  }

  @override
  void onDurationUpdate(Duration duration) {
    // TODO: implement onDurationUpdate
  }
}
