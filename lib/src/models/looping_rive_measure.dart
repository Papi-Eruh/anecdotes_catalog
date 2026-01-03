import 'package:anecdotes/anecdotes.dart';

/// A measure that loops a Rive animation.
///
/// This class represents a measure that displays a Rive animation
/// that can be looped. It can also include optional captions and voice-over.
///
/// ```dart
/// const measure = LoopingRiveMeasure(
///   riveSource: FileSource('assets/rive/animation.riv'),
///   completionType: MeasureCompletionType.onTap,
/// );
/// ```
class LoopingRiveMeasure implements Measure {
  /// Creates a new instance of [LoopingRiveMeasure].
  ///
  /// The [riveSource] and [completionType] are required.
  const LoopingRiveMeasure({
    required this.riveSource,
    required this.completionType,
    this.captionsSource,
    this.voiceSource,
  });

  /// The source of the Rive animation file.
  final FileSource riveSource;

  /// The source of the captions file.
  @override
  final FileSource? captionsSource;

  /// The source of the voice-over audio.
  @override
  final AudioSource? voiceSource;

  /// The type of completion for the measure.
  @override
  final MeasureCompletionType completionType;
}
