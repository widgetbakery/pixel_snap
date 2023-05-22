import 'package:flutter/widgets.dart';

import '../pixel_snap.dart';

/// [ScrollController] subclass that creates instances of [PixelSnapScrollPosition].
class PixelSnapScrollController extends ScrollController {
  PixelSnapScrollController({
    super.initialScrollOffset = 0.0,
    super.keepScrollOffset = true,
    super.debugLabel,
  });

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return PixelSnapScrollPosition(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}

/// [ScrollPosition] subclass that snaps to nearest physical pixel.
class PixelSnapScrollPosition extends ScrollPositionWithSingleContext {
  PixelSnapScrollPosition({
    required super.physics,
    required super.context,
    super.keepScrollOffset,
    super.initialPixels,
    super.oldPosition,
    super.debugLabel,
  });

  @override
  double setPixels(double newPixels) {
    final ps = PixelSnap.of(context.storageContext);
    return super.setPixels(ps(newPixels));
  }

  @override
  void correctPixels(double value) {
    final ps = PixelSnap.of(context.storageContext);
    super.correctPixels(ps(value));
  }

  @override
  void correctBy(double correction) {
    final ps = PixelSnap.of(context.storageContext);
    super.correctBy(ps(correction));
  }

  @override
  void forcePixels(double value) {
    final ps = PixelSnap.of(context.storageContext);
    return super.forcePixels(ps(value));
  }
}
