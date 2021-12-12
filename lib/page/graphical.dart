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
    visitor: (path, top, left, right) {
      path.addOval(top.circle);
      path.addOval(left.circle);
    },
  );
  return path.mirrorY(width / 2);
}

/// 三角形
Path trianglePath(double width, double height, [double radius = 0, bool avoidOffset = false]) {
  final path = cornerPath(
    width: width,
    height: height,
    radius: radius,
    avoidOffset: avoidOffset,
    visitor: (path, top, left, right) {
      top.middle.moveTo(path);
      top.begin.arcToPoint(path, radius: Radius.circular(top.radius), clockwise: false);
      left.begin.lineTo(path);
      left.end.arcToPoint(path, radius: Radius.circular(left.radius), clockwise: true);
      path.lineTo(top.middle.dx, left.end.dy);
      path.close();
    },
  );
  return path.mirrorY(width / 2);
}

/// 创建各个角
Path cornerPath({
  required double width,
  required double height,
  required double radius,
  bool avoidOffset = false,
  void Function(Path path, ArcPoint top, ArcPoint left, ArcPoint right)? visitor,
}) {
  final size = Size(width, height);
  final topRadius = radius;
  final leftRadius = radius * 6;

  final topRadians = size.semiRadians;
  final topOffset = Offset(width / 2, 0);
  final top = ArcPoint.fromSize(size, topRadius, avoidOffset: avoidOffset).shift(topOffset);

  final leftRadians = (math.pi / 2 + topRadians) / 2;
  final leftRotation = math.pi / 2 + leftRadians;
  final leftOffset = Offset(0, height);
  final left = ArcPoint.fromRadians(leftRadians, leftRadius).rotationZ(leftRotation).shift(leftOffset);

  final right = left.rotationY(math.pi).shift(Offset(width, 0));

  final path = Path();
  visitor?.call(path, top, left, right);
  return path;
}

/// 绘制圆弧的坐标信息
class ArcPoint {
  /// 构造[ArcPoint]，[begin]和[end]分别为角内切圆与两边的切点，[middle]为角平分线与内切圆的交点
  ArcPoint._({
    required this.begin,
    required this.middle,
    required this.end,
  }) : center = middle.center(begin, end);

  /// 根据一个角度和角内切圆的半径构建一个[ArcPoint]，[radians]为角对应的弧度，[radius]内切圆半径
  factory ArcPoint.fromRadians(double radians, double radius) {
    final ae = radius / math.tan(radians);
    final ag = ae * math.cos(radians);
    final eg = ae * math.sin(radians);
    final ai = ae / math.cos(radians) - radius;

    return ArcPoint._(
      begin: Offset(-eg, ag),
      middle: Offset(0, ai),
      end: Offset(eg, ag),
    );
  }

  /// 根据一个角度和角内切圆的半径构建一个[ArcPoint]，以[size]作为等腰三角形的底和高计算顶角的弧度，[radius]内切圆半径
  factory ArcPoint.fromSize(Size size, double radius, {bool avoidOffset = false}) {
    final width = size.width;
    final height = size.height;
    var offsetHeight = height;
    if (avoidOffset) {
      offsetHeight = ArcPoint.avoidOffset(size, radius);
    }
    final radians = Size(width, offsetHeight).semiRadians;
    return ArcPoint.fromRadians(radians, radius).shift(Offset(0, height - offsetHeight));
  }

  /// start point
  final Offset begin;

  /// middle point
  final Offset middle;

  /// end point
  final Offset end;

  /// 圆心
  final Offset center;

  /// radius
  double get radius => (center - middle).distance.abs();

  /// 内切圆
  Rect get circle => Rect.fromCircle(center: center, radius: radius);

  /// 角的弧度
  double get radians {
    final distance = (begin - middle).distance / 2;
    return 2 * math.acos(distance / radius) - math.pi / 2;
  }

  /// 旋转的弧度
  double get rotation {
    return ((begin - end).direction + math.pi) % (2 * math.pi);
  }

  /// 原点
  Offset get origin {
    final dy = radius / math.sin(radians);
    return Offset(
      center.dx + dy * math.sin(rotation),
      center.dy - dy * math.cos(rotation),
    );
  }

  /// 边界
  Rect get bounds {
    final dxs = [begin.dx, middle.dx, end.dx];
    final dys = [begin.dy, middle.dy, end.dy];
    return Rect.fromLTRB(
      dxs.reduce(math.min),
      dys.reduce(math.min),
      dxs.reduce(math.max),
      dys.reduce(math.max),
    );
  }

  /// Returns a new [ArcPoint] translated by the given offset.
  ///
  /// To translate a rectangle by separate x and y components rather than by an
  /// [Offset], consider [translate].
  ArcPoint shift(Offset offset) {
    return ArcPoint._(
      begin: begin + offset,
      middle: middle + offset,
      end: end + offset,
    );
  }

  /// 绕着Z轴顺时针旋转[radians]
  ArcPoint rotationX(double radians) {
    return ArcPoint._(
      begin: begin.rotationX(radians),
      middle: middle.rotationX(radians),
      end: end.rotationX(radians),
    );
  }

  /// 绕着Z轴顺时针旋转[radians]
  ArcPoint rotationY(double radians) {
    return ArcPoint._(
      begin: begin.rotationY(radians),
      middle: middle.rotationY(radians),
      end: end.rotationY(radians),
    );
  }

  /// 绕着Z轴顺时针旋转[radians]
  ArcPoint rotationZ(double radians) {
    return ArcPoint._(
      begin: begin.rotationZ(radians),
      middle: middle.rotationZ(radians),
      end: end.rotationZ(radians),
    );
  }

  /// 补偿
  static double avoidOffset(Size size, double radius) {
    size = Size(size.width / 2, size.height - radius);
    final bof = size.radians;
    final boe = math.acos(radius / size.distance);
    return size.width / math.tan(bof + boe - math.pi / 2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArcPoint &&
          runtimeType == other.runtimeType &&
          begin == other.begin &&
          middle == other.middle &&
          end == other.end;

  @override
  int get hashCode => begin.hashCode ^ middle.hashCode ^ end.hashCode;
}

/// 扩展Size
extension SizeExtension on Size {
  /// 半角
  double get semiRadians => flipped.centerRight(Offset.zero).direction;

  /// 半角
  double get radians => flipped.bottomRight(Offset.zero).direction;

  /// The magnitude of the offset.
  ///
  /// If you need this value to compare it to another [Offset]'s distance,
  /// consider using [distanceSquared] instead, since it is cheaper to compute.
  double get distance => bottomRight(Offset.zero).distance;
}

/// 扩展Offset
extension OffsetExtension on Offset {
  /// 绕X轴旋转
  Offset rotationX(double radians) {
    return Offset(dx, dy * math.cos(radians));
  }

  /// 绕Y轴旋转
  Offset rotationY(double radians) {
    return Offset(dx * math.cos(radians), dy);
  }

  /// 绕Z轴旋转
  Offset rotationZ(double radians) {
    final cos = math.cos(radians);
    final sin = math.sin(radians);
    return Offset(
      dx * cos - dy * sin,
      dy * cos + dx * sin,
    );
  }

  /// 根据圆上三个点计算圆心
  Offset center(Offset point1, Offset point2) {
    final x1 = point1.dx;
    final y1 = point1.dy;
    final x2 = point2.dx;
    final y2 = point2.dy;
    final x3 = this.dx;
    final y3 = this.dy;

    final a = 2 * (x2 - x1);
    final b = 2 * (y2 - y1);
    final c = math.pow(x2, 2) + math.pow(y2, 2) - math.pow(x1, 2) - math.pow(y1, 2);
    final d = 2 * (x3 - x2);
    final e = 2 * (y3 - y2);
    final f = math.pow(x3, 2) + math.pow(y3, 2) - math.pow(x2, 2) - math.pow(y2, 2);
    final dx = (b * f - e * c) / (b * d - e * a);
    final dy = (d * c - a * f) / (b * d - e * a);
    return Offset(dx, dy);
  }

  /// [Path.moveTo]
  void moveTo(Path path) {
    path.moveTo(dx, dy);
  }

  /// [Path.lineTo]
  void lineTo(Path path) {
    path.lineTo(dx, dy);
  }

  /// [Path.arcToPoint]
  void arcToPoint(
    Path path, {
    Radius radius = Radius.zero,
    double rotation = 0.0,
    bool largeArc = false,
    bool clockwise = true,
  }) {
    path.arcToPoint(
      this,
      radius: radius,
      rotation: rotation,
      largeArc: largeArc,
      clockwise: clockwise,
    );
  }
}

/// 扩展path
extension PathExtension on Path {
  /// [Matrix4.rotationX]
  Path rotationX(double radians) {
    return transform(Matrix4.rotationX(radians).storage);
  }

  /// [Matrix4.rotationY]
  Path rotationY(double radians) {
    return transform(Matrix4.rotationY(radians).storage);
  }

  /// [Matrix4.rotationZ]
  Path rotationZ(double radians) {
    return transform(Matrix4.rotationZ(radians).storage);
  }

  /// 沿着Y轴做镜像
  Path mirrorY(double from) {
    return Path.combine(
      PathOperation.union,
      this,
      rotationY(math.pi).shift(Offset(from * 2, 0)),
    );
  }
}
