import 'dart:developer';

import 'package:custom_graph/custompaint.dart';
import 'package:custom_graph/pathtest.dart';
import 'package:custom_graph/testing.dart';
import 'package:flutter/material.dart';

final containerKey = GlobalKey();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // const MyHomePage({Key? key}) : super(key: key);

  List<int> temp = [5, 1, 5, 40, 50, 30, 20, 10, 50];

  @override
  Widget build(BuildContext context) {
    // return AnimatedPathDemo();
    // return Circles();

    return Scaffold(
      body: CustomPaintWidget(data: temp, duration: const Duration(seconds: 1)),
      // body: Container(),
      // floatingActionButton: FloatingActionButton(onPressed: () {_controller!.reset()},child:const Icon(Icons.start)),
    );
    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         // Center(
    //         //     child: CustomPaintWidget(
    //         //   height: 100,
    //         //   width: 200,
    //         // )),
    //         SizedBox(
    //           height: 50,
    //         ),

    //         Container(
    //             child: CustomPaintWidget(
    //           data: temp,
    //         )),
    //         const SizedBox(
    //           height: 50,
    //         ),

    //         // Center(
    //         //     child: CustomPaintWidget(
    //         //   context,
    //         //   height: 100,
    //         //   width: 200,
    //         // )),
    //         // Center(
    //         //     child: CustomPaintWidget(
    //         //   context,
    //         //   height: 100,
    //         //   width: 200,
    //         // )),
    //         // SizedBox(
    //         //   height: 50,
    //         // )

    //         // child: CustomPaint(size: const Size(200, 100), painter: MyPainter()),
    //       ],
    //     ),
    //   ),
    // );
  }
}
