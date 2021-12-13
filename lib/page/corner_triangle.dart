import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/page/graphical.dart' as graphical;

const _extendedLine = 140.0;

/// Created by changlei on 2021/12/8.
///
/// 圆角三角形
class CornerTrianglePage extends StatelessWidget {
  /// 搞糟圆角三角形页面
  const CornerTrianglePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('cornerTriangle'),
      ),
      child: Center(
        child: SafeArea(
          bottom: false,
          child: CornerTriangle(),
        ),
      ),
    );
  }
}

/// 圆角三角形
class CornerTriangle extends StatelessWidget {
  /// 构造圆角三角形
  const CornerTriangle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true,
      scaleEnabled: true,
      constrained: true,
      clipBehavior: Clip.none,
      child: CustomPaint(
        size: const Size(200, 400),
        painter: _CornerTrianglePainter(
          radius: 20,
        ),
      ),
    );
  }
}

class _CornerTrianglePainter extends CustomPainter {
  _CornerTrianglePainter({
    required this.radius,
  }) : _paint = Paint()
          ..color = CupertinoColors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

  final double radius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    _paintBaseTriangle(canvas, width, height);
    _paintCircle(canvas, width, height, radius);
    _paintTriangle(canvas, width, height, radius);
  }

  @override
  bool shouldRepaint(covariant _CornerTrianglePainter oldDelegate) {
    return true;
  }

  void _paintBaseTriangle(Canvas canvas, double width, double height) {
    final path = Path();
    path.moveTo(0, 0);
    path.relativeLineTo(-width / 2, height);
    path.relativeLineTo(-_extendedLine, 0);
    path.relativeLineTo(width + _extendedLine * 2, 0);
    path.relativeLineTo(-_extendedLine, 0);
    path.close();
    // 中垂线
    path.relativeLineTo(0, height);

    canvas.drawPath(
      path.shift(Offset(width / 2, 0)),
      _paint..color = CupertinoColors.separator,
    );
  }

  void _paintCircle(Canvas canvas, double width, double height, double radius) {
    canvas.drawPath(
      graphical.circlePath(
        width: width,
        height: height,
        radius: radius,
        blRadius: radius * 3,
        brRadius: radius * 2,
      ),
      _paint..color = CupertinoColors.activeGreen,
    );
    canvas.drawPath(
      graphical.circlePath(
        width: width,
        height: height,
        radius: radius,
        blRadius: radius * 2,
        brRadius: radius * 3,
        avoidOffset: true,
      ),
      _paint..color = CupertinoColors.inactiveGray,
    );
  }

  void _paintTriangle(Canvas canvas, double width, double height, double radius) {
    canvas.drawPath(
      graphical.trianglePath(
        width: width,
        height: height,
        radius: radius,
        blRadius: radius * 3,
        brRadius: radius * 2,
      ),
      _paint..color = CupertinoColors.systemRed,
    );
    canvas.drawPath(
      graphical.trianglePath(
        width: width,
        height: height,
        radius: radius,
        blRadius: radius * 2,
        brRadius: radius * 3,
        avoidOffset: true,
      ),
      _paint..color = CupertinoColors.systemBlue,
    );
  }
}
