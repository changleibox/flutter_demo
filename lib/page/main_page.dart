import 'dart:math' as math;

import 'package:fling/fling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _flightShuttleSize = Size.square(40);
const _flightShuttleRadius = Radius.circular(20);
const _flightShuttleColor = Colors.red;
const _flightShuttleBorder = Border.fromBorderSide(
  BorderSide(
    color: Colors.black,
    width: 1,
  ),
);
const _flightShuttleChild = Icon(
  Icons.flight,
  size: 30,
  color: Colors.white,
);
const _noneBorder = Border.fromBorderSide(BorderSide.none);
const _beginInterval = Interval(0.0, 0.2, curve: Curves.easeInOut);
const _middleInterval = Interval(0.2, 0.7, curve: Curves.linear);
const _endInterval = Interval(0.7, 1.0, curve: Curves.easeOut);

/// Created by changlei on 2020/7/6.
///
/// 测试
class MainPage extends StatefulWidget {
  /// 创建
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        middle: const Text('Fling示例'),
        trailing: _FlingBlock(
          tag: 4,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              showCupertinoDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return _FlingColorBlock(
                    tag: 3,
                    color: Colors.orange,
                    width: 100,
                    height: 200,
                    onPressed: (context) {
                      Navigator.pop(context);
                      Fling.push(context, boundaryTag: 1, tag: 1);
                      Fling.push(context, boundaryTag: 2, tag: 1);
                      Fling.push(context, boundaryTag: 2, tag: 2);
                      Fling.push(context, boundaryTag: 2, tag: 3);
                      Fling.push(context, tag: 1);
                      Fling.push(context, tag: 2);
                      Fling.push(context, tag: 4);
                    },
                  );
                },
              );
            },
            child: const Text(
              '跨路由',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: FlingBoundary(
                    tag: 1,
                    child: _FlingColorBlock(
                      tag: 1,
                      color: Colors.pink,
                      onPressed: (context) {
                        FlingNavigator.push(context, fromBoundaryTag: 1, toBoundaryTag: 2, fromTag: 1, toTag: 1);
                        FlingBoundary.push(context, boundaryTag: 2, fromTag: 1, toTag: 2);
                        Fling.push(context, boundaryTag: 2, tag: 3);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: _FlingColorBlock(
                    tag: 1,
                    color: Colors.blue,
                    onPressed: (context) {
                      FlingNavigator.push(
                        context,
                        fromBoundaryTag: FlingBoundary.rootBoundaryTag,
                        toBoundaryTag: 2,
                        fromTag: 1,
                        toTag: 1,
                      );
                      FlingBoundary.push(context, boundaryTag: 2, fromTag: 1, toTag: 2);
                      Fling.push(context, boundaryTag: 2, tag: 3);
                    },
                  ),
                ),
                Expanded(
                  child: _FlingColorBlock(
                    tag: 2,
                    color: Colors.indigo,
                    onPressed: (context) {
                      FlingNavigator.push(
                        context,
                        fromBoundaryTag: FlingBoundary.rootBoundaryTag,
                        toBoundaryTag: 2,
                        fromTag: 2,
                        toTag: 1,
                      );
                      FlingBoundary.push(context, boundaryTag: 2, fromTag: 2, toTag: 2);
                      Fling.push(context, boundaryTag: 2, tag: 3);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlingBoundary(
              tag: 2,
              child: Column(
                children: [
                  Expanded(
                    child: _FlingColorBlock(
                      tag: 1,
                      color: Colors.deepPurple,
                      width: 200,
                      height: 100,
                      onPressed: (context) {
                        Fling.push(context, boundaryTag: 1, tag: 1);
                        Fling.push(context, boundaryTag: FlingBoundary.rootBoundaryTag, tag: 1);
                        Fling.push(context, boundaryTag: FlingBoundary.rootBoundaryTag, tag: 2);
                        Fling.push(context, tag: 2);
                      },
                    ),
                  ),
                  Expanded(
                    child: _FlingColorBlock(
                      tag: 2,
                      color: Colors.teal,
                      width: 200,
                      height: 200,
                      onPressed: (context) {
                        Fling.push(context, boundaryTag: 1, tag: 1);
                        Fling.push(context, boundaryTag: FlingBoundary.rootBoundaryTag, tag: 1);
                        Fling.push(context, boundaryTag: FlingBoundary.rootBoundaryTag, tag: 2);
                        Fling.push(context, tag: 1);
                        Fling.push(context, tag: 3);
                      },
                    ),
                  ),
                  Expanded(
                    child: _FlingColorBlock(
                      tag: 3,
                      color: Colors.orange,
                      width: 100,
                      height: 200,
                      onPressed: (context) {
                        Fling.push(context, boundaryTag: 1, tag: 1);
                        Fling.push(context, boundaryTag: FlingBoundary.rootBoundaryTag, tag: 1);
                        Fling.push(context, boundaryTag: FlingBoundary.rootBoundaryTag, tag: 2);
                        Fling.push(context, tag: 2);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlingColorBlock extends StatelessWidget {
  const _FlingColorBlock({
    Key? key,
    required this.tag,
    required this.color,
    this.width,
    this.height,
    this.child,
    required this.onPressed,
  }) : super(key: key);

  final Object tag;

  final Color color;

  final double? width;

  final double? height;

  final Widget? child;

  final ValueChanged<BuildContext>? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _FlingBlock(
        tag: tag,
        child: _ContextBuilder(
          onPressed: onPressed,
          child: _ColorBlock(
            width: width ?? 100,
            height: height ?? 100,
            color: color,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _FlingBlock extends StatelessWidget {
  const _FlingBlock({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

  final Object tag;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BesselFling(
      tag: tag,
      beginCurve: _beginInterval,
      middleCurve: _middleInterval,
      endCurve: _endInterval,
      flightSize: _flightShuttleSize,
      flightShuttleBuilder: (
        context,
        value,
        edgeValue,
        middleValue,
        fromFling,
        toFling,
        fromFlingLocation,
        toFlingLocation,
      ) {
        final offset = toFlingLocation.center - fromFlingLocation.center;
        final fling = middleValue == 1 ? toFling : fromFling;
        final turnValue = offset.dx >= 0 ? middleValue : 1 - middleValue;
        Widget? child = fling.child;
        Color? color;
        Radius? radius;
        Border? border;
        if (child is _ContextBuilder) {
          final colorBlock = child.child as _ColorBlock;
          color = Color.lerp(_flightShuttleColor, colorBlock.color, edgeValue);
          radius = Radius.lerp(_flightShuttleRadius, colorBlock.radius, edgeValue);
          border = Border.lerp(_flightShuttleBorder, colorBlock.border, edgeValue);
          child = colorBlock.child;
        } else {
          color = Color.lerp(_flightShuttleColor, Colors.white.withOpacity(0), edgeValue);
          radius = Radius.lerp(_flightShuttleRadius, Radius.zero, edgeValue);
          border = Border.lerp(_flightShuttleBorder, _noneBorder, edgeValue);
        }
        final bounds = middleValue == 1 ? toFlingLocation : fromFlingLocation;
        return Stack(
          fit: StackFit.expand,
          children: [
            _ColorBlock(
              color: color,
              radius: radius,
              border: border,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox.fromSize(
                  size: edgeValue == 0 ? _flightShuttleSize : bounds.size,
                  child: child,
                ),
              ),
            ),
            Opacity(
              opacity: 1 - edgeValue,
              child: Transform.rotate(
                angle: turnValue * math.pi * 2.0,
                child: _flightShuttleChild,
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}

class _ContextBuilder extends StatelessWidget {
  const _ContextBuilder({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final ValueChanged<BuildContext>? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}

class _ColorBlock extends StatelessWidget {
  const _ColorBlock({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.radius = const Radius.circular(10),
    this.border = const Border.fromBorderSide(
      BorderSide(
        color: Colors.black,
        width: 1,
      ),
    ),
    this.child,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;
  final Radius? radius;
  final Border? border;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(radius ?? Radius.zero);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color,
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
