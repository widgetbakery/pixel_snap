import 'package:flutter/rendering.dart';

import 'pixel_snap.dart';

extension PixelSnapExtNum on num {
  double pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return ps(toDouble(), mode);
  }
}

extension PixelSnapExtOffset on Offset {
  Offset pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return Offset(
      dx.pixelSnap(ps, mode),
      dy.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtSize on Size {
  Size pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return Size(
      width.pixelSnap(ps, mode),
      height.pixelSnap(ps, mode),
    );
  }
}

extension on PixelSnapMode {
  PixelSnapMode get reverse {
    switch (this) {
      case PixelSnapMode.snap:
        return PixelSnapMode.snap;
      case PixelSnapMode.ceil:
        return PixelSnapMode.floor;
      case PixelSnapMode.floor:
        return PixelSnapMode.ceil;
    }
  }
}

extension PixelSnapExtRect on Rect {
  Rect pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return Rect.fromLTRB(
      left.pixelSnap(ps, mode.reverse),
      top.pixelSnap(ps, mode.reverse),
      right.pixelSnap(ps, mode),
      bottom.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtAlignmentGeometry on AlignmentGeometry {
  AlignmentGeometry pixelSnap(PixelSnap ps) {
    if (this is Alignment) {
      return (this as Alignment).pixelSnap(ps);
    } else if (this is AlignmentDirectional) {
      return (this as AlignmentDirectional).pixelSnap(ps);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtAlignment on Alignment {
  Alignment pixelSnap(PixelSnap ps) => _PixelSnapAlignment(x, y, ps);
}

extension PixelSnapExtAlignmentDirctional on AlignmentDirectional {
  AlignmentDirectional pixelSnap(PixelSnap ps) =>
      _PixelSnapAlignmentDirectional(start, y, ps);
}

extension PixelSnapExtEdgeInsetsGeometry on EdgeInsetsGeometry {
  EdgeInsetsGeometry pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is EdgeInsets) {
      return (this as EdgeInsets).pixelSnap(ps, mode);
    } else if (this is EdgeInsetsDirectional) {
      return (this as EdgeInsetsDirectional).pixelSnap(ps, mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtEdgeInsets on EdgeInsets {
  EdgeInsets pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return EdgeInsets.only(
      left: left.pixelSnap(ps, mode),
      top: top.pixelSnap(ps, mode),
      right: right.pixelSnap(ps, mode),
      bottom: bottom.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtConstraints on BoxConstraints {
  BoxConstraints pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return BoxConstraints(
      minWidth: minWidth.pixelSnap(ps, mode),
      maxWidth: maxWidth.pixelSnap(ps, mode),
      minHeight: minHeight.pixelSnap(ps, mode),
      maxHeight: maxHeight.pixelSnap(ps, mode),
    );
  }

  /// Returns a size that attempts to meet the following conditions, in order:
  ///
  ///  * The size must satisfy these constraints.
  ///  * The aspect ratio of the returned size matches the aspect ratio of the
  ///    given size.
  ///  * The returned size as big as possible while still being equal to or
  ///    smaller than the given size.
  Size pixelSnapConstrainSizeAndAttemptToPreserveAspectRatio(
    PixelSnap ps,
    Size size,
  ) {
    if (isTight) {
      Size result = smallest;
      return result;
    }

    double width = size.width;
    double height = size.height;
    assert(width > 0.0);
    assert(height > 0.0);
    final double aspectRatio = width / height;

    if (width > maxWidth) {
      width = maxWidth;
      height = (width / aspectRatio);
    }

    if (height > maxHeight) {
      height = maxHeight;
      width = (height * aspectRatio);
    }

    if (width < minWidth) {
      width = minWidth;
      height = (width / aspectRatio);
    }

    if (height < minHeight) {
      height = minHeight;
      width = (height * aspectRatio);
    }

    Size result = Size(
      constrainWidth(width.pixelSnap(ps, PixelSnapMode.snap)),
      constrainHeight(
        height.pixelSnap(ps, PixelSnapMode.ceil),
      ),
    );
    return result;
  }
}

extension PixelSnapExtBorderSide on BorderSide {
  BorderSide pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderSide(
      color: color,
      width: width.pixelSnap(ps, mode),
      style: style,
      strokeAlign: strokeAlign,
    );
  }
}

extension PixelSnapExtRadius on Radius {
  Radius pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return Radius.elliptical(
      x.pixelSnap(ps, mode),
      y.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtBorder on Border {
  Border pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return Border(
      top: top.pixelSnap(ps, mode),
      right: right.pixelSnap(ps, mode),
      bottom: bottom.pixelSnap(ps, mode),
      left: left.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtBorderDireciton on BorderDirectional {
  BorderDirectional pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderDirectional(
      top: top.pixelSnap(ps, mode),
      start: start.pixelSnap(ps, mode),
      end: end.pixelSnap(ps, mode),
      bottom: bottom.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtBoxBorder on BoxBorder {
  BoxBorder pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is Border) {
      return (this as Border).pixelSnap(ps, mode);
    } else if (this is BorderDirectional) {
      return (this as BorderDirectional).pixelSnap(ps, mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtBoxShadow on BoxShadow {
  BoxShadow pixelSnap(PixelSnap ps, [PixelSnapMode mode = PixelSnapMode.snap]) {
    return BoxShadow(
      color: color,
      offset: offset.pixelSnap(ps, mode),
      blurRadius: blurRadius.pixelSnap(ps, mode),
      spreadRadius: spreadRadius.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtBoxDecoration on BoxDecoration {
  BoxDecoration pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return BoxDecoration(
      color: color,
      image: image,
      border: border?.pixelSnap(ps, mode),
      borderRadius: borderRadius?.pixelSnap(ps, mode),
      boxShadow:
          boxShadow?.map((e) => e.pixelSnap(ps, mode)).toList(growable: false),
      gradient: gradient,
      backgroundBlendMode: backgroundBlendMode,
      shape: shape,
    );
  }
}

extension PixelSnapExtDecoration on Decoration {
  Decoration pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is BoxDecoration) {
      return (this as BoxDecoration).pixelSnap(ps, mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtBordeRadiusGeometry on BorderRadiusGeometry {
  BorderRadiusGeometry pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is BorderRadius) {
      return (this as BorderRadius).pixelSnap(ps, mode);
    } else if (this is BorderRadiusDirectional) {
      return (this as BorderRadiusDirectional).pixelSnap(ps, mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtBorderRadius on BorderRadius {
  BorderRadius pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderRadius.only(
      topLeft: topLeft.pixelSnap(ps, mode),
      topRight: topRight.pixelSnap(ps, mode),
      bottomLeft: bottomLeft.pixelSnap(ps, mode),
      bottomRight: bottomRight.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapBorderRadiusDirecitonal on BorderRadiusDirectional {
  BorderRadiusDirectional pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderRadiusDirectional.only(
      topStart: topStart.pixelSnap(ps, mode),
      topEnd: topEnd.pixelSnap(ps, mode),
      bottomStart: bottomStart.pixelSnap(ps, mode),
      bottomEnd: bottomEnd.pixelSnap(ps, mode),
    );
  }
}

extension PixelSnapExtRoundedRectangleBorder on RoundedRectangleBorder {
  RoundedRectangleBorder pixelSnap(PixelSnap ps,
      [PixelSnapMode mode = PixelSnapMode.snap]) {
    return RoundedRectangleBorder(
      side: side.pixelSnap(ps, mode),
      borderRadius: borderRadius.pixelSnap(ps, mode),
    );
  }
}

class _PixelSnapAlignment extends Alignment {
  const _PixelSnapAlignment(super.x, super.y, this.ps);

  final PixelSnap ps;

  @override
  Offset alongOffset(Offset other) {
    return super.alongOffset(other).pixelSnap(ps);
  }

  @override
  Offset alongSize(Size other) {
    return super.alongSize(other).pixelSnap(ps);
  }

  @override
  Offset withinRect(Rect rect) {
    return super.withinRect(rect).pixelSnap(ps);
  }

  @override
  bool operator ==(Object other) {
    if (other is! _PixelSnapAlignment || other.ps != ps) {
      return false;
    } else {
      return super == other;
    }
  }

  @override
  int get hashCode => Object.hash(super.hashCode, ps);

  @override
  Rect inscribe(Size size, Rect rect) {
    final double halfWidthDelta = (rect.width - size.width) / 2.0;
    final double halfHeightDelta = (rect.height - size.height) / 2.0;
    return Rect.fromLTWH(
      (rect.left + halfWidthDelta + x * halfWidthDelta).pixelSnap(ps),
      (rect.top + halfHeightDelta + y * halfHeightDelta).pixelSnap(ps),
      size.width,
      size.height,
    );
  }
}

class _PixelSnapAlignmentDirectional extends AlignmentDirectional {
  const _PixelSnapAlignmentDirectional(super.start, super.y, this.ps);

  final PixelSnap ps;

  @override
  bool operator ==(Object other) {
    if (other is! _PixelSnapAlignmentDirectional || other.ps != ps) {
      return false;
    } else {
      return super == other;
    }
  }

  @override
  int get hashCode => Object.hash(super.hashCode, ps);

  @override
  Alignment resolve(TextDirection? direction) {
    return super.resolve(direction).pixelSnap(ps);
  }
}
