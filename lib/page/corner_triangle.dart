import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

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
    return CustomPaint(
      size: const Size(400, 400),
      painter: _CornerTrianglePainter(
        radius: 20,
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

    _paintTriangle(canvas, width, height);
    _paintCircle(canvas, width, height, radius);
    _paintRadiusTriangle(canvas, width, height, radius);
  }

  @override
  bool shouldRepaint(covariant _CornerTrianglePainter oldDelegate) {
    return true;
  }

  void _paintTriangle(Canvas canvas, double width, double height) {
    final path = Path();
    path.moveTo(0, 0);
    path.relativeLineTo(-width / 2, height);
    path.relativeLineTo(-_extendedLine, 0);
    path.relativeLineTo(width + _extendedLine * 2, 0);
    path.relativeLineTo(-_extendedLine, 0);
    path.close();
    path.relativeLineTo(0, height);

    canvas.drawPath(
      path.shift(Offset(width / 2, 0)),
      _paint..color = CupertinoColors.separator,
    );
  }

  void _paintCircle(Canvas canvas, double width, double height, double radius) {
    final radians = math.atan(width / 2 / height);
    final path = Path();
    final topCircle = _circlePath(
      radians,
      radius,
      offset: Offset(width / 2, 0),
    );
    path.addPath(topCircle, Offset.zero);
    final leftCircle = _circlePath(
      (math.pi / 2 + radians) / 2,
      radius,
      rotation: math.pi - (math.pi / 2 - radians) / 2,
      offset: Offset(0, height),
    );
    path.addPath(leftCircle, Offset.zero);

    var halfPath = path.transform(Matrix4.rotationY(math.pi).storage);
    halfPath = halfPath.shift(Offset(width, 0));
    path.addPath(halfPath, Offset.zero);

    canvas.drawPath(
      path,
      _paint..color = CupertinoColors.activeGreen,
    );
  }

  Path _circlePath(double radians, double radius, {double rotation = 0, Offset offset = Offset.zero}) {
    final ao = radius / math.tan(radians) / math.cos(radians);
    final ai = ao - radius;
    final path = Path();
    path.addOval(Rect.fromLTWH(-radius, ai, radius * 2, radius * 2));

    return path.transform(Matrix4.rotationZ(rotation).storage).shift(offset);
  }

  void _paintRadiusTriangle(Canvas canvas, double width, double height, double radius) {
    canvas.drawPath(
      _radiusTrianglePath(width, height, radius),
      _paint..color = CupertinoColors.systemRed,
    );

    final outerHeight = _outerHeight(width, height, radius);
    canvas.drawPath(
      _radiusTrianglePath(width, outerHeight, radius).shift(Offset(0, height - outerHeight)),
      _paint..color = CupertinoColors.systemBlue,
    );
  }

  double _outerHeight(double width, double height, double radius) {
    final of = height - radius;
    final bf = width / 2;
    final bo = math.sqrt(math.pow(of, 2) + math.pow(bf, 2));
    final bof = math.atan(bf / of);
    final boe = math.acos(radius / bo);
    final newRadians = bof + boe - math.pi / 2;
    return bf / math.tan(newRadians);
  }

  Path _radiansPath(double radians, double radius, {double rotation = 0, Offset offset = Offset.zero}) {
    final ae = radius / math.tan(radians);
    final ag = ae * math.cos(radians);
    final eg = ae * math.sin(radians);
    final path = Path();
    path.moveTo(-eg, ag);
    path.arcToPoint(Offset(eg, ag), radius: Radius.circular(radius));

    return path.transform(Matrix4.rotationZ(rotation).storage).shift(offset);
  }

  Path _radiusTrianglePath(double width, double height, double radius) {
    final path = Path();
    final rect = Offset.zero & Size(width, height);
    final radians = math.atan(width / 2 / height);

    final topCorner = _radiansPath(
      radians,
      radius,
      rotation: 0,
      offset: rect.topCenter,
    );
    path.addPath(topCorner, Offset.zero);

    final leftCorner = _radiansPath(
      (math.pi / 2 + radians) / 2,
      radius,
      rotation: math.pi - (math.pi / 2 - radians) / 2,
      offset: rect.bottomLeft,
    );
    path.addPath(leftCorner, Offset.zero);

    path.addPolygon([topCorner.getBounds().bottomLeft, leftCorner.getBounds().topRight], false);
    path.addPolygon([leftCorner.getBounds().bottomLeft, rect.bottomCenter], false);

    var halfPath = path.transform(Matrix4.rotationY(math.pi).storage);
    halfPath = halfPath.shift(Offset(width, 0));
    path.addPath(halfPath, Offset.zero);
    return path;
  }
}
