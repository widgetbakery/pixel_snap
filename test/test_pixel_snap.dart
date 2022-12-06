import 'package:pixel_snap/src/internal.dart';

class TextPixelSnap extends PixelSnap {
  TextPixelSnap(this.ratio);

  @override
  void didChangeMetrics() {}

  @override
  double getSystemDevicePixelRatio() {
    return ratio;
  }

  final double ratio;
}
