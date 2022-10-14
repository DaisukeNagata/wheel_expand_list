import 'dart:math' show pi;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_data_model.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_primitive_widget.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';

class WheelExpandListHorizontal extends StatelessWidget {
  const WheelExpandListHorizontal({
    super.key,
    required this.pageStart,
    required this.pageEnd,
    required this.wheelLogic,
    required this.wheelDataModel,
    required this.wheelPrimitiveWidget,
  });

  final Function(int) pageStart;
  final Function(int) pageEnd;
  final WheelLogic wheelLogic;
  final WheelPrimitiveModel wheelDataModel;
  final WheelPrimitiveWidget wheelPrimitiveWidget;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: wheelLogic.pageList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
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
                          onNotification: (info) {
                            if (info is ScrollStartNotification) {
                              _startNotification(index);
                            } else if (info is ScrollEndNotification) {
                              pageEnd.call(wheelLogic.valueSetReady);
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
                              _onSelectedItemChanged(index);
                            },
                            children: List<Widget>.generate(
                              wheelDataModel.generate,
                              (value) => Transform.rotate(
                                angle: wheelDataModel.swipeType ==
                                        WheelSwipeType.left
                                    ? 0 * pi / 180
                                    : 180 * pi / 180,
                                child: SizedBox(
                                  height: wheelLogic
                                      .heightLists[wheelLogic.pageCounts[index]]
                                      .getRange(0, wheelDataModel.itemCount)
                                      .toList()
                                      .reduce((a, b) => a + b),
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

  void _onSelectedItemChanged(int index) {
    pageStart.call(index);
    wheelLogic.valueSetReady = index;
  }

  void _startNotification(int index) {
    wheelLogic.indexCount = index;

    wheelLogic.pageCount = index;
    wheelLogic.valueSetReady = wheelLogic.pageCounts[index];
    wheelLogic.valueSet = wheelLogic.valueSetReady + 1;
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
                    wheelLogic.textLists[wheelLogic.pageCounts[index]][index],
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
