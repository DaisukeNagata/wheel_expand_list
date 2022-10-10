import 'dart:ffi';
import 'dart:math';

import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';

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

extension loopLogic on WheelLogic {
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
    textListLists.clear();
    pageList.clear();
    for (var i = 0; i < 10; i++) {
      textListLists.add([]);
      for (var nestI = 1; nestI < 11; nestI++) {
        textListLists[i]
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
