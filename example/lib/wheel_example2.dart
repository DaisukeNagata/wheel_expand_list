import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_expand_list_horizontal.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';
import 'package:wheel_expand_list_example/wheel_data_set.dart';
import 'package:wheel_expand_list_example/wheel_extension_logic.dart';
import 'package:wheel_expand_list_example/wheel_widget.dart';

class WheelExample2 extends StatelessWidget {
  const WheelExample2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const WheelPage2();
  }
}

class WheelPage2 extends StatefulWidget {
  const WheelPage2({
    super.key,
  });

  @override
  State<WheelPage2> createState() => WheelPageState2();
}

class WheelPageState2 extends State<WheelPage2> {
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
        title: Text(
            'index${wheelLogic.indexCount}: page${wheelLogic.pageCounts[wheelLogic.pageCount] + 1}'),
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
          for (var i = 0; i < wheelLogic.textListLists.length; i++) ...[
            wheelWidget.loopWidget(
              context,
              wheelLogic.globalKeysLists[i],
              wheelLogic.textListLists[i],
              wheelLogic.margin,
              wheelLogic.fontSize,
            ),
          ],
          StreamBuilder(
            stream: wheelLogic.streamController.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<double>> snapshot,
            ) {
              if (snapshot.hasData) {
                return WheelExpandListHorizontal(
                  tapCall: (index) {
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
                            wheelLogic.controllers[wheelLogic.indexCount],
                            Curves.slowMiddle,
                          )
                        : wheelDataSet.startController(
                            index,
                            300,
                            wheelLogic.controllers[wheelLogic.indexCount],
                            Curves.easeOut,
                          );
                  },
                  pageEnd: (value) {
                    Future(() {
                      setState(() {
                        wheelLogic.pageCounts[wheelLogic.pageCount] = value;
                      });
                    });
                  },
                  wheelDataModel: wheelDataSet,
                  wheelPrimitiveWidget: wheelWidget,
                  wheelLogic: wheelLogic,
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
