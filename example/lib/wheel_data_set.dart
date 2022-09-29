import 'package:flutter/cupertino.dart';
import 'package:wheel_expand_list/wheel_data_model.dart';
import 'package:wheel_expand_list/wheel_logic.dart';

class WheelDataSet implements WheelDataModel {
  WheelDataSet({
    required this.logic,
    required this.slideActionFlg,
  });
  final WheelLogic logic;
  final bool slideActionFlg;
  @override
  double get diameterRatio {
    return slideActionFlg ? 2 : 200;
  }

  @override
  set diameterRatio(double diameterRatio) {
    diameterRatio = diameterRatio;
  }

  @override
  int get generate {
    return logic.pageList.length - 1;
  }

  @override
  set generate(int generate) {
    generate = generate;
  }

  @override
  int get itemCount {
    return logic.valueSet;
  }

  @override
  set itemCount(int itemCount) {
    itemCount = itemCount;
  }

  @override
  double get margin {
    return logic.margin;
  }

  @override
  set margin(double margin) {
    margin = margin;
  }

  @override
  double get padding {
    return logic.margin / 2;
  }

  @override
  set padding(double padding) {
    padding = padding;
  }

  @override
  void startController(
    int index,
    int value,
    FixedExtentScrollController controller,
    Cubic cubic,
  ) {
    controller.animateToItem(index,
        duration: Duration(milliseconds: value), curve: cubic);
  }
}
