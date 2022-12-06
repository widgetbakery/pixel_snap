import 'package:flutter/widgets.dart';
import 'package:pixel_perfect/src/pixel_snap.dart';

abstract class PixelPerfect {
  double get devicePixelRatio =>
      _overrideDevicePixelRatio ?? getSystemDevicePixelRatio();

  PixelSnapFunction _pixelSnapFunction = _defaultPixelSnap;
  double? _overrideDevicePixelRatio;

  set overrideDevicePixelRatio(double? value) {
    _overrideDevicePixelRatio = value;
    didChangeMetrics();
  }

  double? get overrideDevicePixelRatio => _overrideDevicePixelRatio;

  set overridePixelSnapFunction(
    PixelSnapFunction? snapFunction,
  ) {
    _pixelSnapFunction = snapFunction ?? _defaultPixelSnap;
    didChangeMetrics();
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

  double getSystemDevicePixelRatio();
  void didChangeMetrics();

  static PixelPerfect get instance => _instance;

  @visibleForTesting
  static void setInstance(PixelPerfect instance) {
    _instance = instance;
  }

  static PixelPerfect _instance = DefaultPixelPerfect._();
}

class DefaultPixelPerfect extends PixelPerfect {
  DefaultPixelPerfect._() {
    WidgetsBinding.instance.addObserver(_Observer(this));
  }

  @override
  void didChangeMetrics() {
    _maybeReassemble();
  }

  @override
  double getSystemDevicePixelRatio() =>
      WidgetsBinding.instance.window.devicePixelRatio;

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
}

class _Observer extends WidgetsBindingObserver {
  _Observer(this.pixelPerfect);

  @override
  void didChangeMetrics() {
    pixelPerfect.didChangeMetrics();
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
