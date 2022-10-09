import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_expand_list.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';
import 'package:wheel_expand_list_example/submain.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      wheelLogic.textList.clear();
      wheelLogic.pageList.clear();
      for (var i = 1; i < 11; i++) {
        wheelLogic.textList
            .add(_generateRandomString(i * _randomIntWithRange(1, 100)));
        wheelLogic.pageList.add(_randomIntWithRange(1, 9));
        wheelLogic.valueSet = wheelLogic.pageList.first;
      }
      wheelLogic.fontSize = _randomIntWithRange(10, 50).toDouble();
      wheelLogic.margin = _randomIntWithRange(50, 200).toDouble();
      if (flg) {
        wheelLogic.initSet(
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
          wheelLogic.addHeightValue(
              wheelLogic.globalKeys, wheelDataSet.margin.truncate());
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
      icon: const Icon(Icons.arrow_forward),
      onPressed: () => {
        setState(
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubMain(),
              ),
            );
          },
        ),
      },
    );
  }

  Widget _rightOfLeftButton() {
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
        title:
            Text('index${wheelLogic.indexCount}: page${wheelLogic.pageCount}'),
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
              icon: const Icon(Icons.update),
              onPressed: () => {
                setState(() {
                  _updateData(false);
                }),
              },
            ),
            IconButton(
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
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          wheelWidget.loopWidget(
            context,
            wheelLogic.globalKeys,
            wheelLogic.textList,
            wheelLogic.margin,
            wheelLogic.fontSize,
          ),
          StreamBuilder(
            stream: wheelLogic.streamController.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<double>> snapshot,
            ) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      WheelExpandList(
                        callBack: (index) {
                          Future(() {
                            setState(() {
                              wheelLogic.indexCount = index;
                            });
                          });
                        },
                        pageStart: (index) {
                          slideActionFlg
                              ? wheelDataSet.startController(
                                  index,
                                  300,
                                  wheelLogic.controller,
                                  Curves.slowMiddle,
                                )
                              : wheelDataSet.startController(
                                  index,
                                  300,
                                  wheelLogic.controller,
                                  Curves.easeOut,
                                );
                        },
                        pageEnd: (value) {
                          setState(() {
                            Future(() {
                              wheelLogic.indexCount = 0;
                              wheelLogic.pageCount = value;
                            });
                          });
                        },
                        wheelDataModel: wheelDataSet,
                        wheelPrimitiveWidget: wheelWidget,
                        wheelLogic: wheelLogic,
                      ),
                    ],
                  ),
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
