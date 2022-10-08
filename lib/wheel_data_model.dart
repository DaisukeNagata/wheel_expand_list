import 'package:flutter/material.dart' show Cubic, FixedExtentScrollController;
import 'package:wheel_expand_list/wheel_swipe_type.dart' show WheelSwipeType;

class WheelPrimitiveModel {
  int generate = 0;
  int itemCount = 0;
  double margin = 0;
  double padding = 0;
  double diameterRatio = 0;
  WheelSwipeType swipeType = WheelSwipeType.left;
  void startController(
    int index,
    int value,
    FixedExtentScrollController controlelr,
    Cubic cubic,
  ) async {
    controlelr.animateToItem(
      index,
      duration: Duration(milliseconds: value),
      curve: cubic,
    );
  }
}
