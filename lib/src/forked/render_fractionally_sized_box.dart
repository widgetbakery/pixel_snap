import 'package:flutter/rendering.dart';
import 'package:pixel_perfect/src/pixel_snap.dart';

/// Sizes its child to a fraction of the total available space.
///
/// For both its width and height, this render object imposes a tight
/// constraint on its child that is a multiple (typically less than 1.0) of the
/// maximum constraint it received from its parent on that axis. If the factor
/// for a given axis is null, then the constraints from the parent are just
/// passed through instead.
///
/// It then tries to size itself to the size of its child. Where this is not
/// possible (e.g. if the constraints from the parent are themselves tight), the
/// child is aligned according to [alignment].
class RenderFractionallySizedOverflowBox extends RenderAligningShiftedBox {
  /// Creates a render box that sizes its child to a fraction of the total available space.
  ///
  /// If non-null, the [widthFactor] and [heightFactor] arguments must be
  /// non-negative.
  ///
  /// The [alignment] must not be null.
  ///
  /// The [textDirection] must be non-null if the [alignment] is
  /// direction-sensitive.
  RenderFractionallySizedOverflowBox({
    super.child,
    double? widthFactor,
    double? heightFactor,
    super.alignment,
    super.textDirection,
  })  : _widthFactor = widthFactor,
        _heightFactor = heightFactor {
    assert(_widthFactor == null || _widthFactor! >= 0.0);
    assert(_heightFactor == null || _heightFactor! >= 0.0);
  }

  /// If non-null, the factor of the incoming width to use.
  ///
  /// If non-null, the child is given a tight width constraint that is the max
  /// incoming width constraint multiplied by this factor. If null, the child is
  /// given the incoming width constraints.
  double? get widthFactor => _widthFactor;
  double? _widthFactor;
  set widthFactor(double? value) {
    assert(value == null || value >= 0.0);
    if (_widthFactor == value) {
      return;
    }
    _widthFactor = value;
    markNeedsLayout();
  }

  /// If non-null, the factor of the incoming height to use.
  ///
  /// If non-null, the child is given a tight height constraint that is the max
  /// incoming width constraint multiplied by this factor. If null, the child is
  /// given the incoming width constraints.
  double? get heightFactor => _heightFactor;
  double? _heightFactor;
  set heightFactor(double? value) {
    assert(value == null || value >= 0.0);
    if (_heightFactor == value) {
      return;
    }
    _heightFactor = value;
    markNeedsLayout();
  }

  BoxConstraints _getInnerConstraints(BoxConstraints constraints) {
    double minWidth = constraints.minWidth;
    double maxWidth = constraints.maxWidth;
    if (_widthFactor != null) {
      final double width = maxWidth * _widthFactor!;
      minWidth = width;
      maxWidth = width;
    }
    double minHeight = constraints.minHeight;
    double maxHeight = constraints.maxHeight;
    if (_heightFactor != null) {
      final double height = maxHeight * _heightFactor!;
      minHeight = height;
      maxHeight = height;
    }
    return BoxConstraints(
      minWidth: minWidth.ps,
      maxWidth: maxWidth.ps,
      minHeight: minHeight.ps,
      maxHeight: maxHeight.ps,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double result;
    if (child == null) {
      result = super.computeMinIntrinsicWidth(height);
    } else {
      // the following line relies on double.infinity absorption
      result =
          child!.getMinIntrinsicWidth((height * (_heightFactor ?? 1.0)).ps);
    }
    assert(result.isFinite);
    return (result / (_widthFactor ?? 1.0)).ps;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double result;
    if (child == null) {
      result = super.computeMaxIntrinsicWidth(height);
    } else {
      // the following line relies on double.infinity absorption
      result =
          child!.getMaxIntrinsicWidth((height * (_heightFactor ?? 1.0)).ps);
    }
    assert(result.isFinite);
    return (result / (_widthFactor ?? 1.0)).ps;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double result;
    if (child == null) {
      result = super.computeMinIntrinsicHeight(width);
    } else {
      // the following line relies on double.infinity absorption
      result = child!.getMinIntrinsicHeight((width * (_widthFactor ?? 1.0)).ps);
    }
    assert(result.isFinite);
    return (result / (_heightFactor ?? 1.0)).ps;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double result;
    if (child == null) {
      result = super.computeMaxIntrinsicHeight(width);
    } else {
      // the following line relies on double.infinity absorption
      result = child!.getMaxIntrinsicHeight((width * (_widthFactor ?? 1.0)).ps);
    }
    assert(result.isFinite);
    return (result / (_heightFactor ?? 1.0)).ps;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      final Size childSize =
          child!.getDryLayout(_getInnerConstraints(constraints));
      return constraints.constrain(childSize);
    }
    return constraints
        .constrain(_getInnerConstraints(constraints).constrain(Size.zero));
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(_getInnerConstraints(constraints), parentUsesSize: true);
      size = constraints.constrain(child!.size);
      alignChild();
    } else {
      size = constraints
          .constrain(_getInnerConstraints(constraints).constrain(Size.zero));
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DoubleProperty('widthFactor', _widthFactor, ifNull: 'pass-through'));
    properties.add(
        DoubleProperty('heightFactor', _heightFactor, ifNull: 'pass-through'));
  }
}
