import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:wheel_expand_list/wheel_data_model.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_primitive_widget.dart';

class WheelExpandList extends StatelessWidget {
  const WheelExpandList({
    super.key,
    required this.margin,
    required this.padding,
    required this.callBack,
    required this.logic,
    required this.pageCall,
    required this.wheelDataModel,
    required this.wheelPrimitiveWidget,
    required this.streamController,
  });

  final double margin;
  final double padding;
  final Function(int) callBack;
  final Function(int) pageCall;
  final WheelLogic logic;
  final WheelDataModel wheelDataModel;
  final WheelPrimitiveWidget wheelPrimitiveWidget;
  final StreamController<List<double>> streamController;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (v) => {
        for (var i = 0; i < logic.originYList.length; i++)
          {
            if (logic.originYList[i] > v.localPosition.dy + padding &&
                logic.originYListTop[i] < v.localPosition.dy + padding &&
                logic.originYListTop[logic.pageList[logic.valueSet]] - margin >
                    v.localPosition.dy + padding)
              {
                callBack.call(logic.originYList.indexWhere(
                    (element) => element > (v.localPosition.dy - padding))),
              },
          },
      },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: logic.heightList
                  .getRange(0, logic.pageCount)
                  .toList()
                  .reduce((a, b) => a + b),
              child: Column(
                children: [
                  Flexible(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: NotificationListener(
                        onNotification: (notificationInfo) {
                          if (notificationInfo is ScrollEndNotification) {
                            Future(() {
                              logic.valueSet = logic.valueSetReady + 1;
                              streamController.sink.add([]);
                            });
                          } else if (notificationInfo
                              is ScrollStartNotification) {
                            Future(() {
                              logic.indexCount = 0;
                            });
                          }
                          return true;
                        },
                        child: ListWheelScrollView(
                          controller: logic.c,
                          renderChildrenOutsideViewport: false,
                          diameterRatio: wheelDataModel.diameterRatio,
                          itemExtent: MediaQuery.of(context).size.width,
                          physics: const FixedExtentScrollPhysics(),
                          clipBehavior: Clip.antiAlias,
                          onSelectedItemChanged: (index) {
                            pageCall.call(index);
                            logic.valueSetReady = index;
                            logic.pageCount = index == 0 ? 1 : index + 1;
                          },
                          children: List<Widget>.generate(
                            wheelDataModel.generate,
                            (value) => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: wheelDataModel.itemCount,
                              itemBuilder: (context, index) {
                                return _widgetDesign(context, index);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetDesign(BuildContext context, int index) {
    return Row(
      children: [
        SizedBox(
          width: logic.heightList[index],
          height: MediaQuery.of(context).size.width - margin,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              transform: Matrix4.identity()
                ..rotateZ(-90 * pi / 180)
                ..setTranslationRaw(
                  0,
                  MediaQuery.of(context).size.width - margin,
                  0,
                ),
              child: Wrap(
                children: [
                  wheelPrimitiveWidget.primitiveWidget(
                    context,
                    logic.textList[index],
                    0,
                    0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
