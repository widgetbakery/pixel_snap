import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Applies overriden pixel ratio to child widgets.
class PixelRatioOverrideWidget extends StatelessWidget {
  const PixelRatioOverrideWidget({
    super.key,
    required this.newDevicePixelRatio,
    required this.originalDevicePixelRatio,
    required this.child,
  });

  final double? newDevicePixelRatio;
  final double originalDevicePixelRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _OverrideTransform(
      newScale: (newDevicePixelRatio ?? originalDevicePixelRatio) /
          originalDevicePixelRatio,
      child: child,
    );
  }
}

class _InflateLayout extends SingleChildRenderObjectWidget {
  const _InflateLayout({
    required super.child,
    required this.scale,
  });

  final double scale;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderInflateLayout(null, scale);

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderInflateLayout renderObject) {
    renderObject.scale = scale;
  }
}

class _RenderInflateLayout extends RenderShiftedBox {
  _RenderInflateLayout(RenderBox? child, this._scale) : super(child);

  double _scale;

  double get scale => _scale;

  set scale(double value) {
    if (_scale != value) {
      _scale = value;
      markNeedsLayout();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final size = this.size * scale;
    if (size.contains(position)) {
      if (hitTestChildren(result, position: position) ||
          hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }

  @override
  void performLayout() {
    BoxConstraints constraints = BoxConstraints.tightFor(
      width: this.constraints.maxWidth * scale,
      height: this.constraints.maxHeight * scale,
    );
    child!.layout(constraints, parentUsesSize: false);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset.zero;
    size = Size(this.constraints.maxWidth, this.constraints.maxHeight);
  }
}

class _OverrideTransform extends StatelessWidget {
  const _OverrideTransform({
    required this.newScale,
    required this.child,
  });

  final double newScale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.topLeft,
      scale: newScale,
      child: _InflateLayout(
        scale: 1.0 / newScale,
        child: child,
      ),
    );
  }
}
