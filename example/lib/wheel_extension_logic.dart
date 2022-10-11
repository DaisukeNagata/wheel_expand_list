import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';
import 'package:wheel_expand_list_example/main.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_example2.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';

extension GenerateRandomStrings on String {
  String generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len.toInt(), (index) => chars[r.nextInt(chars.length)])
        .join();
  }
}

extension Range on int {
  int randomIntWithRange(int min, int max) {
    int value = Random().nextInt(max - min);
    return value + min;
  }
}

extension Loop on WheelLogic {
  loop1(bool flg) {
    textList.clear();
    pageList.clear();
    for (var i = 1; i < 11; i++) {
      textList.add(''.generateRandomString(i * 0.randomIntWithRange(1, 100)));
      pageList.add(0.randomIntWithRange(1, 9));
    }
    valueSet = pageList.first;
    fontSize = 0.randomIntWithRange(10, 50).toDouble();
    margin = 0.randomIntWithRange(50, 200).toDouble();
    setHeightValue(flg);
  }

  loop2(bool flg) {
    textLists.clear();
    pageList.clear();
    for (var i = 0; i < 10; i++) {
      textLists.add([]);
      for (var nestI = 1; nestI < 11; nestI++) {
        textLists[i]
            .add(''.generateRandomString(nestI * 0.randomIntWithRange(1, 10)));
      }
      pageList.add(0.randomIntWithRange(1, 9));
      valueSet = pageList.first;
    }

    fontSize = 0.randomIntWithRange(10, 50).toDouble();
    margin = 0.randomIntWithRange(50, 200).toDouble();
    setHeightValue2(flg);
  }

  void setHeightValue(bool flg) {
    if (flg) {
      initSet(
        marginSet: fontSize,
        fontSizeSet: margin,
        again: true,
      );
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        initSet(
          marginSet: fontSize,
          fontSizeSet: margin,
          again: false,
        );
      });
    }
  }

  void setHeightValue2(bool flg) {
    if (flg) {
      overlapInit(marginSet: fontSize, fontSizeSet: margin, again: true);
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        overlapInit(marginSet: fontSize, fontSizeSet: margin, again: false);
      });
    }
  }

  void type() {
    if (swipeType == WheelSwipeType.left) {
      swipeType = WheelSwipeType.right;
    } else {
      swipeType = WheelSwipeType.left;
    }
  }
}

extension WheelPageStateEx on WheelPageState {
  /// Example
  void updateData(bool flg) {
    setState(() {
      wheelLogic.loop1(flg);
      wheelDataSet = WheelDataSet(
        logic: wheelLogic,
      );
      wheelWidget = WheelWidget(
        logic: wheelLogic,
      );
    });
  }

  void _updateSwipeType() {
    setState(() {
      wheelLogic.type();
      wheelLogic.initSet(
        marginSet: wheelLogic.fontSize,
        fontSizeSet: wheelLogic.margin,
        again: false,
      );
    });
  }

  Widget rightOfRightButton() {
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

  Widget rightOfLeftButton() {
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

  Widget leftOfRightButton() {
    return IconButton(
      icon: const Icon(Icons.cached_outlined),
      onPressed: () => {
        setState(() {
          wheelLogic.slideActionFlg = !wheelLogic.slideActionFlg;
          wheelDataSet = WheelDataSet(
            logic: wheelLogic,
          );
        }),
      },
    );
  }

  Widget leftOfLeftButton() {
    return IconButton(
      icon: const Icon(Icons.update),
      onPressed: () => {
        setState(() {
          updateData(false);
        }),
      },
    );
  }
}

extension WheelPageState2Ex on WheelPageState2 {
  void updateData(bool flg) {
    setState(() {
      wheelLogic.loop2(flg);
      wheelDataSet = WheelDataSet(
        logic: wheelLogic,
      );
      wheelWidget = WheelWidget(
        logic: wheelLogic,
      );
    });
  }

  void _updateSwipeType() {
    setState(() {
      wheelLogic.type();
      wheelLogic.setHeightValue2(false);
    });
  }

  Widget rightOfRightButton() {
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

  Widget rightOfLeftButton() {
    return IconButton(
      icon: const Icon(Icons.cached_outlined),
      onPressed: () => {
        setState(() {
          wheelLogic.slideActionFlg = !wheelLogic.slideActionFlg;
          wheelDataSet = WheelDataSet(
            logic: wheelLogic,
          );
        }),
      },
    );
  }

  Widget leftOfRightButton() {
    return IconButton(
      icon: const Icon(Icons.update),
      onPressed: () => {
        setState(() {
          updateData(false);
        }),
      },
    );
  }

  Widget leftOfLeftButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => {
        setState(
          () {
            Navigator.of(context).pop();
          },
        ),
      },
    );
  }
}
