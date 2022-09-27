import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_global_key_ex.dart';

class WheelLogic {
  int pageCount = 0;
  int indexCount = 0;
  int valueSet = 1;
  int valueSetReady = 1;
  double margin = 0.0;
  double fontSize = 0.0;
  List<int> pageList = [];
  List<String> textList = [];
  List<double> heightList = [];
  List<double> originYList = [];
  List<double> originYListTop = [];
  List<GlobalKey> globalKeys = [];
  var streamController = StreamController<List<double>>();

  void initSet({
    required double marginSet,
    required double fontSizeSet,
  }) {
    margin = marginSet;
    fontSize = fontSizeSet;
    for (final _ in textList) {
      globalKeys.add(GlobalKey());
    }
    addHeightValue(globalKeys, margin.toInt());
  }

  void addHeightValue(List<GlobalKey> keys, int margin) {
    Future(() async {
      heightList.clear();
      originYList.clear();
      originYListTop.clear();
      for (final value in keys) {
        heightList.add(_sizeMethod(value, margin));
        _originMethod(value, margin);
      }
      if (heightList.last > 0.0) {
        streamController.sink.add(heightList);
      }
    });
  }

  void dispose() {
    streamController.close();
  }

  _originMethod(GlobalKey key, int margin) {
    var value = (key.globalPaintBounds?.height ?? 0);
    if (originYList.isEmpty) {
      originYList.add(value + margin);
      originYListTop.add(margin.toDouble());
    } else {
      originYListTop.add(originYList.last + margin);
      originYList.add(originYList.last + value + margin);
    }
  }

  double _sizeMethod(GlobalKey key, int margin) {
    if ((key.currentContext?.size?.height ?? 0.0) > 0.0) {
      return (key.currentContext?.size?.height ?? 0.0) + margin;
    } else {
      return 0.0;
    }
  }
}
