import 'dart:async';

import 'package:anecdotes/anecdotes.dart';
import 'package:anecdotes_catalog/src/models/models.dart';
import 'package:anecdotes_catalog/src/widgets/widgets.dart';
import 'package:flutter/material.dart' hide ValueChanged;
import 'package:rive/rive.dart';

class _FileLoaderFileSourceVisitor implements FileSourceVisitor<Future<File?>> {
  @override
  Future<File?> visitAssetSource(AssetSource source) {
    return File.asset(source.path, riveFactory: Factory.rive);
  }

  @override
  Future<File?> visitBytesSource(FutureBytesSource bytesAudioSource) async {
    final bytes = await bytesAudioSource.bytesFuture;
    return File.decode(bytes, riveFactory: Factory.rive);
  }

  @override
  Future<File?> visitFilepathSource(FilepathSource source) {
    return File.path(source.path, riveFactory: Factory.rive);
  }

  @override
  Future<File?> visitNetworkSource(NetworkSource source) {
    return File.url(source.url, riveFactory: Factory.rive);
  }
}

class LoopingRiveMeasureWidget extends MeasureBaseWidget<LoopingRiveMeasure> {
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
  late File _file;

  bool _isInitialized = false;
  final _completer = Completer<void>();

  @override
  void initState() {
    super.initState();
    unawaited(initRive());
  }

  Future<void> initRive() async {
    _file = (await widget.measure.riveSource.accept(
      _FileLoaderFileSourceVisitor(),
    ))!;
    controller = RiveWidgetController(_file);
    onSceneInit(controller);
    setState(() => _isInitialized = true);
    _completer.complete();
  }

  @override
  void dispose() {
    _file.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Future<void> prepareBeforeReady() {
    return _completer.future;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      final surfaceColor = Theme.of(context).colorScheme.surface;
      return ColoredBox(color: surfaceColor);
    }
    return RiveWidget(
      controller: controller,
      fit: Fit.cover,
    );
  }
}
