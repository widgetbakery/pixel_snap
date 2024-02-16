import 'package:flutter/widgets.dart';

enum PixelSnapMode {
  /// Snap to the nearest pixel.
  snap,

  /// Snap to the nearest pixel, rounding up.
  ceil,

  /// Snap to the nearest pixel, rounding down.
  floor,
}

typedef PixelSnapFunction = double Function(
  double value,
  double devicePixelRatio,
  PixelSnapMode mode,
);

class PixelSnap {
  PixelSnap.custom({
    required this.devicePixelRatio,
    this.pixelSnapFunction = _defaultPixelSnap,
  });

  /// Returns PixelSnap for the given build context.
  static PixelSnap of(BuildContext context) {
    final override =
        context.dependOnInheritedWidgetOfExactType<PixelSnapOverride>();
    return PixelSnap.custom(
      devicePixelRatio:
          override?.devicePixelRatio ?? MediaQuery.devicePixelRatioOf(context),
      pixelSnapFunction: override?.pixelSnapFunction ?? _defaultPixelSnap,
    );
  }

  /// Snaps the [value] to nearest physical pixel according to provided [mode].
  double call(double value, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return pixelSnapFunction(
      value,
      devicePixelRatio,
      mode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PixelSnap &&
        other.devicePixelRatio == devicePixelRatio &&
        other.pixelSnapFunction == pixelSnapFunction;
  }

  @override
  int get hashCode => Object.hash(devicePixelRatio, pixelSnapFunction);

  final double devicePixelRatio;
  final PixelSnapFunction pixelSnapFunction;
}

/// Widget that allows overriding pixel snap configuration for subtree.
///
/// For example the code below disables pixel snapping for the subtree
/// while ensuring that rest of the app remains pixel snapped:
/// ```dart
/// // Make sure the widget size is still pixel snapped
/// // and doesn't affect the rest of the app.
/// PixelSnapSize(
///   child: PixelSnapOverride(
///     pixelSnapFunction: (value, _, __) => value,
///     child: Container( // this container will not be pixel snapped.
/// )));
/// ```
class PixelSnapOverride extends InheritedWidget {
  const PixelSnapOverride({
    super.key,
    this.devicePixelRatio,
    this.pixelSnapFunction,
    required super.child,
  });

  final double? devicePixelRatio;
  final PixelSnapFunction? pixelSnapFunction;

  @override
  bool updateShouldNotify(covariant PixelSnapOverride oldWidget) {
    return devicePixelRatio != oldWidget.devicePixelRatio ||
        pixelSnapFunction != oldWidget.pixelSnapFunction;
  }
}

double _defaultPixelSnap(
  double value,
  double devicePixelRatio,
  PixelSnapMode mode,
) {
  if (!value.isFinite) {
    return value;
  }
  switch (mode) {
    case PixelSnapMode.snap:
      // Ensure that 1.5 is rounded down. 1 logical pixel at 150% scale
      // should render at 1 physical pixel. At 175% it should render at
      // 2 physical pixels.
      return (value * devicePixelRatio - 0.05).round() / devicePixelRatio;
    case PixelSnapMode.ceil:
      return (value * devicePixelRatio).ceil() / devicePixelRatio;
    case PixelSnapMode.floor:
      return (value * devicePixelRatio).floor() / devicePixelRatio;
  }
}
