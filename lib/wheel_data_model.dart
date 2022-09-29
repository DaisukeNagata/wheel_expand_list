import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class WheelDataModel {
  int generate = 0;
  int itemCount = 0;
  double margin = 0;
  double padding = 0;
  double diameterRatio = 0;
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
