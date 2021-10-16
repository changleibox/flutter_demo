import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/flings.dart';

const _tag = '1';
const _flightShuttleSize = Size.square(40);

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
        child: Row(
          children: [
            Expanded(
              child: FlingBoundary(
                tag: 1,
                builder: (context) {
                  return _FlingBlock(
                    color: Colors.red,
                    onPressed: (value) {
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
                          color: Colors.blue,
                          width: 200,
                          height: 100,
                          onPressed: (value) {
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
                          color: Colors.orange,
                          width: 100,
                          height: 200,
                          onPressed: (value) {
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

    return Center(
      child: RotationTransition(
        turns: turnsAnimation,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final startValue = startScaleAnimation.value;
            final endValue = endScaleAnimation.value;
            final value = endValue > 0 ? endValue : 1 - startValue;
            final location = endValue > 0 ? toFlingLocation : fromFlingLocation;

            var child = (fromFlingContext.widget as Fling).child;
            if (endValue > 0) {
              child = (toFlingContext.widget as Fling).child;
            } else if (value == 0) {
              child = _ColorBlock(
                width: _flightShuttleSize.width,
                height: _flightShuttleSize.height,
                color: Colors.green,
              );
            }
            return SizedBox.fromSize(
              size: Size.lerp(_flightShuttleSize, location.size, value),
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 80,
                ),
                child: child,
              ),
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
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
