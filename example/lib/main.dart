import 'package:pixel_perfect/material.dart';

void main() {
  // overrideDevicePixelRatio = 1.75;
  // overridePixelSnapFunction((p0) => p0);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return PixelPerfectDebugBar(
            child: Scaffold(
              body: Align(
                alignment: const Alignment(0, 0),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  padding: const EdgeInsets.all(20),
                  // child: Container(
                  //   padding: const EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.red, width: 1),
                  //   ),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   child: Container(
                      //     // width: 100,
                      //     // height: 100,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.red, width: 1)),
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 1)),
                        child: const Text('Hello!'),
                      ),
                      // const SizedBox(width: 5),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 1)),
                        child: const Text('Hello!'),
                      ),
                      // const SizedBox(width: 10),
                      // Expanded(
                      //   child: Container(
                      //     // width: 100,
                      //     // height: 100,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.red, width: 1)),
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 1)),
                        child: Column(
                          children: const [
                            Text('Hello'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // child: ListView.builder(
                  //   itemBuilder: (context, i) {
                  //     return Container(
                  //       decoration: const BoxDecoration(
                  //         border: Border(
                  //             bottom:
                  //                 BorderSide(color: Colors.red, width: 1.0)),
                  //       ),
                  //       padding: const EdgeInsets.all(10),
                  //       child: const PixelSnapSize(
                  //         child: Text('Hello World!'),
                  //       ),
                  //     );
                  //   },
                  //   itemCount: 200,
                  // ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
