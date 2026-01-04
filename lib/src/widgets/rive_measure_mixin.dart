import 'dart:async';

import 'package:anecdotes/anecdotes.dart';
import 'package:flutter/foundation.dart' hide Factory;
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

/// A mixin for [MeasureBaseState] to handle Rive animations.
///
/// This mixin provides the basic functionality for controlling a Rive
/// animation, including pausing, playing, and initializing the scene.
mixin RiveMeasureMixin<M extends Measure, W extends MeasureBaseWidget<M>>
    on MeasureBaseState<M, W> {
  late final File _file;

  /// The controller for the Rive animation widget.
  late RiveWidgetController controller;

  final _readyCompleter = Completer<void>();

  FileSource get riveFileSource;

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

  @override
  void initState() {
    super.initState();
    unawaited(_initRive());
  }

  Future<void> _initRive() async {
    _file = (await riveFileSource.accept(
      _FileLoaderFileSourceVisitor(),
    ))!;
    controller = RiveWidgetController(_file)..active = isInitActive;
    _readyCompleter.complete();
  }

  @override
  Future<void> prepareBeforeReady() {
    return _readyCompleter.future;
  }

  Widget buildContent(
    BuildContext context,
    RiveWidgetController controller,
  );

  Widget buildLoading(BuildContext context);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readyCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildContent(context, controller);
        }
        return buildLoading(context);
      },
    );
  }

  @override
  void dispose() {
    _file.dispose();
    controller.dispose();
    super.dispose();
  }
}

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
