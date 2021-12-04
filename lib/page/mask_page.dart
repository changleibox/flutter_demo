import 'package:cavity_mask/cavity_mask.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2021/12/4.
///
/// 自定义遮罩
class MaskPage extends StatefulWidget {
  /// 自定义遮罩
  const MaskPage({Key? key}) : super(key: key);

  @override
  _MaskPageState createState() => _MaskPageState();
}

class _MaskPageState extends State<MaskPage> {
  Widget _buildChild(int index) {
    Widget child = Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      child: const Text('测试'),
    );
    if (index % 4 == 0) {
      child = CavityRRect(
        borderRadius: BorderRadius.circular(10),
        child: child,
      );
    } else if (index % 4 == 1) {
      child = CavityPath(
        clipper: const ShapeBorderClipper(
          shape: CircleBorder(
            side: BorderSide(
              color: CupertinoColors.black,
              width: 2,
            ),
          ),
        ),
        child: child,
      );
    } else if (index % 4 == 2) {
      child = CavityOval(
        child: child,
      );
    } else {
      child = CavityRect(
        child: child,
      );
    }
    return CupertinoButton.filled(
      onPressed: () {
        print('pressed');
      },
      minSize: 40,
      padding: EdgeInsets.zero,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Mask'),
      ),
      child: Builder(
        builder: (context) {
          return CavityMask(
            color: CupertinoColors.systemRed.withOpacity(0.7),
            position: MaskPosition.foreground,
            barrier: true,
            child: SingleChildScrollView(
              padding: MediaQuery.of(context).padding,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(100 - 1, (index) {
                    if (index.isEven) {
                      return _buildChild(index ~/ 2);
                    } else {
                      return const SizedBox(
                        height: 20,
                      );
                    }
                  }),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
