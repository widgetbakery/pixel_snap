import 'package:pixel_perfect/src/internal.dart';

class TextPixelPerfect extends PixelPerfect {
  TextPixelPerfect(this.ratio);

  @override
  void didChangeMetrics() {}

  @override
  double getSystemDevicePixelRatio() {
    return ratio;
  }

  final double ratio;
}
