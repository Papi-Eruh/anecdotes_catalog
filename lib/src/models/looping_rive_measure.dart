import 'package:anecdotes/anecdotes.dart';
import 'package:heart/heart.dart';
import 'package:maestro/maestro.dart';

class LoopingRiveMeasure implements Measure {
  const LoopingRiveMeasure({
    required this.riveSource,
    required this.completionType,
    this.captionsSource,
    this.voiceSource,
  });

  final FileSource riveSource;

  @override
  final FileSource? captionsSource;

  @override
  final AudioSource? voiceSource;

  @override
  final MeasureCompletionType completionType;
}
