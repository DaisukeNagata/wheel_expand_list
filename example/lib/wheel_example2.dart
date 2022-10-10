import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_expand_list_horizontal.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_extension_logic.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';

class WheelExample2 extends StatelessWidget {
  const WheelExample2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const WheelPage2();
  }
}

class WheelPage2 extends StatefulWidget {
  const WheelPage2({
    super.key,
  });

  @override
  State<WheelPage2> createState() => _WheelPageState2();
}

class _WheelPageState2 extends State<WheelPage2> {
  var wheelLogic = WheelLogic();
  late WheelDataSet wheelDataSet;
  late WheelWidget wheelWidget;
  var _slideActionFlg = false;

  /// Example
  void _updateData(bool flg) {
    setState(() {
      wheelLogic.loop2();
      wheelLogic.setHeightValue2(flg);
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
      wheelLogic.setHeightValue2(false);
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
          _slideActionFlg = !_slideActionFlg;
          wheelDataSet = WheelDataSet(
            logic: wheelLogic,
            slideActionFlg: _slideActionFlg,
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
            'index${wheelLogic.indexCount}: page${wheelLogic.pageCounts[wheelLogic.pageCount] + 1}'),
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
                return WheelExpandListHorizontal(
                  tapCall: (index) {
                    Future(() {
                      setState(() {
                        wheelLogic.indexCount = index;
                      });
                    });
                  },
                  pageStart: (index) {
                    /// 配列で設定
                    _slideActionFlg
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
