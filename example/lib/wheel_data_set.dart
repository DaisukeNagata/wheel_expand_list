import 'package:flutter/src/animation/curves.dart';
import 'package:flutter/src/widgets/list_wheel_scroll_view.dart';
import 'package:wheel_expand_list/wheel_data_model.dart';
import 'package:wheel_expand_list/wheel_logic.dart';

class WheelDataSet implements WheelDataModel {
  WheelDataSet({
    required this.logic,
  });
  final WheelLogic logic;
  @override
  double get diameterRatio {
    return logic.slideActionFlg ? 2 : 200;
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
  void startController(int index, FixedExtentScrollController controlelr,
      int value, Cubic cubic) {
    controlelr.animateToItem(index,
        duration: Duration(milliseconds: value), curve: cubic);
  }
}
