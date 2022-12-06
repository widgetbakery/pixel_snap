import 'dart:math';

import 'package:flutter/rendering.dart' hide RenderFractionallySizedOverflowBox;
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_perfect/pixel_perfect.dart';
import 'package:pixel_perfect/src/forked/render_fractionally_sized_box.dart';
import 'package:pixel_perfect/src/internal.dart';

import 'test_pixel_perfect.dart';
import 'test_rendering.dart';

void main() {
  TestRenderingFlutterBinding.ensureInitialized();

  test('RenderFractionallySizedBox constraints', () {
    PixelPerfect.setInstance(TextPixelPerfect(1.0));

    RenderBox root, leaf, test;
    root = RenderPositionedBox(
      child: RenderConstrainedBox(
        additionalConstraints: BoxConstraints.tight(const Size(199.0, 175.0)),
        child: test = RenderFractionallySizedOverflowBox(
          widthFactor: 1.5,
          heightFactor: 0.5,
          child: leaf = RenderConstrainedBox(
            additionalConstraints: const BoxConstraints.expand(),
          ),
        ),
      ),
    );
    layout(root);
    expect(root.size.width, equals(800.0));
    expect(root.size.height, equals(600.0));
    expect(test.size.width, equals(199.0));
    expect(test.size.height, equals(175.0));
    expect(leaf.size.width, equals(298.0));
    expect(leaf.size.height, equals(87.0));
  });

  test('RenderPixelSnapSize', () {
    PixelPerfect.setInstance(TextPixelPerfect(1.0));
    double pixelSnap(double value) =>
        PixelPerfect.instance.pixelSnap(value, PixelSnapMode.snap);
    RenderBox snapSize;
    final root = RenderPositionedBox(
      child: snapSize = RenderPixelSnapSize(
        RenderConstrainedBox(
            additionalConstraints:
                const BoxConstraints.tightFor(width: 99.2, height: 99.8)),
        pixelSnap,
      ),
    );
    layout(root);

    expect(snapSize.size.width, 99.0);
    expect(snapSize.size.height, 100.0);
  });

  test('Alignment centers on pixel boundary', () {
    PixelPerfect.setInstance(TextPixelPerfect(1.0));
    RenderBox box;
    final root = RenderPositionedBox(
      alignment: Alignment.center.pixelSnap(),
      child: box = RenderConstrainedBox(
          additionalConstraints:
              const BoxConstraints.tightFor(width: 11, height: 13)),
    );
    layout(root);

    expect((box.parentData as BoxParentData).offset.dx, equals(394));
    expect((box.parentData as BoxParentData).offset.dy, equals(293));
  });
}
