import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_expand_list.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_example2.dart';
import 'package:wheel_expand_list_example/wheel_extension_logic.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';

void main() {
  runApp(const WheelExample());
}

class WheelExample extends StatelessWidget {
  const WheelExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WheelPage(),
    );
  }
}

class WheelPage extends StatefulWidget {
  const WheelPage({
    super.key,
  });

  @override
  State<WheelPage> createState() => WheelPageState();
}

class WheelPageState extends State<WheelPage> {
  var wheelLogic = WheelLogic();
  late WheelDataSet wheelDataSet;
  late WheelWidget wheelWidget;

  @override
  void initState() {
    updateData(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        title:
            Text('index${wheelLogic.indexCount}: page${wheelLogic.pageCount}'),
        actions: [
          Row(
            children: [
              rightOfLeftButton(),
              rightOfRightButton(),
            ],
          ),
        ],
        leading: Row(
          children: [
            leftOfLeftButton(),
            leftOfRightButton(),
          ],
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
                        pageStart: (index) {
                          wheelLogic.slideActionFlg
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
                        pageEnd: (value) {
                          Future(() {
                            setState(() {
                              wheelLogic.indexCount = 0;
                              wheelLogic.pageCount = value;
                            });
                          });
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
