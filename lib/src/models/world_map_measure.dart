import 'package:anecdotes/anecdotes.dart';
import 'package:heart/heart.dart';
import 'package:maestro/maestro.dart';

class WorldMapMeasure implements Measure {
  WorldMapMeasure({
    required this.countryCode,
    required this.completionType,
    this.captionsSource,
    this.voiceSource,
  });

  @override
  final FileSource? captionsSource;

  @override
  final AudioSource? voiceSource;

  final String countryCode;

  @override
  final MeasureCompletionType completionType;
}
