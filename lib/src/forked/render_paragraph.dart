import 'package:flutter/rendering.dart' as rendering;
import 'package:pixel_snap/src/pixel_snap.dart';

class RenderParagraph extends rendering.RenderParagraph {
  RenderParagraph(
    super.text, {
    super.textAlign,
    required super.textDirection,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    super.locale,
    super.strutStyle,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
    super.registrar,
  });

  @override
  double computeMinIntrinsicWidth(double height) {
    return super.computeMinIntrinsicWidth(height).pixelSnap(PixelSnapMode.ceil);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return super.computeMaxIntrinsicWidth(height).pixelSnap(PixelSnapMode.ceil);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super.computeMinIntrinsicHeight(width).pixelSnap(PixelSnapMode.ceil);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return super.computeMaxIntrinsicHeight(width).pixelSnap(PixelSnapMode.ceil);
  }

  @override
  rendering.Size computeDryLayout(rendering.BoxConstraints constraints) {
    final size = super.computeDryLayout(constraints);
    return size.pixelSnap(PixelSnapMode.ceil);
  }

  @override
  void performLayout() {
    super.performLayout();
    size = constraints.constrain(size.pixelSnap(PixelSnapMode.ceil));
  }
}
