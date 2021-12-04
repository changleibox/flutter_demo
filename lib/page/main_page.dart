import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';

/// Created by box on 2021/12/4.
///
/// 主页面
class MainPage extends StatelessWidget {
  /// 构建主页面
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _routes = routes.keys.where((element) => element != '/').toList();
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Main'),
      ),
      child: Builder(
        builder: (context) {
          return ListView.separated(
            padding: MediaQuery.of(context).padding + const EdgeInsets.all(10),
            itemCount: _routes.length,
            itemBuilder: (context, index) {
              final routeName = _routes[index];
              return CupertinoButton.filled(
                child: Text(routeName),
                onPressed: () {
                  Navigator.pushNamed(context, routeName);
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 10,
              );
            },
          );
        },
      ),
    );
  }
}
