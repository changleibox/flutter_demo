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
    return const CupertinoApp(
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}
