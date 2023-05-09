// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart' as original;

import '../../generated/widgets.dart';
import '../../pixel_snap.dart';
import '../pixel_ratio_override.dart';
import '../pixel_snap_size.dart';
import 'custom_button.dart';

class PixelSnapDebugBar extends StatefulWidget {
  const PixelSnapDebugBar({
    super.key,
    required this.child,
    this.enableInReleaseMode = false,
  });

  final Widget child;
  final bool enableInReleaseMode;

  @override
  State<PixelSnapDebugBar> createState() => _PixelSnapDebugBarState();
}

double _dummyPixelSnap(
  double value,
  double devicePixelRatio,
  PixelSnapMode mode,
) {
  return value;
}

abstract class _PixelSnapState {
  bool get enabled;
  set enabled(bool value);

  double? get overrideRatio;
  set overrideRatio(double? value);
}

class _PixelSnapDebugBarState extends State<PixelSnapDebugBar>
    implements _PixelSnapState {
  @override
  bool get enabled => _enabled;

  @override
  set enabled(bool value) {
    setState(() {
      _enabled = value;
    });
  }

  @override
  double? get overrideRatio => _overrideRatio;

  @override
  set overrideRatio(double? value) {
    setState(() {
      _overrideRatio = value;
    });
  }

  double? _overrideRatio;
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode && !widget.enableInReleaseMode) {
      return widget.child;
    }

    return original.Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PixelSnapDebugBar(this),
        Expanded(
          child: PixelRatioOverrideWidget(
            newDevicePixelRatio: overrideRatio,
            originalDevicePixelRatio:
                WidgetsBinding.instance.window.devicePixelRatio,
            child: PixelSnapOverride(
              devicePixelRatio: overrideRatio,
              pixelSnapFunction: !enabled ? _dummyPixelSnap : null,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}

class _PixelSnapDebugBar extends StatelessWidget {
  const _PixelSnapDebugBar(this.state);

  final _PixelSnapState state;

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
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const PixelSnapSize(
                      child: Text('Pixel Snapping'),
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      onPressed: () {
                        state.enabled = !state.enabled;
                      },
                      selected: state.enabled,
                      builder: _buttonBuilder,
                      child: const PixelSnapSize(
                        child: Text('Enabled'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ...<Widget>[
                      _OverrideButton(ratio: null, state: state),
                      _OverrideButton(ratio: 1.0, state: state),
                      _OverrideButton(ratio: 1.25, state: state),
                      _OverrideButton(ratio: 1.5, state: state),
                      _OverrideButton(ratio: 1.75, state: state),
                      _OverrideButton(ratio: 2.0, state: state),
                      _OverrideButton(ratio: 2.25, state: state),
                      _OverrideButton(ratio: 2.5, state: state),
                      _OverrideButton(ratio: 2.75, state: state),
                      _OverrideButton(ratio: 3.0, state: state),
                    ].intersperse(const SizedBox(width: 4)),
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
  final _PixelSnapState state;

  const _OverrideButton({
    super.key,
    this.ratio,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = ratio == state.overrideRatio;
    return CustomButton(
      onPressed: () {
        state.overrideRatio = ratio;
      },
      selected: selected,
      builder: _buttonBuilder,
      child: PixelSnapSize(
        child: PixelSnapSize(
          child: Text(ratio != null ? _formatRatio(ratio!) : 'System'),
        ),
      ),
    );
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
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
