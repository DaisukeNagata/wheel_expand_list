import 'dart:async';

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
      title: 'EveryDaySoft',
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
  List<GlobalKey> globalKeys = [];

  @override
  void initState() {
    super.initState();
    logic.textList = [
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    ];
    logic.margin = 40.0;
    logic.fontSize = 20.0;
    for (final _ in logic.textList) {
      globalKeys.add(GlobalKey());
    }
    wheelWidget = WheelWidget(
      marginSet: logic.margin,
      fontSizeSet: logic.fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    logic.addHeightValue(globalKeys, logic.margin.toInt());
    return Scaffold(
      appBar: AppBar(
        title: Text('index ${logic.indexCount}: page${logic.pageCount}'),
      ),
      body: Stack(
        children: [
          wheelWidget.loopWidget(
            globalKeys,
            context,
            logic.textList,
            logic.margin,
            logic.fontSize,
          ),
          StreamBuilder(
            stream: logic.streamController.stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
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
}
