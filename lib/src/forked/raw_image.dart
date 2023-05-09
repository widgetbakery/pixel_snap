import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter/widgets.dart' hide RawImage;

import '../pixel_snap.dart';
import '../pixel_snap_ext.dart';
import 'render_image.dart';

/// A widget that displays a [dart:ui.Image] directly.
///
/// The image is painted using [paintImage], which describes the meanings of the
/// various fields on this class in more detail.
///
/// The [image] is not disposed of by this widget. Creators of the widget are
/// expected to call [Image.dispose] on the [image] once the [RawImage] is no
/// longer buildable.
///
/// This widget is rarely used directly. Instead, consider using [Image].
class RawImage extends widgets.RawImage {
  const RawImage({
    super.key,
    super.image,
    super.debugImageLabel,
    super.width,
    super.height,
    super.scale = 1.0,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment = Alignment.center,
    super.repeat = ImageRepeat.noRepeat,
    super.centerSlice,
    super.matchTextDirection = false,
    super.invertColors = false,
    super.filterQuality = FilterQuality.low,
    super.isAntiAlias = false,
  });

  @override
  RenderImagePixelSnap createRenderObject(BuildContext context) {
    final pixelSnap = PixelSnap.of(context);
    return RenderImagePixelSnap(
      pixelSnap: PixelSnap.of(context),
      image: image?.clone(),
      debugImageLabel: debugImageLabel,
      width: width?.pixelSnap(pixelSnap),
      height: height?.pixelSnap(pixelSnap),
      scale: scale,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment.pixelSnap(pixelSnap),
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      textDirection: matchTextDirection || alignment is! Alignment
          ? Directionality.of(context)
          : null,
      invertColors: invertColors,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  @override
  void updateRenderObject(
      widgets.BuildContext context, RenderImagePixelSnap renderObject) {
    final pixelSnap = PixelSnap.of(context);
    assert(
      image?.debugGetOpenHandleStackTraces()?.isNotEmpty ?? true,
      'Creator of a RawImage disposed of the image when the RawImage still '
      'needed it.',
    );
    renderObject
      ..image = image?.clone()
      ..debugImageLabel = debugImageLabel
      ..width = width?.pixelSnap(pixelSnap)
      ..height = height?.pixelSnap(pixelSnap)
      ..scale = scale
      ..color = color
      ..opacity = opacity
      ..colorBlendMode = colorBlendMode
      ..fit = fit
      ..alignment = alignment.pixelSnap(pixelSnap)
      ..repeat = repeat
      ..centerSlice = centerSlice
      ..matchTextDirection = matchTextDirection
      ..textDirection = matchTextDirection || alignment is! Alignment
          ? Directionality.of(context)
          : null
      ..invertColors = invertColors
      ..isAntiAlias = isAntiAlias
      ..filterQuality = filterQuality;
  }
}
