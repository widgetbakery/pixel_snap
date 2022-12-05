import 'package:pixel_perfect/material.dart';

void main() {
  runApp(const MainApp());
}

const _simpleDecoration = BoxDecoration(
  border: Border.fromBorderSide(BorderSide(color: Colors.black, width: 1)),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PixelPerfectDebugBar(
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: _simpleDecoration,
                  width: 40,
                  height: 20,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(10).copyWith(top: 0),
                  decoration: _simpleDecoration,
                  width: 80,
                  height: 20,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: _simpleDecoration,
                    width: 51,
                    height: 7,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10).copyWith(top: 0),
                decoration: _simpleDecoration,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: _simpleDecoration,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10).copyWith(top: 0),
                decoration: _simpleDecoration,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.all(4),
                      decoration: _simpleDecoration,
                      width: 40,
                      height: 10,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10).copyWith(top: 0),
                decoration: _simpleDecoration,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.all(4),
                      decoration: _simpleDecoration,
                      width: 40,
                      height: 10,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10).copyWith(top: 0),
                decoration: _simpleDecoration,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.all(4),
                      decoration: _simpleDecoration,
                      width: 40,
                      height: 10,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(10).copyWith(top: 0),
                  decoration: _simpleDecoration,
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    alignment: Alignment.center,
                    widthFactor: 0.7,
                    heightFactor: 0.7,
                    child: Container(
                      decoration: _simpleDecoration,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.all(10).copyWith(top: 0),
                  decoration: _simpleDecoration,
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    alignment: Alignment.center,
                    widthFactor: 0.7,
                    heightFactor: 0.7,
                    child: Container(
                      decoration: _simpleDecoration,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
