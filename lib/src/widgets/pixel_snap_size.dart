import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_snap/src/pixel_snap.dart';

typedef PixelSnapFunction = double Function(double);

double _defaultPixelSnap(double value) {
  return value.pixelSnap(PixelSnapMode.ceil);
}

class PixelSnapSize extends SingleChildRenderObjectWidget {
  const PixelSnapSize({
    super.key,
    required super.child,
    this.pixelSnapFunction = _defaultPixelSnap,
  });

  final PixelSnapFunction pixelSnapFunction;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPixelSnapSize(null, pixelSnapFunction);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderPixelSnapSize renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.pixelSnapFunction = pixelSnapFunction;
  }
}

class RenderPixelSnapSize extends RenderShiftedBox {
  RenderPixelSnapSize(super.child, this.pixelSnapFunction);

  PixelSnapFunction pixelSnapFunction;

  double _pixelSnap(double value) {
    return pixelSnapFunction(value);
  }

  Size _pixelSnapSize(Size size) {
    return Size(
      _pixelSnap(size.width),
      _pixelSnap(size.height),
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _pixelSnap(super.computeMinIntrinsicWidth(height));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _pixelSnap(super.computeMaxIntrinsicWidth(height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _pixelSnap(super.computeMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _pixelSnap(super.computeMaxIntrinsicHeight(width));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return constraints.constrain(Size.zero);
    }
    child!.layout(constraints, parentUsesSize: true);
    return constraints.constrain(_pixelSnapSize(child!.size));
  }

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.constrain(Size.zero);
      return;
    }
    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(_pixelSnapSize(child!.size));
  }
}
