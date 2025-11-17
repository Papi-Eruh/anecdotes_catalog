import 'package:anecdotes/anecdotes.dart';
import 'package:heart/heart.dart';
import 'package:maestro/maestro.dart';

class WorldMapMeasure implements Measure {
  WorldMapMeasure({
    required this.id,
    required this.countryCode,
    this.captionsSource,
    this.voiceSource,
  });

  @override
  final int id;

  @override
  final FileSource? captionsSource;

  @override
  final AudioSource? voiceSource;

  final String countryCode;
}
