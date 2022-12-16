import 'package:flutter/widgets.dart';

class GeneratePixelSnap<T> {
  const GeneratePixelSnap();
}

class GeneratePixelSnapFork<T> {
  const GeneratePixelSnapFork();
}

// Feeds widget generation.
@GeneratePixelSnap<Align>()
@GeneratePixelSnap<Baseline>()
@GeneratePixelSnap<ConstrainedBox>()
@GeneratePixelSnap<DecoratedBox>()
@GeneratePixelSnap<Container>()
@GeneratePixelSnap<FittedBox>()
@GeneratePixelSnap<IntrinsicWidth>()
@GeneratePixelSnap<LimitedBox>()
@GeneratePixelSnap<OverflowBox>()
@GeneratePixelSnap<Padding>()
@GeneratePixelSnap<SizedBox>()
@GeneratePixelSnap<SizedOverflowBox>()
@GeneratePixelSnap<Positioned>()
@GeneratePixelSnap<PhysicalModel>()
@GeneratePixelSnap<CustomPaint>()
@GeneratePixelSnap<Icon>()
@GeneratePixelSnap<ImageIcon>()
@GeneratePixelSnap<AnimatedAlign>()
@GeneratePixelSnap<AnimatedContainer>()
@GeneratePixelSnap<AnimatedCrossFade>()
@GeneratePixelSnap<AnimatedPositioned>()
@GeneratePixelSnap<AnimatedPhysicalModel>()
@GeneratePixelSnap<AnimatedSize>()
@GeneratePixelSnapFork<Flex>()
@GeneratePixelSnapFork<Row>()
@GeneratePixelSnapFork<Column>()
@GeneratePixelSnapFork<FractionallySizedBox>()
@GeneratePixelSnapFork<Center>()
@GeneratePixelSnapFork<Text>()
@GeneratePixelSnapFork<RichText>()
@GeneratePixelSnapFork<Image>()
void generate() {}
