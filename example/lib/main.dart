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

  @override
  void initState() {
    super.initState();

    /// Example
    for (var i = 0; i < 10; i++) {
      logic.textList.add(i.toString());
      logic.pageList.add(Random().nextInt(9) == 0 ? 1 : Random().nextInt(9));
      logic.valueSet = Random().nextInt(9);
    }

    logic.initSet(
      marginSet: 20.0,
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
}
