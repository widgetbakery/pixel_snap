import 'package:flutter/widgets.dart';
import 'package:pixel_perfect/src/pixel_snap.dart';

class PixelPerfect {
  PixelPerfect._() {
    WidgetsBinding.instance.addObserver(_Observer(this));
  }

  void _didChangeMetrics() {
    _maybeReassemble();
  }

  double get devicePixelRatio =>
      _overrideDevicePixelRatio ??
      WidgetsBinding.instance.window.devicePixelRatio;

  PixelSnapFunction _pixelSnapFunction = _defaultPixelSnap;
  double? _overrideDevicePixelRatio;

  set overrideDevicePixelRatio(double? value) {
    _overrideDevicePixelRatio = value;
    _maybeReassemble();
  }

  double? get overrideDevicePixelRatio => _overrideDevicePixelRatio;

  set overridePixelSnapFunction(
    PixelSnapFunction? snapFunction,
  ) {
    _pixelSnapFunction = snapFunction ?? _defaultPixelSnap;
    _maybeReassemble();
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

  void _maybeReassemble() {
    if (_lastReassembleDevicePixelRatio != devicePixelRatio ||
        _lastReassemblePixelSnapFunction != _pixelSnapFunction) {
      _lastReassembleDevicePixelRatio = devicePixelRatio;
      _lastReassemblePixelSnapFunction = _pixelSnapFunction;
      WidgetsBinding.instance.reassembleApplication();
    }
  }

  double? _lastReassembleDevicePixelRatio;
  PixelSnapFunction? _lastReassemblePixelSnapFunction;

  static final instance = PixelPerfect._();
}

class _Observer extends WidgetsBindingObserver {
  _Observer(this.pixelPerfect);

  @override
  void didChangeMetrics() {
    pixelPerfect._didChangeMetrics();
  }

  final PixelPerfect pixelPerfect;
}

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
