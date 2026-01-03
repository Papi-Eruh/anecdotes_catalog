import 'package:anecdotes/anecdotes.dart';

/// A measure that highlights a country on a world map.
///
/// This class is used to display a specific country on a world map.
/// The country is identified by its [countryCode].
///
/// ```dart
/// final measure = WorldMapMeasure(
///   countryCode: 'FR',
///   completionType: MeasureCompletionType.onTap,
/// );
/// ```
class WorldMapMeasure implements Measure {
  /// Creates a new instance of [WorldMapMeasure].
  ///
  /// The [countryCode] and [completionType] are required.
  WorldMapMeasure({
    required this.countryCode,
    required this.completionType,
    this.captionsSource,
    this.voiceSource,
  });

  /// The source of the captions file.
  @override
  final FileSource? captionsSource;

  /// The source of the voice-over audio.
  @override
  final AudioSource? voiceSource;

  /// The ISO 3166-1 alpha-2 code of the country to highlight.
  final String countryCode;

  /// The type of completion for the measure.
  @override
  final MeasureCompletionType completionType;
}
