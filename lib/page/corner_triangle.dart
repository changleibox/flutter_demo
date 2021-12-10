import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

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
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

  final double radius;
  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path();
    path.moveTo(0, 0);
    path.relativeLineTo(-width / 2, height);
    path.relativeLineTo(-140, 0);
    path.relativeLineTo(width + 280, 0);
    path.relativeLineTo(-140, 0);
    path.close();
    path.relativeLineTo(0, height);

    _paint.color = CupertinoColors.separator;
    canvas.drawPath(
      path.shift(Offset(width / 2, 0)),
      _paint,
    );

    final radians = math.atan(width / 2 / height);
    final topCornerRadius = radius;

    final ae = topCornerRadius / math.tan(radians);
    final ao = ae / math.cos(radians);

    final pathCircle = Path();
    pathCircle.moveTo(0, 0);
    pathCircle.addOval(Rect.fromLTWH(0, 0, topCornerRadius * 2, topCornerRadius * 2));

    final path3 = pathCircle.shift(Offset(width / 2 - topCornerRadius, ao - topCornerRadius));
    final path4 = pathCircle.shift(
      Offset(-topCornerRadius / math.tan((math.pi / 2 - radians) / 2), height - topCornerRadius * 2),
    );

    final pathLeft = Path();
    pathLeft.addPath(path3, Offset.zero);
    pathLeft.addPath(path4, Offset.zero);

    final pathRight = pathLeft.transform(Matrix4.rotationY(math.pi).storage).shift(Offset(width, 0));

    _paint.color = CupertinoColors.activeGreen;
    canvas.drawPath(
      Path.combine(
        PathOperation.union,
        pathLeft,
        pathRight,
      ),
      _paint,
    );

    final path1 = _halfPath(width, height, radians, radius);
    final path2 = path1.transform(Matrix4.rotationY(math.pi).storage).shift(Offset(width, 0));

    _paint.color = CupertinoColors.systemRed;
    canvas.drawPath(
      Path.combine(PathOperation.union, path1, path2),
      _paint,
    );

    _paint.color = CupertinoColors.activeBlue;
    canvas.drawPath(
      _trianglePath(width, height, radians, radius),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerTrianglePainter oldDelegate) {
    return true;
  }

  Path _trianglePath(double width, double height, double radians, double radius) {
    final topCornerRadius = radius;

    final ae = topCornerRadius / math.tan(radians);
    final ao = ae / math.cos(radians);
    final ai = ao - topCornerRadius;

    final bf = width / 2;
    final of = height - ao;
    final fo1 = of + ai;
    final bo1 = math.sqrt(math.pow(fo1, 2) + math.pow(bf, 2));

    final bo1f = math.atan(bf / fo1);
    final bo1e = math.acos(topCornerRadius / bo1);

    final radians1 = bo1f + bo1e - math.pi / 2;
    final height1 = bf / math.tan(radians1);
    final path = _halfPath(width, height1, radians1, radius).shift(Offset(0, -ai - _paint.strokeWidth));
    return Path.combine(
      PathOperation.union,
      path,
      path.transform(Matrix4.rotationY(math.pi).storage).shift(Offset(width, 0)),
    );
  }

  Path _halfPath(double width, double height, double radians, double radius) {
    final topCornerRadius = radius;
    final bottomCornerRadius = radius * 2;

    final ae = topCornerRadius / math.tan(radians);
    final ao = ae / math.cos(radians);
    final ag = ae * math.cos(radians);
    final ai = ao - topCornerRadius;

    final bf = width / 2;
    final bk = bottomCornerRadius / math.tan(math.pi / 4 + radians / 2);
    final bj = bk * math.cos(math.pi / 2 - radians);

    final eg = ae * math.sin(radians);
    final kj = bk * math.sin(math.pi / 2 - radians);

    final i = Offset(bf, ai);
    final e = Offset(bf - eg, ag);
    final k = Offset(bj, height - kj);
    final l = Offset(-bk, height);

    return Path()
      ..moveTo(i.dx, i.dy)
      ..arcToPoint(e, radius: Radius.circular(topCornerRadius), clockwise: false)
      ..lineTo(k.dx, k.dy)
      ..arcToPoint(l, radius: Radius.circular(bottomCornerRadius))
      ..relativeLineTo(bk + bf, 0)
      ..close();
  }
}
