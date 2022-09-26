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
  var logic = WheelLogic();
  var margin = 30.0;
  List<String> textList = [
    'ABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ'
        'ABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZABCDFGHIJKLMNOPQRSTUVWXYZABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZABCDFGHIJKLMNOPQRSTUVWXYZ',
    'ABCDFGHIJKLMNOPQRSTUVWXYZ',
  ];
  List<GlobalKey> globalKey = [];
  var wheelWidget = WheelWidget();

  Widget _loop() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < globalKey.length; i++) ...[
            wheelWidget.setSizeWidget(
                context, globalKey[i], textList[i], margin, margin.toDouble()),
          ],
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (final _ in textList) {
      globalKey.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    logic.addHeightValue(globalKey, margin.toInt());
    return Scaffold(
      appBar: AppBar(
        title: Text(tex),
      ),
      body: Stack(
        children: [
          _loop(),
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
                        padding: 10,
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
