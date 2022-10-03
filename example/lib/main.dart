import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_expand_list.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var wheelLogic = WheelLogic();
  late WheelDataSet wheelDataSet;
  late WheelWidget wheelWidget;
  var slideActionFlg = false;

  int _randomIntWithRange(int min, int max) {
    int value = Random().nextInt(max - min);
    return value + min;
  }

  String _generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len.toInt(), (index) => chars[r.nextInt(chars.length)])
        .join();
  }

  /// Example
  void _updateData() {
    setState(() {
      wheelLogic.textList.clear();

      for (var i = 1; i < 11; i++) {
        wheelLogic.textList
            .add(_generateRandomString(i * _randomIntWithRange(1, 100)));
        wheelLogic.pageList.add(_randomIntWithRange(1, 9));
        wheelLogic.valueSet = wheelLogic.pageList.first;
      }
      wheelLogic.fontSize = _randomIntWithRange(10, 50).toDouble();
      wheelLogic.margin = _randomIntWithRange(50, 200).toDouble();
      wheelDataSet = WheelDataSet(
        logic: wheelLogic,
        slideActionFlg: slideActionFlg,
      );
      wheelWidget = WheelWidget(
        marginSet: wheelLogic.margin,
        fontSizeSet: wheelLogic.fontSize,
      );
      Future.delayed(Duration(milliseconds: 100), () {
        wheelLogic.addHeightValue(
            wheelLogic.globalKeys, wheelDataSet.margin.truncate());
      });
    });
  }

  Widget _rightButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => {
        setState(() {
          _updateData();
        }),
      },
    );
  }

  @override
  void initState() {
    /// Example
    for (var i = 1; i < 11; i++) {
      wheelLogic.textList
          .add(_generateRandomString(i * _randomIntWithRange(1, 100)));
      wheelLogic.pageList.add(_randomIntWithRange(1, 9));
      wheelLogic.valueSet = wheelLogic.pageList.first;
    }

    super.initState();

    wheelLogic.initSet(
      marginSet: 50.0,
      fontSizeSet: 20.0,
    );

    wheelDataSet = WheelDataSet(
      logic: wheelLogic,
      slideActionFlg: slideActionFlg,
    );
    wheelWidget = WheelWidget(
      marginSet: wheelLogic.margin,
      fontSizeSet: wheelLogic.fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('index${wheelLogic.indexCount}: page${wheelLogic.pageCount}'),
        actions: [
          _rightButton(),
        ],
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => {
            setState(() {
              slideActionFlg = !slideActionFlg;
              wheelDataSet = WheelDataSet(
                logic: wheelLogic,
                slideActionFlg: slideActionFlg,
              );
            }),
          },
        ),
      ),
      body: Stack(
        children: [
          wheelWidget.loopWidget(
            context,
            wheelLogic.globalKeys,
            wheelLogic.textList,
            wheelLogic.margin,
            wheelLogic.fontSize,
          ),
          StreamBuilder(
            stream: wheelLogic.streamController.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<double>> snapshot,
            ) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      WheelExpandList(
                        callBack: (index) {
                          Future(() {
                            setState(() {
                              wheelLogic.indexCount = index;
                            });
                          });
                        },
                        pageCall: (index) {
                          wheelLogic.indexCount = 0;
                          slideActionFlg
                              ? wheelDataSet.startController(
                                  index,
                                  300,
                                  wheelLogic.controller,
                                  Curves.slowMiddle,
                                )
                              : wheelDataSet.startController(
                                  index,
                                  300,
                                  wheelLogic.controller,
                                  Curves.easeOut,
                                );
                        },
                        wheelDataModel: wheelDataSet,
                        wheelPrimitiveWidget: wheelWidget,
                        wheelLogic: wheelLogic,
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
