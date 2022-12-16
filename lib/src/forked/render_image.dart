import 'package:flutter/rendering.dart';

import '../pixel_snap.dart';

class RenderImagePixelSnap extends RenderImage {
  RenderImagePixelSnap({
    super.image,
    super.debugImageLabel,
    super.width,
    super.height,
    super.scale,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.textDirection,
    super.invertColors,
    super.isAntiAlias,
    super.filterQuality,
  });

  /// Find a size for the render image within the given constraints.
  ///
  ///  - The dimensions of the RenderImage must fit within the constraints.
  ///  - The aspect ratio of the RenderImage matches the intrinsic aspect
  ///    ratio of the image.
  ///  - The RenderImage's dimension are maximal subject to being smaller than
  ///    the intrinsic size of the image.
  Size _sizeForConstraints(BoxConstraints constraints) {
    // Folds the given |width| and |height| into |constraints| so they can all
    // be treated uniformly.
    constraints = BoxConstraints.tightFor(
      width: width,
      height: height,
    ).enforce(constraints);

    if (image == null) {
      return constraints.smallest;
    }

    return constraints
        .pixelSnapConstrainSizeAndAttemptToPreserveAspectRatio(Size(
      image!.width.toDouble() / scale,
      image!.height.toDouble() / scale,
    ));
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    assert(height >= 0.0);
    if (width == null) {
      return 0.0;
    }
    return _sizeForConstraints(BoxConstraints.tightForFinite(height: height))
        .width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(height >= 0.0);
    return _sizeForConstraints(BoxConstraints.tightForFinite(height: height))
        .width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(width >= 0.0);
    if (height == null) {
      return 0.0;
    }
    return _sizeForConstraints(BoxConstraints.tightForFinite(width: width))
        .height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(width >= 0.0);
    return _sizeForConstraints(BoxConstraints.tightForFinite(width: width))
        .height;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _sizeForConstraints(constraints);
  }

  @override
  void performLayout() {
    size = _sizeForConstraints(constraints);
  }
}
