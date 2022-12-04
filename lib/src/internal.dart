import 'package:flutter/widgets.dart';
import 'package:pixel_perfect/src/pixel_snap.dart';

double? _overrideDevicePixelRatio;

double get devicePixelRatio =>
    _overrideDevicePixelRatio ??
    WidgetsBinding.instance.window.devicePixelRatio;

set overrideDevicePixelRatio(double? value) {
  _overrideDevicePixelRatio = value;
  WidgetsBinding.instance.reassembleApplication();
}

double? get overrideDevicePixelRatio => _overrideDevicePixelRatio;

typedef PixelSnapFunction = double Function({
  required double value,
  required double devicePixelRatio,
  required PixelSnapMode mode,
});

double _defaultPixelSnap({
  required double value,
  required double devicePixelRatio,
  required PixelSnapMode mode,
}) {
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

PixelSnapFunction _pixelSnapFunction = _defaultPixelSnap;

void overridePixelSnap(
  PixelSnapFunction? snap,
) {
  _pixelSnapFunction = snap ?? _defaultPixelSnap;
  WidgetsBinding.instance.reassembleApplication();
}

double pixelSnap(double value, PixelSnapMode mode) {
  if (!value.isFinite) {
    return value;
  }
  return _pixelSnapFunction(
    value: value,
    devicePixelRatio: devicePixelRatio,
    mode: mode,
  );
}
