import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/flings.dart';

const _flightShuttleSize = Size.square(40);
const _flightShuttleRadius = Radius.circular(20);
const _flightShuttleColor = Colors.indigo;
const _flightShuttleChild = FlutterLogo(
  size: 40,
  textColor: Colors.white,
);

/// 自定义的[FlightShuttle]动画
typedef FlightShuttleBuilder = Widget Function(
  BuildContext context,
  Rect bounds,
  double edgeValue,
  double transitionValue,
  Fling fling,
);

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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('测试'),
      ),
      child: FlingWidgetsApp(
        duration: const Duration(
          seconds: 3,
        ),
        child: Row(
          children: [
            Expanded(
              child: FlingBoundary(
                tag: 1,
                child: _FlingBlock(
                  tag: 1,
                  color: Colors.pink,
                  onPressed: (context) {
                    FlingBoundary.push(context, boundaryTag: 2, tag: 1);
                    Fling.push(context, boundaryTag: 2, tag: 2);
                  },
                ),
              ),
            ),
            Expanded(
              child: FlingBoundary(
                tag: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _FlingBlock(
                        tag: 1,
                        color: Colors.deepPurple,
                        width: 200,
                        height: 100,
                        onPressed: (context) {
                          FlingNavigator.push(context, toBoundaryTag: 1, tag: 1);
                          Fling.push(context, tag: 2);
                        },
                      ),
                    ),
                    Expanded(
                      child: _FlingBlock(
                        tag: 2,
                        color: Colors.teal,
                        width: 100,
                        height: 200,
                        onPressed: (context) {
                          Fling.push(context, boundaryTag: 1, tag: 1);
                          Fling.push(context, tag: 1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlingBlock extends StatelessWidget {
  const _FlingBlock({
    Key? key,
    required this.tag,
    required this.color,
    this.width,
    this.height,
    required this.onPressed,
  }) : super(key: key);

  final Object tag;

  final Color color;

  final double? width;

  final double? height;

  final ValueChanged<BuildContext>? onPressed;

  static Widget _buildFlightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    BuildContext fromFlingContext,
    BuildContext toFlingContext,
    Rect fromFlingLocation,
    Rect toFlingLocation,
  ) {
    return FlightShuttleTransition(
      fromFlingContext: fromFlingContext,
      toFlingContext: toFlingContext,
      fromFlingLocation: fromFlingLocation,
      toFlingLocation: toFlingLocation,
      factor: animation,
      builder: (context, bounds, edgeValue, transitionValue, fling) {
        final child = (fling.child as _ContextBuilder).child as _ColorBlock;
        return _ColorBlock.fromSize(
          size: Size.lerp(_flightShuttleSize, bounds.size, edgeValue),
          color: Color.lerp(_flightShuttleColor, child.color, edgeValue),
          radius: Radius.lerp(_flightShuttleRadius, child.radius, edgeValue),
          child: edgeValue == 0 ? _flightShuttleChild : child.child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Fling(
        tag: tag,
        placeholderBuilder: (context, flingSize, child) {
          return child;
        },
        flightShuttleBuilder: _buildFlightShuttle,
        child: _ContextBuilder(
          onPressed: onPressed,
          child: _ColorBlock(
            width: width ?? 100,
            height: height ?? 100,
            color: color,
          ),
        ),
      ),
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
    this.child,
  }) : super(key: key);

  _ColorBlock.fromSize({
    Key? key,
    Size? size,
    this.color,
    this.radius = const Radius.circular(10),
    this.child,
  })  : width = size?.width,
        height = size?.height,
        super(key: key);

  final double? width;
  final double? height;
  final Color? color;
  final Radius? radius;
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
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// 构造[FlightShuttle]动画
class FlightShuttleTransition extends AnimatedWidget {
  /// 构造[FlightShuttle]动画
  FlightShuttleTransition({
    Key? key,
    required BuildContext fromFlingContext,
    required BuildContext toFlingContext,
    required this.fromFlingLocation,
    required this.toFlingLocation,
    required this.builder,
    required Animation<double> factor,
  })  : fromFling = fromFlingContext.widget as Fling,
        toFling = toFlingContext.widget as Fling,
        startAnimation = CurveTween(
          curve: const Interval(0.0, 0.2, curve: Curves.easeInOut),
        ).animate(factor),
        transitionAnimation = CurveTween(
          curve: const Interval(0.2, 0.7, curve: Curves.linear),
        ).animate(factor),
        endAnimation = CurveTween(
          curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
        ).animate(factor),
        super(key: key, listenable: factor);

  /// fromChild
  final Fling fromFling;

  /// toChild
  final Fling toFling;

  /// fromLocation
  final Rect fromFlingLocation;

  /// toLocation
  final Rect toFlingLocation;

  /// 开始
  final Animation<double> startAnimation;

  /// 转场
  final Animation<double> transitionAnimation;

  /// 结束
  final Animation<double> endAnimation;

  /// 构建child
  final FlightShuttleBuilder builder;

  /// The animation that controls the (clipped) [FlightShuttle] of the child.
  Animation<double> get factor => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final startValue = startAnimation.value;
    final endValue = endAnimation.value;
    final edgeValue = endValue > 0 ? endValue : 1 - startValue;
    final bounds = endValue > 0 ? toFlingLocation : fromFlingLocation;
    final fling = endValue > 0 ? toFling : fromFling;

    final transitionValue = transitionAnimation.value;
    final distanceOffset = fromFlingLocation.center - toFlingLocation.center;

    return Center(
      child: Transform.translate(
        offset: distanceOffset * (factor.value - transitionValue),
        child: Transform.rotate(
          angle: transitionAnimation.value * math.pi * 2.0,
          child: builder(context, bounds, edgeValue, transitionValue, fling),
        ),
      ),
    );
  }
}
