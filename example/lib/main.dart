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
  var tex = '';
  var margin = 20.0;
  var fontSize = 20.0;
  var logic = WheelLogic();
  late WheelWidget wheelWidget;
  List<String> textList = [
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
  List<GlobalKey> globalKeys = [];

  @override
  void initState() {
    super.initState();
    for (final _ in textList) {
      globalKeys.add(GlobalKey());
    }
    wheelWidget = WheelWidget(
      marginSet: margin,
      fontSizeSet: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    logic.addHeightValue(globalKeys, margin.toInt());
    return Scaffold(
      appBar: AppBar(
        title: Text(tex),
      ),
      body: Stack(
        children: [
          wheelWidget.loopWidget(
              globalKeys, context, textList, margin, fontSize),
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
                              tex = index.toString();
                            });
                          });
                        },
                        wheelPrimitiveWidget: wheelWidget,
                        textList: textList,
                        heightList: logic.heightList,
                        originYList: logic.originYList,
                        streamController: logic.streamController,
                        margin: margin,
                        padding: margin / 2,
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
