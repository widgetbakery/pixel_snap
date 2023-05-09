import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../pixel_snap.dart';
import '../pixel_snap_ext.dart';

class PixelSnapSize extends SingleChildRenderObjectWidget {
  const PixelSnapSize({
    super.key,
    required super.child,
    this.pixelSnapMode = PixelSnapMode.ceil,
  });

  final PixelSnapMode pixelSnapMode;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPixelSnapSize(
      null,
      PixelSnap.of(context),
      pixelSnapMode,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderPixelSnapSize renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.pixelSnap = PixelSnap.of(context);
    renderObject.pixelSnapMode = pixelSnapMode;
  }
}

class RenderPixelSnapSize extends RenderShiftedBox {
  RenderPixelSnapSize(
    super.child,
    this.pixelSnap,
    this.pixelSnapMode,
  );

  PixelSnap pixelSnap;
  PixelSnapMode pixelSnapMode;

  @override
  double computeMinIntrinsicWidth(double height) {
    return super
        .computeMinIntrinsicWidth(height)
        .pixelSnap(pixelSnap, pixelSnapMode);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return super
        .computeMaxIntrinsicWidth(height)
        .pixelSnap(pixelSnap, pixelSnapMode);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super
        .computeMinIntrinsicHeight(width)
        .pixelSnap(pixelSnap, pixelSnapMode);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return super
        .computeMaxIntrinsicHeight(width)
        .pixelSnap(pixelSnap, pixelSnapMode);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return constraints.constrain(Size.zero);
    }
    child!.layout(constraints, parentUsesSize: true);
    return constraints.constrain(child!.size.pixelSnap(
      pixelSnap,
      pixelSnapMode,
    ));
  }

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.constrain(Size.zero);
      return;
    }
    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(child!.size.pixelSnap(
      pixelSnap,
      pixelSnapMode,
    ));
  }
}
