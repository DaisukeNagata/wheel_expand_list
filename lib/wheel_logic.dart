import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_global_key_ex.dart';

class WheelLogic {
  List<double> heightList = [];
  List<double> originYList = [];
  var streamController = StreamController<List<double>>();

  void addHeightValue(List<GlobalKey> keys, int margin) {
    Future(() async {
      heightList.clear();
      originYList.clear();
      for (final value in keys) {
        heightList.add(_sizeMethod(value, margin));
        _originMethod(value, margin);
      }
      if (heightList.last > 0.0) {
        streamController.sink.add(heightList);
      }
    });
  }

  _originMethod(GlobalKey key, int margin) {
    var value = (key.globalPaintBounds?.height ?? 0);
    if (originYList.isEmpty) {
      originYList.add(value + margin);
    } else {
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
