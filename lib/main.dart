import 'package:fling/fling.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/page/main_page.dart';

void main() {
  runApp(DemoApp());
}

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
      home: const MainPage(),
    );
  }
}
