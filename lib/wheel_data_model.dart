import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class WheelDataModel {
  double diameterRatio = 0;
  int generate = 0;
  int itemCount = 0;
  void startController(
    int index,
    FixedExtentScrollController controlelr,
    int value,
    Cubic cubic,
  ) async {
    controlelr.animateToItem(
      index,
      duration: Duration(milliseconds: value),
      curve: cubic,
    );
  }
}
