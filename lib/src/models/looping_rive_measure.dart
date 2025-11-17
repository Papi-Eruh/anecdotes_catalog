import 'package:anecdotes/anecdotes.dart';
import 'package:heart/heart.dart';
import 'package:maestro/maestro.dart';

class LoopingRiveMeasure implements Measure {
  const LoopingRiveMeasure({
    required this.id,
    required this.riveSource,
    this.captionsSource,
    this.voiceSource,
  });

  @override
  final int id;

  final FileSource riveSource;

  @override
  final FileSource? captionsSource;

  @override
  final AudioSource? voiceSource;
}
