import 'dart:developer' as log;
import 'dart:ui';
import 'dart:math' as math;
import 'package:custom_graph/main.dart';
import 'package:flutter/material.dart';

class CustomPaintWidget extends StatefulWidget {
  final List<int> data;
  Size? size;
  final Paint? graphPaint;
  final bool horizontalGuideLine;
  final Duration duration;

  CustomPaintWidget(
      {required this.data,
      required this.duration,
      this.size,
      this.graphPaint,
      this.horizontalGuideLine = false});

  @override
  State<CustomPaintWidget> createState() => _CustomPaintWidgetState();
}

class _CustomPaintWidgetState extends State<CustomPaintWidget>
    with SingleTickerProviderStateMixin {
  //https://blog.codemagic.io/flutter-custom-painter/

  AnimationController? _controller;

  //Graph Point Source
  List<int> data = [];
  Size? size;
  Paint? graphPaint;
  bool? horizontalGuideLine;

  //For Animation
  Animation<double>? animation;
  //For Animation Curves
  // Tween? scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
      ..addListener(() {
        // setState(() {});
        log.log("CONTROLLER VALUE : ${_controller!.value}");
      })
      ..animateTo(1, curve: Curves.easeOutQuart);

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller!..animateTo(1, curve: Curves.easeOutQuart));
    _controller!.value = 1.0;

    data = widget.data;
    size = widget.size;
    graphPaint = widget.graphPaint;
    horizontalGuideLine = widget.horizontalGuideLine;
    log.log("HERE");
  }

  get _deleteDuplicateElementLength => data.toSet().toList().length;

  @override
  Widget build(BuildContext context) {
    // return baseLayoutBuilder();

    return Column(
      children: [
        AnimatedBuilder(
            animation: _controller!,
            builder: (context, snapshot) {
              // return Transform.scale(
              //   scale: animation!.value,
              return CustomPaint(
                // painter: LinePainter(progress: _controller!.value),
                painter: MyPainter(
                  _controller!.value,
                  graphData: data,
                  yCount: _deleteDuplicateElementLength,
                  horizontalGuideLine: horizontalGuideLine!,
                ),
                size: size ?? Size(MediaQuery.of(context).size.width, 300),
              );
            }),
        Center(
          child: RaisedButton(
            child: Text('Animate'),
            onPressed: () {
              // _controller!.reset();
              _controller!.forward(from: 0.0);
            },
          ),
        ),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  //GraphData data length except DUPLICATED ELEMENT
  final int yCount;
  final List<int> graphData;
  final bool horizontalGuideLine;
  final double progress;
  List<Offset> graphPointOffset = [];
  int currentIndex = 0;

  //Constructor
  MyPainter(this.progress,
      {required this.graphData,
      required this.yCount,
      this.horizontalGuideLine = false});

  @override
  void paint(Canvas canvas, Size size) {
    //Widget Graph max height
    double dx = size.width;
    //Widget Graph max width
    double dy = size.height;

    graphPointOffset = _setGraphPointOffset(size.width, size.height);
    log.log("$graphPointOffset");

    var myPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    Path path = setGraphPath();
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      //Draw Point
      if (progress != 1) {
        _drawLeadingPoint(canvas, extractPath);
      }

      // if (showPath!) {
      canvas.drawPath(extractPath, myPaint);
    }

    // path.lineTo(size.width * progress, size.height / 2);
    // canvas.drawPath(path, myPaint);
    //Mutli Path
    // PathMetrics pathMetrics = path.computeMetrics();
    // for (PathMetric pathMetric in pathMetrics) {
    //   log.log("HERERE");
    //   //progressbar mix
    //   Path extractPath = pathMetric.extractPath(
    //     0.0,
    //     pathMetric.length * progress,
    //   );

    //   canvas.drawPath(extractPath, myPaint);
    // }

    // Paint _paint = Paint()
    //   ..color = Colors.green
    //   ..strokeWidth = 8.0;
    // canvas.drawLine(
    //     Offset(0.0, 0.0),
    //     Offset(size.width - size.width * progress,
    //         size.height - size.height * progress),
    //     _paint);
  }

  _drawLeadingPoint(Canvas canvas, Path extractPath) {
    var metric = extractPath.computeMetrics().first;
    final offset = metric.getTangentForOffset(metric.length)!.position;
    canvas.drawCircle(offset, 8.0, Paint());
  }

  //Offset about Graph Point
  List<Offset> _setGraphPointOffset(double maxWidth, double maxHeight) {
    List<Offset> result = [];
    double xInterval = maxWidth / (graphData.length);
    double yInterval = maxHeight / yCount;
    int maxElement = graphData.reduce(math.max);

    graphData.asMap().forEach((int index, int element) {
      result.add(Offset(
          xInterval * index, maxHeight - (maxHeight * (element / maxElement))));
    });

    return result;
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return true;
  }

  Path setGraphPath() {
    var path = Path();
    //   ..lineTo(graphPointOffset[1].dx, graphPointOffset[1].dy);
    graphPointOffset.asMap().forEach((int index, Offset element) {
      double x = graphPointOffset[index].dx;
      double y = graphPointOffset[index].dy;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    });
    return path;
  }
  //  graphPointOffset.asMap().forEach((int index, Offset element) {

  //  });
  //   for (Offset element in graphPointOffset) {
  //     path.lineTo(element.dx, element.dy);
  //   }
  //   return path;
  // }
}

class LinePainter extends CustomPainter {
  final double progress;

  LinePainter({required this.progress});

  Paint _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * progress, size.height / 2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
