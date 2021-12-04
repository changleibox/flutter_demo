import 'package:fling/fling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/page/fling_page.dart';
import 'package:flutter_demo/page/main_page.dart';
import 'package:flutter_demo/page/mask_page.dart';

void main() {
  runApp(DemoApp());
}

/// 路由表
final routes = <String, WidgetBuilder>{
  '/': (context) => const MainPage(),
  'fling': (context) => const FlingPage(),
  'mask': (context) => const MaskPage(),
};

/// demo
class DemoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        return FlingNavigator(
          duration: const Duration(
            seconds: 3,
          ),
          child: child!,
        );
      },
      routes: routes,
    );
  }
}
