import 'package:flutter/rendering.dart' hide RenderFittedBox;
import 'package:flutter/rendering.dart' as rendering;

import '../pixel_snap.dart';
import '../pixel_snap_ext.dart';

class RenderFittedBox extends rendering.RenderFittedBox {
  RenderFittedBox({
    super.fit,
    required AlignmentGeometry alignment,
    super.child,
    super.clipBehavior,
    super.textDirection,
    required PixelSnap pixelSnap,
  })  : _pixelSnap = pixelSnap,
        _originalAlignment = alignment,
        super(alignment: alignment.pixelSnap(pixelSnap));

  PixelSnap _pixelSnap;
  AlignmentGeometry _originalAlignment;

  PixelSnap get pixelSnap => _pixelSnap;

  set pixelSnap(PixelSnap value) {
    if (value != value) {
      _pixelSnap = value;
      alignment = _originalAlignment;
      markNeedsLayout();
    }
  }

  @override
  set alignment(AlignmentGeometry value) {
    _originalAlignment = value;
    super.alignment = value.pixelSnap(_pixelSnap);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      final Size childSize = child!.getDryLayout(const BoxConstraints());

      // During [RenderObject.debugCheckingIntrinsics] a child that doesn't
      // support dry layout may provide us with an invalid size that triggers
      // assertions if we try to work with it. Instead of throwing, we bail
      // out early in that case.
      bool invalidChildSize = false;
      assert(() {
        if (RenderObject.debugCheckingIntrinsics &&
            childSize.width * childSize.height == 0.0) {
          invalidChildSize = true;
        }
        return true;
      }());
      if (invalidChildSize) {
        assert(debugCannotComputeDryLayout(
          reason: 'Child provided invalid size of $childSize.',
        ));
        return Size.zero;
      }

      switch (fit) {
        case BoxFit.scaleDown:
          final BoxConstraints sizeConstraints = constraints.loosen();
          final Size unconstrainedSize = sizeConstraints
              .pixelSnapConstrainSizeAndAttemptToPreserveAspectRatio(
            pixelSnap,
            childSize,
          );
          return constraints.constrain(unconstrainedSize);
        case BoxFit.contain:
        case BoxFit.cover:
        case BoxFit.fill:
        case BoxFit.fitHeight:
        case BoxFit.fitWidth:
        case BoxFit.none:
          return constraints
              .pixelSnapConstrainSizeAndAttemptToPreserveAspectRatio(
            pixelSnap,
            childSize,
          );
      }
    } else {
      return constraints.smallest;
    }
  }

  @override
  void performLayout() {
    super.performLayout();
    if (child != null) {
      switch (fit) {
        case BoxFit.scaleDown:
          final BoxConstraints sizeConstraints = constraints.loosen();
          final Size unconstrainedSize = sizeConstraints
              .constrainSizeAndAttemptToPreserveAspectRatio(child!.size);
          size = constraints.constrain(unconstrainedSize);
          break;
        case BoxFit.contain:
        case BoxFit.cover:
        case BoxFit.fill:
        case BoxFit.fitHeight:
        case BoxFit.fitWidth:
        case BoxFit.none:
          size = constraints
              .constrainSizeAndAttemptToPreserveAspectRatio(child!.size);
          break;
      }
    }
  }
}
