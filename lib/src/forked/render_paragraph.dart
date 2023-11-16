import 'package:flutter/rendering.dart' as rendering;

import '../pixel_snap.dart';
import '../pixel_snap_ext.dart';

class RenderParagraph extends rendering.RenderParagraph {
  RenderParagraph(
    super.text, {
    super.textAlign,
    required super.textDirection,
    super.softWrap,
    super.overflow,
    @Deprecated(
      'Use textScaler instead. '
      'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
      'This feature was deprecated after v3.12.0-2.0.pre.',
    )
    super.textScaleFactor,
    super.textScaler,
    super.maxLines,
    super.locale,
    super.strutStyle,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
    super.registrar,
    required PixelSnap pixelSnap,
  }) : _pixelSnap = pixelSnap;

  PixelSnap _pixelSnap;

  set pixelSnap(PixelSnap value) {
    if (_pixelSnap != value) {
      _pixelSnap = value;
      markNeedsLayout();
    }
  }

  PixelSnap get pixelSnap => _pixelSnap;

  @override
  double computeMinIntrinsicWidth(double height) {
    return super
        .computeMinIntrinsicWidth(height)
        .pixelSnap(pixelSnap, PixelSnapMode.ceil);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return super
        .computeMaxIntrinsicWidth(height)
        .pixelSnap(pixelSnap, PixelSnapMode.ceil);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super
        .computeMinIntrinsicHeight(width)
        .pixelSnap(pixelSnap, PixelSnapMode.ceil);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return super
        .computeMaxIntrinsicHeight(width)
        .pixelSnap(pixelSnap, PixelSnapMode.ceil);
  }

  @override
  rendering.Size computeDryLayout(rendering.BoxConstraints constraints) {
    final size = super.computeDryLayout(constraints);
    return size.pixelSnap(pixelSnap, PixelSnapMode.ceil);
  }

  @override
  void performLayout() {
    super.performLayout();
    size = constraints.constrain(size.pixelSnap(pixelSnap, PixelSnapMode.ceil));
  }
}
