import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';
import 'package:wheel_expand_list/wheel_expand_list2.dart';

class SubMain extends StatelessWidget {
  const SubMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyHomePage2();
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({
    super.key,
  });

  @override
  State<MyHomePage2> createState() => _MyHomePageState2();
}

class _MyHomePageState2 extends State<MyHomePage2> {
  var wheelLogic = WheelLogic();
  late WheelDataSet wheelDataSet;
  late WheelWidget wheelWidget;
  var slideActionFlg = false;

  int _randomIntWithRange(int min, int max) {
    int value = Random().nextInt(max - min);
    return value + min;
  }

  String _generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len.toInt(), (index) => chars[r.nextInt(chars.length)])
        .join();
  }

  /// Example
  void _updateData(bool flg) {
    setState(() {
      wheelLogic.textListLists.clear();

      for (var i = 0; i < 10; i++) {
        wheelLogic.textListLists.add([]);
        for (var nestI = 1; nestI < 11; nestI++) {
          wheelLogic.textListLists[i]
              .add(_generateRandomString(nestI * _randomIntWithRange(1, 10)));
        }
        wheelLogic.pageList.add(_randomIntWithRange(1, 9));
        wheelLogic.valueSet = wheelLogic.pageList.first;
      }

      wheelLogic.fontSize = _randomIntWithRange(10, 20).toDouble();
      wheelLogic.margin = _randomIntWithRange(50, 60).toDouble();
      if (flg) {
        wheelLogic.initSet2(
          marginSet: wheelLogic.fontSize,
          fontSizeSet: wheelLogic.margin,
        );
      }

      wheelDataSet = WheelDataSet(
        logic: wheelLogic,
        slideActionFlg: slideActionFlg,
      );
      wheelWidget = WheelWidget(
        marginSet: wheelLogic.margin,
        fontSizeSet: wheelLogic.fontSize,
      );
      if (!flg) {
        Future.delayed(const Duration(milliseconds: 100), () {
          wheelLogic.addHeightValues(
              wheelLogic.globalKeysLists, wheelDataSet.margin.truncate());
        });
      }
    });
  }

  /// Example
  void _updateSwipeType() {
    setState(() {
      if (wheelDataSet.swipeType == WheelSwipeType.left) {
        wheelLogic.swipeType = WheelSwipeType.right;
      } else {
        wheelLogic.swipeType = WheelSwipeType.left;
      }
      wheelDataSet = WheelDataSet(
        logic: wheelLogic,
        slideActionFlg: slideActionFlg,
      );
      wheelWidget = WheelWidget(
        marginSet: wheelLogic.margin,
        fontSizeSet: wheelLogic.fontSize,
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        wheelLogic.addHeightValue(
            wheelLogic.globalKeys, wheelDataSet.margin.truncate());
      });
    });
  }

  Widget _rightOfRightButton() {
    return IconButton(
      icon: wheelDataSet.swipeType == WheelSwipeType.right
          ? const Icon(Icons.keyboard_arrow_left)
          : const Icon(Icons.keyboard_arrow_right),
      onPressed: () => {
        setState(() {
          _updateSwipeType();
        }),
      },
    );
  }

  Widget _rightOfLeftButton() {
    return IconButton(
      icon: const Icon(Icons.cached_outlined),
      onPressed: () => {
        setState(() {
          slideActionFlg = !slideActionFlg;
          wheelDataSet = WheelDataSet(
            logic: wheelLogic,
            slideActionFlg: slideActionFlg,
          );
        }),
      },
    );
  }

  @override
  void initState() {
    _updateData(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        title: Text(
            'index${wheelLogic.indexCount}: page${wheelLogic.pageCounts[wheelLogic.pageCount]}'),
        actions: [
          Row(
            children: [
              _rightOfLeftButton(),
              _rightOfRightButton(),
            ],
          ),
        ],
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {
                setState(
                  () {
                    Navigator.of(context).pop();
                  },
                ),
              },
            ),
            IconButton(
              icon: const Icon(Icons.update),
              onPressed: () => {
                setState(() {
                  _updateData(false);
                }),
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          for (var i = 0; i < wheelLogic.textListLists.length; i++) ...[
            wheelWidget.loopWidget(
              context,
              wheelLogic.globalKeysLists[i],
              wheelLogic.textListLists[i],
              wheelLogic.margin,
              wheelLogic.fontSize,
            ),
          ],
          StreamBuilder(
            stream: wheelLogic.streamController.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<double>> snapshot,
            ) {
              if (snapshot.hasData) {
                return WheelExpandList2(
                  tapCall: (index) {
                    Future(() {
                      setState(() {
                        wheelLogic.indexCount = index;
                      });
                    });
                  },
                  pageStart: (index) {
                    /// 配列で設定
                    slideActionFlg
                        ? wheelDataSet.startController(
                            index,
                            300,
                            wheelLogic.controllers[wheelLogic.indexCount],
                            Curves.slowMiddle,
                          )
                        : wheelDataSet.startController(
                            index,
                            300,
                            wheelLogic.controllers[wheelLogic.indexCount],
                            Curves.easeOut,
                          );
                  },
                  pageEnd: (value) {
                    Future(() {
                      setState(() {
                        wheelLogic.pageCounts[wheelLogic.pageCount] = value;
                      });
                    });
                  },
                  wheelDataModel: wheelDataSet,
                  wheelPrimitiveWidget: wheelWidget,
                  wheelLogic: wheelLogic,
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
