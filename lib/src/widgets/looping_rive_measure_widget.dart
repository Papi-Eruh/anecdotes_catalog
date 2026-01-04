import 'package:anecdotes/anecdotes.dart';
import 'package:anecdotes_catalog/src/models/models.dart';
import 'package:anecdotes_catalog/src/widgets/widgets.dart';
import 'package:flutter/material.dart' hide ValueChanged;
import 'package:rive/rive.dart';

/// A widget that displays a [LoopingRiveMeasure].
///
/// This widget is responsible for loading and displaying a Rive animation
/// from the provided [LoopingRiveMeasure].
class LoopingRiveMeasureWidget extends MeasureBaseWidget<LoopingRiveMeasure> {
  /// Creates a new instance of [LoopingRiveMeasureWidget].
  ///
  /// The [measure] is required and contains the data for the Rive animation.
  const LoopingRiveMeasureWidget({required super.measure, super.key});

  @override
  MeasureBaseState<LoopingRiveMeasure, MeasureBaseWidget<LoopingRiveMeasure>>
  createState() {
    return _LoopingRiveMeasureWidgetState();
  }
}

class _LoopingRiveMeasureWidgetState
    extends
        MeasureBaseState<
          LoopingRiveMeasure,
          MeasureBaseWidget<LoopingRiveMeasure>
        >
    with RiveMeasureMixin {
  @override
  Widget buildContent(BuildContext context, RiveWidgetController controller) {
    return RiveWidget(controller: controller, fit: Fit.cover);
  }

  @override
  Widget buildLoading(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return ColoredBox(color: surfaceColor);
  }

  @override
  FileSource get riveFileSource => widget.measure.riveSource;

  @override
  void onControllerReady(RiveWidgetController controller) {}
}
