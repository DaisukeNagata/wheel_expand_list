import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_global_key_ex.dart';

class WheelLogic {
  int pageCount = 1;
  int indexCount = 0;
  double margin = 0.0;
  double fontSize = 0.0;
  List<String> textList = [];
  List<double> heightList = [];
  List<double> originYList = [];
  List<double> originYListTop = [];
  var streamController = StreamController<List<double>>();

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
    var valueTop = (key.globalPaintBounds?.top ?? 0);
    if (originYList.isEmpty) {
      originYList.add(value + margin);
      originYListTop.add(margin.toDouble());
    } else {
      originYList.add(originYList.last + value + margin);
      originYListTop.add(originYListTop.last + value + margin);
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
