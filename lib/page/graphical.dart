import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Created by changlei on 2021/12/10.
///
/// 计算各种图形
Path circlePath(double width, double height, double radius, [bool avoidOffset = false]) {
  final path = cornerPath(
    width: width,
    height: height,
    radius: radius,
    avoidOffset: avoidOffset,
    visitor: (path, top, left) {
      final topRect = top.outerRect;
      final leftRect = left.outerRect;
      final topRadius = top.tlRadius;
      final leftRadius = left.blRadius;
      path.addOval(Rect.fromLTWH(
        topRect.left,
        topRect.top,
        topRadius.x * 2,
        topRadius.y * 2,
      ));
      path.addOval(Rect.fromLTWH(
        leftRect.left - leftRadius.x,
        leftRect.bottom - leftRadius.y * 2,
        leftRadius.x * 2,
        leftRadius.y * 2,
      ));
    },
  );
  return Path.combine(
    PathOperation.union,
    path,
    path.rotationY(math.pi).shift(Offset(width, 0)),
  );
}

/// 三角形
Path trianglePath(double width, double height, [double radius = 0, bool avoidOffset = false]) {
  final path = cornerPath(
    width: width,
    height: height,
    radius: radius,
    avoidOffset: avoidOffset,
    visitor: (path, top, left) {
      final topRect = top.outerRect;
      final leftRect = left.outerRect;
      final topRadius = top.tlRadius;
      final leftRadius = left.blRadius;
      final topCenter = topRect.topCenter;
      path.moveTo(topCenter.dx, topRect.top);
      path.arcToPoint(topRect.bottomLeft, radius: topRadius, clockwise: false);
      path.lineTo(leftRect.right, leftRect.top);
      path.arcToPoint(leftRect.bottomLeft, radius: leftRadius);
      path.lineTo(topCenter.dx, leftRect.bottom);
      path.close();
    },
  );
  return Path.combine(
    PathOperation.union,
    path,
    path.rotationY(math.pi).shift(Offset(width, 0)),
  );
}

/// 创建各个角
Path cornerPath({
  required double width,
  required double height,
  required double radius,
  bool avoidOffset = false,
  void Function(Path path, RRect top, RRect left)? visitor,
}) {
  if (avoidOffset) {
    final offset = _noOffset(width, height, radius);
    return cornerPath(
      width: width,
      height: offset,
      radius: radius,
      visitor: visitor,
      avoidOffset: false,
    ).shift(Offset(0, height - offset));
  }
  final radians = math.atan(width / 2 / height);
  final topRadius = radius;
  final leftRadius = radius * 6;

  final topCorner = boundedPath(
    radians: radians,
    radius: topRadius,
    rotation: 0,
    offset: Offset(width / 2, 0),
  );

  final leftCorner = boundedPath(
    radians: (math.pi / 2 + radians) / 2,
    radius: leftRadius,
    rotation: math.pi - (math.pi / 2 - radians) / 2,
    offset: Offset(0, height),
  );

  final path = Path();
  final top = topCorner.getBounds();
  final left = leftCorner.getBounds();
  visitor?.call(
    path,
    RRect.fromRectAndRadius(top, Radius.circular(topRadius)),
    RRect.fromRectAndRadius(left, Radius.circular(leftRadius)),
  );
  return path;
}

/// 创建元素path
Path boundedPath({
  required double radians,
  required double radius,
  double rotation = 0,
  Offset offset = Offset.zero,
  bool avoidOffset = false,
}) {
  final ae = radius / math.tan(radians);
  final ag = ae * math.cos(radians);
  final eg = ae * math.sin(radians);

  final path = Path();
  path.moveTo(-eg, ag);
  path.arcToPoint(
    Offset(eg, ag),
    radius: Radius.circular(radius),
  );
  return path.rotationZ(rotation).shift(offset);
}

/// 补偿
double _noOffset(double width, double height, double radius) {
  final of = height - radius;
  final bf = width / 2;
  final bo = math.sqrt(math.pow(of, 2) + math.pow(bf, 2));
  final bof = math.atan(bf / of);
  final boe = math.acos(radius / bo);
  final newRadians = bof + boe - math.pi / 2;
  return bf / math.tan(newRadians);
}

/// 扩展path
extension _PathExtension on Path {
  /// [Matrix4.rotationY]
  Path rotationY(double radians) {
    return transform(Matrix4.rotationY(radians).storage);
  }

  /// [Matrix4.rotationZ]
  Path rotationZ(double radians) {
    return transform(Matrix4.rotationZ(radians).storage);
  }
}
