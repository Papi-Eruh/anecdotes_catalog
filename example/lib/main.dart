import 'package:anecdotes/anecdotes.dart';
import 'package:anecdotes_catalog/anecdotes_catalog.dart';
import 'package:flutter/material.dart';
import 'package:heart/heart.dart' show AssetSource;
import 'package:maestro/maestro.dart';
import 'package:maestro_just_audio/maestro_just_audio.dart';

void main() {
  runApp(const MainApp());
}

class MyAnecdote implements Anecdote {
  const MyAnecdote({required this.measures, this.musicSource});

  @override
  final List<Measure> measures;
  @override
  final AudioSource? musicSource;
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _registry = MeasureBuilderRegistry();
  final _maestro = createMaestro();

  @override
  void initState() {
    _registry.register<LoopingRiveMeasure>(
      (context, measure) => LoopingRiveMeasureWidget(measure: measure),
    );
    super.initState();
  }

  @override
  void dispose() {
    _maestro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnecdoteWidget(
        musicPlayer: _maestro.musicPlayer,
        anecdote: MyAnecdote(
          measures: [
            LoopingRiveMeasure(
              riveSource: AssetSource('assets/animations/pirates.riv'),
              completionType: MeasureCompletionType.music,
            ),
            LoopingRiveMeasure(
              riveSource: AssetSource('assets/animations/pirates_meeting.riv'),
              completionType: MeasureCompletionType.music,
            ),
            LoopingRiveMeasure(
              riveSource: AssetSource('assets/animations/pirates.riv'),
              completionType: MeasureCompletionType.music,
            ),
          ],
          musicSource: PlaylistSource([
            AssetAudioSource('assets/audio/barco_aventura.mp3'),
            AssetAudioSource('assets/audio/barco_aventura.mp3'),
            AssetAudioSource('assets/audio/barco_aventura.mp3'),
          ]),
        ),
        measureBuilderRegistry: _registry,
      ),
    );
  }
}
