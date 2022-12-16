import 'package:flutter/rendering.dart';

import 'internal.dart';

enum PixelSnapMode {
  /// Snap to the nearest pixel.
  snap,

  /// Snap to the nearest pixel, rounding up.
  ceil,

  /// Snap to the nearest pixel, rounding down.
  floor,
}

extension PixelSnapExtNum on num {
  double pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return PixelSnap.instance.pixelSnap(toDouble(), mode);
  }

  double get ps => pixelSnap();
}

extension PixelSnapExtOffset on Offset {
  Offset pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return Offset(
      dx.pixelSnap(mode),
      dy.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtSize on Size {
  Size pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return Size(
      width.pixelSnap(mode),
      height.pixelSnap(mode),
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
  Rect pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return Rect.fromLTRB(
      left.pixelSnap(mode.reverse),
      top.pixelSnap(mode.reverse),
      right.pixelSnap(mode),
      bottom.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtAlignmentGeometry on AlignmentGeometry {
  AlignmentGeometry pixelSnap() {
    if (this is Alignment) {
      return (this as Alignment).pixelSnap();
    } else if (this is AlignmentDirectional) {
      return (this as Alignment).pixelSnap();
    } else {
      return this;
    }
  }
}

extension PixelSnapExtAlignment on Alignment {
  Alignment pixelSnap() => PixelSnapAlignment(x, y);
}

extension PixelSnapExtAlignmentDirctional on AlignmentDirectional {
  AlignmentDirectional pixelSnap() => PixelSnapAlignmentDirectional(start, y);
}

extension PixelSnapExtEdgeInsetsGeometry on EdgeInsetsGeometry {
  EdgeInsetsGeometry pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is EdgeInsets) {
      return (this as EdgeInsets).pixelSnap(mode);
    } else if (this is EdgeInsetsDirectional) {
      return (this as EdgeInsetsDirectional).pixelSnap(mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtEdgeInsets on EdgeInsets {
  EdgeInsets pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return EdgeInsets.only(
      left: left.pixelSnap(mode),
      top: top.pixelSnap(mode),
      right: right.pixelSnap(mode),
      bottom: bottom.pixelSnap(mode),
    );
  }
}

extension PixelSnapEdgeInsetDirectional on EdgeInsetsDirectional {
  EdgeInsetsDirectional pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return EdgeInsetsDirectional.only(
      start: start.pixelSnap(mode),
      top: top.pixelSnap(mode),
      end: end.pixelSnap(mode),
      bottom: bottom.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtConstraints on BoxConstraints {
  BoxConstraints pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return BoxConstraints(
      minWidth: minWidth.pixelSnap(mode),
      maxWidth: maxWidth.pixelSnap(mode),
      minHeight: minHeight.pixelSnap(mode),
      maxHeight: maxHeight.pixelSnap(mode),
    );
  }

  /// Returns a size that attempts to meet the following conditions, in order:
  ///
  ///  * The size must satisfy these constraints.
  ///  * The aspect ratio of the returned size matches the aspect ratio of the
  ///    given size.
  ///  * The returned size as big as possible while still being equal to or
  ///    smaller than the given size.
  Size pixelSnapConstrainSizeAndAttemptToPreserveAspectRatio(Size size) {
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
      constrainWidth(width.pixelSnap(PixelSnapMode.snap)),
      constrainHeight(
        height.pixelSnap(PixelSnapMode.ceil),
      ),
    );
    return result;
  }
}

extension PixelSnapExtBorderSide on BorderSide {
  BorderSide pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderSide(
      color: color,
      width: width.pixelSnap(mode),
      style: style,
      strokeAlign: strokeAlign,
    );
  }
}

extension PixelSnapExtRadius on Radius {
  Radius pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return Radius.elliptical(
      x.pixelSnap(mode),
      y.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtBorder on Border {
  Border pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return Border(
      top: top.pixelSnap(mode),
      right: right.pixelSnap(mode),
      bottom: bottom.pixelSnap(mode),
      left: left.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtBorderDireciton on BorderDirectional {
  BorderDirectional pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderDirectional(
      top: top.pixelSnap(mode),
      start: start.pixelSnap(mode),
      end: end.pixelSnap(mode),
      bottom: bottom.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtBoxBorder on BoxBorder {
  BoxBorder pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is Border) {
      return (this as Border).pixelSnap(mode);
    } else if (this is BorderDirectional) {
      return (this as BorderDirectional).pixelSnap(mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtBoxShadow on BoxShadow {
  BoxShadow pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return BoxShadow(
      color: color,
      offset: offset.pixelSnap(mode),
      blurRadius: blurRadius.pixelSnap(mode),
      spreadRadius: spreadRadius.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtBoxDecoration on BoxDecoration {
  BoxDecoration pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return BoxDecoration(
      color: color,
      image: image,
      border: border?.pixelSnap(mode),
      borderRadius: borderRadius?.pixelSnap(mode),
      boxShadow:
          boxShadow?.map((e) => e.pixelSnap(mode)).toList(growable: false),
      gradient: gradient,
      backgroundBlendMode: backgroundBlendMode,
      shape: shape,
    );
  }
}

extension PixelSnapExtDecoration on Decoration {
  Decoration pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is BoxDecoration) {
      return (this as BoxDecoration).pixelSnap(mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtBordeRadiusGeometry on BorderRadiusGeometry {
  BorderRadiusGeometry pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    if (this is BorderRadius) {
      return (this as BorderRadius).pixelSnap(mode);
    } else if (this is BorderRadiusDirectional) {
      return (this as BorderRadiusDirectional).pixelSnap(mode);
    } else {
      return this;
    }
  }
}

extension PixelSnapExtBorderRadius on BorderRadius {
  BorderRadius pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderRadius.only(
      topLeft: topLeft.pixelSnap(mode),
      topRight: topRight.pixelSnap(mode),
      bottomLeft: bottomLeft.pixelSnap(mode),
      bottomRight: bottomRight.pixelSnap(mode),
    );
  }
}

extension PixelSnapBorderRadiusDirecitonal on BorderRadiusDirectional {
  BorderRadiusDirectional pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return BorderRadiusDirectional.only(
      topStart: topStart.pixelSnap(mode),
      topEnd: topEnd.pixelSnap(mode),
      bottomStart: bottomStart.pixelSnap(mode),
      bottomEnd: bottomEnd.pixelSnap(mode),
    );
  }
}

extension PixelSnapExtRoundedRectangleBorder on RoundedRectangleBorder {
  RoundedRectangleBorder pixelSnap([PixelSnapMode mode = PixelSnapMode.snap]) {
    return RoundedRectangleBorder(
      side: side.pixelSnap(mode),
      borderRadius: borderRadius.pixelSnap(mode),
    );
  }
}

class PixelSnapAlignment extends Alignment {
  const PixelSnapAlignment(super.x, super.y);

  @override
  Offset alongOffset(Offset other) {
    return super.alongOffset(other).pixelSnap();
  }

  @override
  Offset alongSize(Size other) {
    return super.alongSize(other).pixelSnap();
  }

  @override
  Offset withinRect(Rect rect) {
    return super.withinRect(rect).pixelSnap();
  }

  @override
  Rect inscribe(Size size, Rect rect) {
    final double halfWidthDelta = (rect.width - size.width) / 2.0;
    final double halfHeightDelta = (rect.height - size.height) / 2.0;
    return Rect.fromLTWH(
      (rect.left + halfWidthDelta + x * halfWidthDelta).pixelSnap(),
      (rect.top + halfHeightDelta + y * halfHeightDelta).pixelSnap(),
      size.width,
      size.height,
    );
  }
}

class PixelSnapAlignmentDirectional extends AlignmentDirectional {
  const PixelSnapAlignmentDirectional(super.start, super.y);

  @override
  Alignment resolve(TextDirection? direction) {
    return super.resolve(direction).pixelSnap();
  }
}
