import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_expand_list.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_example2.dart';
import 'package:wheel_expand_list_example/wheel_extension_logic.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';

void main() {
  runApp(const WheelExample());
}

class WheelExample extends StatelessWidget {
  const WheelExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WheelPage(),
    );
  }
}

class WheelPage extends StatefulWidget {
  const WheelPage({
    super.key,
  });

  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> {
  var wheelLogic = WheelLogic();
  late WheelDataSet wheelDataSet;
  late WheelWidget wheelWidget;
  var _slideActionFlg = false;

  /// Example
  void _updateData(bool flg) {
    setState(() {
      wheelLogic.loop1();
      wheelLogic.setHeightValue(flg);
      wheelDataSet = WheelDataSet(
        logic: wheelLogic,
        slideActionFlg: _slideActionFlg,
      );
      wheelWidget = WheelWidget(
        marginSet: wheelLogic.margin,
        fontSizeSet: wheelLogic.fontSize,
      );
    });
  }

  /// Example
  void _updateSwipeType() {
    setState(() {
      wheelLogic.type();
      wheelDataSet = WheelDataSet(
        logic: wheelLogic,
        slideActionFlg: _slideActionFlg,
      );
      wheelWidget = WheelWidget(
        marginSet: wheelLogic.margin,
        fontSizeSet: wheelLogic.fontSize,
      );
      wheelLogic.initSet(
        marginSet: wheelLogic.fontSize,
        fontSizeSet: wheelLogic.margin,
        again: false,
      );
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
                builder: (context) => const WheelExample2(),
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
                  _slideActionFlg = !_slideActionFlg;
                  wheelDataSet = WheelDataSet(
                    logic: wheelLogic,
                    slideActionFlg: _slideActionFlg,
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
                          _slideActionFlg
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
