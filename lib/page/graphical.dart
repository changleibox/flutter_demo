import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Created by changlei on 2021/12/10.
///
/// 计算各种图形
Path circlePath(double width, double height, double radius) {
  return cornerPath(
    width,
    height,
    radius,
    paint: (path, ag, eg, ai) {
      path.addOval(Rect.fromLTWH(-radius, ai, radius * 2, radius * 2));
    },
  );
}

/// 三角形
Path trianglePath(double width, double height, [double radius = 0]) {
  return cornerPath(
    width,
    height,
    radius,
    paint: (path, ag, eg, ai) {
      path.moveTo(-eg, ag);
      path.arcToPoint(Offset(eg, ag), radius: Radius.circular(radius));
    },
    visitor: (path, top, left, rect) {
      path.addPolygon([top.bottomLeft, left.topRight], false);
      path.addPolygon([left.bottomLeft, rect.bottomCenter], false);
    },
  );
}

/// 补偿
double heightCompensate(double width, double height, [double radius = 0]) {
  final of = height - radius;
  final bf = width / 2;
  final bo = math.sqrt(math.pow(of, 2) + math.pow(bf, 2));
  final bof = math.atan(bf / of);
  final boe = math.acos(radius / bo);
  final newRadians = bof + boe - math.pi / 2;
  return bf / math.tan(newRadians);
}

/// 创建元素path
Path elementPath(
  double radians,
  double radius, {
  double rotation = 0,
  Offset offset = Offset.zero,
  void Function(Path path, double ag, double eg, double ai)? paint,
}) {
  final ae = radius / math.tan(radians);
  final ag = ae * math.cos(radians);
  final eg = ae * math.sin(radians);
  final ai = ae / math.cos(radians) - radius;
  final path = Path();
  paint?.call(path, ag, eg, ai);
  return path.transform(Matrix4.rotationZ(rotation).storage).shift(offset);
}

/// 创建各个角
Path cornerPath(
  double width,
  double height,
  double radius, {
  void Function(Path path, double ag, double eg, double ai)? paint,
  void Function(Path path, Rect top, Rect left, Rect rect)? visitor,
}) {
  final path = Path();
  final rect = Offset.zero & Size(width, height);
  final radians = math.atan(width / 2 / height);

  final topCorner = elementPath(
    radians,
    radius,
    rotation: 0,
    offset: rect.topCenter,
    paint: paint,
  );
  path.addPath(topCorner, Offset.zero);

  final leftCorner = elementPath(
    (math.pi / 2 + radians) / 2,
    radius,
    rotation: math.pi - (math.pi / 2 - radians) / 2,
    offset: rect.bottomLeft,
    paint: paint,
  );
  path.addPath(leftCorner, Offset.zero);

  visitor?.call(path, topCorner.getBounds(), leftCorner.getBounds(), rect);

  var halfPath = path.transform(Matrix4.rotationY(math.pi).storage);
  halfPath = halfPath.shift(Offset(width, 0));
  path.addPath(halfPath, Offset.zero);
  return path;
}
