import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_expand_list.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
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
  var logic = WheelLogic();
  late WheelWidget wheelWidget;

  int randomIntWithRange(int min, int max) {
    int value = Random().nextInt(max - min);
    return value + min;
  }

  @override
  void initState() {
    /// Example
    for (var i = 1; i < 11; i++) {
      logic.textList.add(_generateRandomString(i * randomIntWithRange(1, 100)));
      logic.pageList.add(randomIntWithRange(1, 9));
      logic.valueSet = logic.pageList.first;
    }
    super.initState();

    logic.initSet(
      marginSet: 50.0,
      fontSizeSet: 20.0,
    );

    wheelWidget = WheelWidget(
      marginSet: logic.margin,
      fontSizeSet: logic.fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('index${logic.indexCount}: page${logic.pageCount}'),
      ),
      body: Stack(
        children: [
          wheelWidget.loopWidget(
            logic.globalKeys,
            context,
            logic.textList,
            logic.margin,
            logic.fontSize,
          ),
          StreamBuilder(
            stream: logic.streamController.stream,
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
                              logic.indexCount = index;
                            });
                          });
                        },
                        callPage: (page) {
                          Future(() {
                            setState(() {
                              logic.pageCount = page;
                            });
                          });
                        },
                        wheelPrimitiveWidget: wheelWidget,
                        streamController: logic.streamController,
                        margin: logic.margin,
                        padding: logic.margin / 2,
                        logic: logic,
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

  String _generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len.toInt(), (index) => chars[r.nextInt(chars.length)])
        .join();
  }
}
