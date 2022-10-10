import 'dart:async' show Future, StreamController;

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_global_key_ex.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';

class WheelLogic {
  int valueSet = 1;
  int valueSetReady = 1;
  int pageCount = 1;
  int indexCount = 0;
  double margin = 0.0;
  double fontSize = 0.0;
  List<int> pageList = [];
  List<int> pageCounts = [];
  List<String> textList = [];
  List<double> heightList = [];
  List<double> originYList = [];
  List<GlobalKey> globalKeys = [];
  List<double> originYListTop = [];
  List<List<double>> heightLists = [];
  List<List<String>> textListLists = [];
  List<List<GlobalKey>> globalKeysLists = [];
  List<FixedExtentScrollController> controllers = [];
  WheelSwipeType swipeType = WheelSwipeType.right;
  var controller = FixedExtentScrollController(initialItem: 0);
  var streamController = StreamController<List<double>>();

  void dispose() {
    streamController.close();
  }

  void initSet({
    required double marginSet,
    required double fontSizeSet,
    required bool again,
  }) {
    if (again) {
      margin = marginSet;
      fontSize = fontSizeSet;
      globalKeys.clear();
      pageCounts.clear();
      for (final _ in textList) {
        globalKeys.add(GlobalKey());
        pageCounts.add(0);
      }
    }
    _addHeightValue(globalKeys, margin.toInt());
  }

  void overlapInit({
    required double marginSet,
    required double fontSizeSet,
    required bool again,
  }) {
    if (again) {
      margin = marginSet;
      fontSize = fontSizeSet;
      globalKeysLists.clear();
      pageCounts.clear();

      for (var i = 0; i < textListLists.length; i++) {
        pageCounts.add(0);
        globalKeysLists.add([]);
        for (var nestI = 0; nestI < textListLists.length; nestI++) {
          globalKeysLists[i].add(GlobalKey());
        }
      }
      _addHeightValues(globalKeysLists, margin.toInt());
    } else {
      _addHeightValues(globalKeysLists, margin.toInt());
    }
  }

  void _addHeightValue(List<GlobalKey> keys, int margin) {
    Future(() async {
      heightList.clear();
      originYList.clear();
      originYListTop.clear();

      for (final value in keys) {
        heightList.add(_sizeMethod(value, margin));
        controllers.add(FixedExtentScrollController(initialItem: 0));
        _originMethod(value, margin);
      }
      if (heightList.last > 0.0) {
        streamController.sink.add(heightList);
      }
    });
  }

  void _addHeightValues(List<List<GlobalKey>> keysList, int margin) {
    Future(() async {
      heightLists.clear();
      controllers.clear();
      for (var i = 0; i < keysList.length; i++) {
        heightLists.add([]);
        controllers.add(FixedExtentScrollController(initialItem: 0));
        for (var nestI = 0; nestI < keysList.length; nestI++) {
          heightLists[i].add(_sizeMethod(keysList[i][nestI], margin));
        }
      }
      if (heightLists.last.last > 0.0) {
        streamController.sink.add(heightLists.last);
      }
    });
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
