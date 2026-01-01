import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:anecdotes/anecdotes.dart';
import 'package:anecdotes_catalog/anecdotes_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xml/xml.dart';

class WorldMapMeasureWidget extends MeasureBaseWidget<WorldMapMeasure> {
  const WorldMapMeasureWidget({
    required super.measure,
    required this.languageCode,
    this.countryWidgetBuilder,
    super.key,
  });

  final String languageCode;

  /// Optional function that allows customizing how a country is displayed.
  ///
  /// If provided, this function will be called to build the widget
  /// representing a country using its name and SVG flag path.
  final CountryWidgetBuilder? countryWidgetBuilder;

  @override
  MeasureBaseState<WorldMapMeasure, MeasureBaseWidget<WorldMapMeasure>>
  createState() {
    return _WorldMapMeasureWidgetState();
  }
}

class _WorldMapMeasureWidgetState
    extends MeasureBaseState<WorldMapMeasure, WorldMapMeasureWidget>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: Duration.zero,
  );

  Offset? _origin;
  var _scale = 1.0;
  String? _xmlStr;
  double _animState = 0;

  WorldMapMeasure get _measure => widget.measure;

  String get _countryCode => _measure.countryCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_xmlStr == null) return const SizedBox();
    final animation = _controller.drive(
      TweenSequence([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 1.5,
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 1 / 3,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.5,
            end: _scale,
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 2 / 3,
        ),
      ]),
    );
    final countryName = getCountryNameByLcCc(widget.languageCode, _countryCode);
    final countryWidgetBuilder = widget.countryWidgetBuilder;
    final flagPath =
        'packages/anecdotes_catalog/assets/flags/${_countryCode.toLowerCase()}.svg';
    return ColoredBox(
      color: Colors.blue[900]!,
      child: Stack(
        children: [
          AnimatedBuilder(
            builder: (context, child) {
              return Transform.scale(
                scale: animation.value,
                origin: _origin,
                alignment: Alignment.topLeft,
                child: child,
              );
            },
            animation: animation,
            child: SizedBox.expand(child: SvgPicture.string(_xmlStr!)),
          ),
          if (countryWidgetBuilder != null)
            countryWidgetBuilder.call(countryName, flagPath),
        ],
      ),
    );
  }

  @override
  void onPause() {
    _animState = _controller.value;
    _controller.stop();
  }

  @override
  void onPlay() {
    unawaited(_controller.forward(from: _animState));
  }

  @override
  void onVoiceDurationChanged(Duration duration) {
    if (_measure.completionType == MeasureCompletionType.voice) {
      _controller.duration = duration;
    }
  }

  @override
  void onMusicDurationChanged(Duration duration) {
    if (_measure.completionType == MeasureCompletionType.music) {
      _controller.duration = duration;
    }
  }

  @override
  Future<void> prepareBeforeReady() async {
    final sizeCompleter = Completer<Size>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = context.findRenderObject()! as RenderBox;
      final constraints = box.constraints;
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      sizeCompleter.complete(size);
    });
    final availableSize = await sizeCompleter.future;
    final (origin, scale, xmlStr) = await extractWorldMapData(
      _countryCode,
      availableSize,
      '#E2006C',
    );
    setState(() {
      _origin = origin;
      _scale = scale;
      _xmlStr = xmlStr;
    });
  }
}

/// Signature for a function that builds a widget representing a country.
///
/// - [countryName]: The full name of the country (e.g. "France").
/// - [flagPath]: The path to the country's flag SVG asset.
///   Should be used directly with `SvgPicture.asset(flagPath)`.
typedef CountryWidgetBuilder =
    Widget Function(String countryName, String flagPath);

/// (Origin, scale, strXml of world map)
Future<(Offset, double, String)> extractWorldMapData(
  String countryCode,
  Size screenSize,
  String color,
) async {
  final value = await extractBoundingBoxesAndViewBoxAndXmlStr(
    'packages/anecdotes_catalog/assets/images/world_map.svg',
    countryCode,
    color,
  );

  final countryBoundingBoxes = value.$1;
  final viewBox = value.$2;
  final countryBox = countryBoundingBoxes[countryCode];
  if (countryBox == null) throw Exception();

  final viewBoxWidth = viewBox.width;
  final viewBoxHeight = viewBox.height;
  final scale = min(
    screenSize.width / viewBoxWidth,
    screenSize.height / viewBoxHeight,
  );

  final t = (countryBox.center.dx / viewBox.width).clamp(0.0, 1.0);
  final dx = lerpDouble(
    countryBox.centerLeft.dx,
    countryBox.centerRight.dx,
    t,
  )!;

  final origin = Offset(
    scale * dx,
    scale * countryBox.center.dy +
        (screenSize.height - viewBoxHeight * scale) / 2,
  );
  double? nextScale;
  //todo remove one day
  if (countryCode == 'JM') nextScale = 30;
  nextScale ??= calculateScaleToFit(viewBox, countryBox);
  return (origin, nextScale, value.$3);
}

double calculateScaleToFit(Rect viewBox, Rect country) {
  final scale = min(
    viewBox.width / country.width,
    viewBox.height / country.height,
  );
  return scale * 0.8;
}

Future<(Map<String, Rect>, Rect, String)>
extractBoundingBoxesAndViewBoxAndXmlStr(
  String svgPath,
  String countryCode,
  String color,
) async {
  final svgString = await rootBundle.loadString(svgPath);
  final document = XmlDocument.parse(svgString);
  final viewBox = extractViewBox(document);
  final countryBoundingBoxes = <String, Rect>{};

  for (final element in document.findAllElements('path')) {
    final id = element.getAttribute('id');
    final d = element.getAttribute('d');
    if (id == countryCode) {
      element.setAttribute('fill', color);
    }
    if (id != null && d != null) {
      final bbox = calculateBoundingBox(d);
      if (bbox != null) {
        countryBoundingBoxes[id] = bbox;
      }
    }
  }

  return (countryBoundingBoxes, viewBox, document.toXmlString());
}

Rect extractViewBox(XmlDocument document) {
  final viewBoxAttr = document.rootElement.getAttribute('viewBox');
  if (viewBoxAttr == null) {
    throw Exception("Le fichier SVG ne contient pas d'attribut viewBox.");
  }

  final parts = viewBoxAttr.split(RegExp(r'\s+')).map(double.parse).toList();
  if (parts.length != 4) {
    throw Exception('Le viewBox doit contenir exactement 4 valeurs.');
  }

  return Rect.fromLTWH(parts[0], parts[1], parts[2], parts[3]);
}

Rect? calculateBoundingBox(String d) {
  final regex = RegExp(r'([MLCQTZmlcqtz])|([-+]?\d*\.?\d+)');
  final matches = regex.allMatches(d);

  double currentX = 0;
  double currentY = 0;
  var isRelative = false;

  var minX = double.infinity;
  var maxX = double.negativeInfinity;
  var minY = double.infinity;
  var maxY = double.negativeInfinity;

  final points = <double>[];

  for (final match in matches) {
    final command = match.group(1); // Commande (M, L, etc.)
    final number = match.group(2); // Nombre trouvé

    if (command != null) {
      isRelative = command.toLowerCase() == command; // Relatif si minuscule
      points.clear();
    } else if (number != null) {
      points.add(double.parse(number));

      if (points.length.isEven) {
        var x = points[points.length - 2];
        var y = points[points.length - 1];

        if (isRelative) {
          x += currentX;
          y += currentY;
        }

        currentX = x;
        currentY = y;

        minX = min(minX, x);
        maxX = max(maxX, x);
        minY = min(minY, y);
        maxY = max(maxY, y);
      }
    }
  }

  return (minX == double.infinity || minY == double.infinity)
      ? null
      : Rect.fromLTRB(minX, minY, maxX, maxY);
}
