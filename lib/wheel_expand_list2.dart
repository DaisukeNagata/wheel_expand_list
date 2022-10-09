import 'dart:math' show pi;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_data_model.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_primitive_widget.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';

class WheelExpandList2 extends StatelessWidget {
  const WheelExpandList2({
    super.key,
    required this.pageStart,
    required this.pageEnd,
    required this.tapCall,
    required this.wheelLogic,
    required this.wheelDataModel,
    required this.wheelPrimitiveWidget,
  });

  final Function(int) pageStart;
  final Function(int) pageEnd;
  final Function(int) tapCall;
  final WheelLogic wheelLogic;
  final WheelPrimitiveModel wheelDataModel;
  final WheelPrimitiveWidget wheelPrimitiveWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTapDown: (_) {
              tapCall.call(index);
              wheelLogic.pageCount = index;
              wheelLogic.valueSetReady = wheelLogic.pageCounts[index];
              wheelLogic.valueSet = wheelLogic.valueSetReady + 1;
            },
            child: SafeArea(
              child: SizedBox(
                height: wheelLogic.heightLists[wheelLogic.pageCounts[index]]
                    [index],
                child: Column(
                  children: [
                    Flexible(
                      child: RotatedBox(
                        quarterTurns:
                            wheelDataModel.swipeType == WheelSwipeType.left
                                ? 1
                                : 3,
                        child: NotificationListener(
                          onNotification: (notificationInfo) {
                            if (notificationInfo is ScrollEndNotification) {
                              wheelLogic.valueSet =
                                  wheelLogic.valueSetReady + 1;

                              pageEnd.call(wheelLogic.valueSetReady);
                              wheelLogic.streamController.sink.add([]);
                            }
                            return true;
                          },
                          child: ListWheelScrollView(
                            controller: wheelLogic.controllers[index],
                            renderChildrenOutsideViewport: false,
                            diameterRatio: wheelDataModel.diameterRatio,
                            itemExtent: MediaQuery.of(context).size.width,
                            physics: const FixedExtentScrollPhysics(),
                            clipBehavior: Clip.antiAlias,
                            onSelectedItemChanged: (index) {
                              pageStart.call(index);
                              wheelLogic.valueSetReady = index;
                            },
                            children: List<Widget>.generate(
                              wheelDataModel.generate,
                              (value) => Transform.rotate(
                                angle: wheelDataModel.swipeType ==
                                        WheelSwipeType.left
                                    ? 0 * pi / 180
                                    : 180 * pi / 180,
                                child: Container(
                                  height: wheelLogic
                                      .heightLists[wheelLogic.pageCounts[index]]
                                      .getRange(0, wheelDataModel.itemCount)
                                      .toList()
                                      .reduce((a, b) => a + b),
                                  color:
                                      index.isOdd ? Colors.black : Colors.white,
                                  child: _widgetDesign(context, index),
                                ),
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
          );
        },
      ),
    );
  }

  Widget _widgetDesign(BuildContext context, int index) {
    return Row(
      children: [
        SizedBox(
          width: wheelLogic.heightLists[wheelLogic.pageCounts[index]][index],
          height: MediaQuery.of(context).size.width - wheelDataModel.margin,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              transform: Matrix4.identity()
                ..rotateZ(-90 * pi / 180)
                ..setTranslationRaw(
                  wheelDataModel.padding,
                  MediaQuery.of(context).size.width - wheelDataModel.margin,
                  0,
                ),
              child: Wrap(
                children: [
                  wheelPrimitiveWidget.primitiveWidget(
                    context,
                    wheelLogic.textListLists[wheelLogic.pageCounts[index]]
                        [index],
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
