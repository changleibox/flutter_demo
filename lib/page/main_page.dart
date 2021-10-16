import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/flings.dart';

const _tag = '1';
const _flightShuttleSize = Size.square(40);
const _flightShuttleRadius = Radius.circular(20);
const _flightShuttleColor = Colors.brown;
const _flightShuttleChild = FlutterLogo(
  size: 40,
  textColor: Colors.white,
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
                builder: (context) {
                  return _FlingBlock(
                    color: Colors.pink,
                    onPressed: (context) {
                      FlingNavigator.push(context, 2, _tag);
                      FlingNavigator.push(context, 3, _tag);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: FlingBoundary(
                      tag: 2,
                      builder: (context) {
                        return _FlingBlock(
                          color: Colors.deepPurple,
                          width: 200,
                          height: 100,
                          onPressed: (context) {
                            FlingNavigator.push(context, 1, _tag);
                            FlingNavigator.push(context, 3, _tag);
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: FlingBoundary(
                      tag: 3,
                      builder: (context) {
                        return _FlingBlock(
                          color: Colors.teal,
                          width: 100,
                          height: 200,
                          onPressed: (context) {
                            FlingNavigator.push(context, 1, _tag);
                            FlingNavigator.push(context, 2, _tag);
                          },
                        );
                      },
                    ),
                  ),
                ],
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
    required this.color,
    this.width,
    this.height,
    required this.onPressed,
  }) : super(key: key);

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
    final startScaleAnimation = CurveTween(
      curve: const Interval(0.0, 0.2, curve: Curves.easeInOut),
    ).animate(animation);
    final turnsAnimation = CurveTween(
      curve: const Interval(0.2, 0.7, curve: Curves.linear),
    ).animate(animation);
    final endScaleAnimation = CurveTween(
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    ).animate(animation);

    final fromChild = (fromFlingContext.widget as Fling).child as _ColorBlock;
    final toChild = (toFlingContext.widget as Fling).child as _ColorBlock;

    return Center(
      child: RotationTransition(
        turns: turnsAnimation,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final startValue = startScaleAnimation.value;
            final endValue = endScaleAnimation.value;
            final value = endValue > 0 ? endValue : 1 - startValue;
            final bounds = endValue > 0 ? toFlingLocation : fromFlingLocation;
            final child = endValue > 0 ? toChild : fromChild;

            return _ColorBlock.fromSize(
              size: Size.lerp(_flightShuttleSize, bounds.size, value),
              color: Color.lerp(_flightShuttleColor, child.color, value),
              radius: Radius.lerp(_flightShuttleRadius, child.radius, value),
              child: value == 0 ? _flightShuttleChild : child.child,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => onPressed?.call(context),
      child: Fling(
        tag: _tag,
        placeholderBuilder: (context, flingSize, child) {
          return child;
        },
        flightShuttleBuilder: _buildFlightShuttle,
        child: _ColorBlock(
          width: width ?? 100,
          height: height ?? 100,
          color: color,
        ),
      ),
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
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(radius ?? Radius.zero),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
