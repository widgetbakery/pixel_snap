// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';

import '../../internal.dart';
import '../../pixel_snap.dart' show PixelSnapMode;
import '../pixel_ratio_override.dart';
import '../pixel_snap_size.dart';
import 'custom_button.dart';

class PixelSnapDebugBar extends StatelessWidget {
  const PixelSnapDebugBar({
    super.key,
    required this.child,
    this.enableInReleaseMode = false,
  });

  final Widget child;
  final bool enableInReleaseMode;

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode && !enableInReleaseMode) {
      return child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _PixelSnapDebugBar(),
        Expanded(
          child: PixelRatioOverrideWidget(
            child: child,
          ),
        ),
      ],
    );
  }
}

// Note that debugger is not part of PixelRatioOverrideWidget, so all pixel
// snapping it does must be done against actual devicePixelRatio.

extension on num {
  double get ps {
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    return (this * devicePixelRatio - 0.05).round() / devicePixelRatio;
  }
}

double _pixelSnap(double v) => v.ps;

class _PixelSnapDebugBar extends StatelessWidget {
  const _PixelSnapDebugBar();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
          child: Container(
            color: Colors.blueGrey.shade800,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.all(8.ps),
                child: Row(
                  children: [
                    const PixelSnapSize(
                      pixelSnapFunction: _pixelSnap,
                      child: Text('Pixel Snapping'),
                    ),
                    SizedBox(width: 8.ps),
                    CustomButton(
                      onPressed: () {
                        _setEnabled(!_enabled);
                      },
                      selected: _enabled,
                      builder: _buttonBuilder,
                      child: const PixelSnapSize(
                        pixelSnapFunction: _pixelSnap,
                        child: Text('Enabled'),
                      ),
                    ),
                    SizedBox(width: 16.ps),
                    ...<Widget>[
                      const _OverrideButton(ratio: null),
                      const _OverrideButton(ratio: 1.0),
                      const _OverrideButton(ratio: 1.25),
                      const _OverrideButton(ratio: 1.5),
                      const _OverrideButton(ratio: 1.75),
                      const _OverrideButton(ratio: 2.0),
                      const _OverrideButton(ratio: 2.25),
                      const _OverrideButton(ratio: 2.5),
                      const _OverrideButton(ratio: 2.75),
                      const _OverrideButton(ratio: 3.0),
                    ].intersperse(SizedBox(width: 4.ps)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatRatio(double ratio) {
  final f1 = ratio.toStringAsFixed(1);
  final f2 = ratio.toStringAsFixed(2);
  return '${f1}0' == f2 ? f1 : f2;
}

class _OverrideButton extends StatelessWidget {
  final double? ratio;

  const _OverrideButton({
    super.key,
    this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = ratio == PixelSnap.instance.overrideDevicePixelRatio;
    return CustomButton(
      onPressed: () {
        PixelSnap.instance.overrideDevicePixelRatio = ratio;
      },
      selected: selected,
      builder: _buttonBuilder,
      child: PixelSnapSize(
        pixelSnapFunction: _pixelSnap,
        child: PixelSnapSize(
          pixelSnapFunction: _pixelSnap,
          child: Text(ratio != null ? _formatRatio(ratio!) : 'System'),
        ),
      ),
    );
  }
}

bool _enabled = true;

void _setEnabled(bool enabled) {
  _enabled = enabled;
  if (enabled) {
    PixelSnap.instance.overridePixelSnapFunction = null;
  } else {
    PixelSnap.instance.overridePixelSnapFunction = ({
      required double value,
      required double devicePixelRatio,
      required PixelSnapMode mode,
    }) =>
        value;
  }
}

Widget _buttonBuilder(BuildContext context, ButtonState state, Widget? child) {
  late BoxDecoration decoration;

  var backgroundColor = Colors.white.withOpacity(0.05);
  if (state.hovered) {
    backgroundColor =
        backgroundColor.withOpacity(backgroundColor.opacity + 0.1);
  }
  if (state.pressed) {
    backgroundColor =
        backgroundColor.withOpacity(backgroundColor.opacity + 0.1);
  }
  if (state.focused) {
    backgroundColor =
        backgroundColor.withOpacity(backgroundColor.opacity + 0.1);
  }
  if (state.selected) {
    backgroundColor =
        backgroundColor.withOpacity(backgroundColor.opacity + 0.2);
  }

  decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: backgroundColor,
  );

  return Container(
    decoration: decoration,
    padding: EdgeInsets.symmetric(horizontal: 6.ps, vertical: 4.ps),
    child: child,
  );
}

extension<T> on Iterable<T> {
  Iterable<T> intersperse(T element) sync* {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
    }
  }
}
