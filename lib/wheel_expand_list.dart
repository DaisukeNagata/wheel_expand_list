import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:wheel_expand_list/wheel_data_model.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_primitive_widget.dart';
import 'package:wheel_expand_list/wheel_swipe_type.dart';

class WheelExpandList extends StatelessWidget {
  const WheelExpandList({
    super.key,
    required this.pageStart,
    required this.pageEnd,
    required this.callBack,
    required this.wheelLogic,
    required this.wheelDataModel,
    required this.wheelPrimitiveWidget,
  });

  final Function(int) pageStart;
  final Function(int) pageEnd;
  final Function(int) callBack;
  final WheelLogic wheelLogic;
  final WheelPrimitiveModel wheelDataModel;
  final WheelPrimitiveWidget wheelPrimitiveWidget;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (v) => {
        /// List area allows tapping
        for (var i = 0; i < wheelLogic.originYList.length; i++)
          {
            if (wheelLogic.originYList[i] >
                    v.localPosition.dy + wheelDataModel.padding &&
                wheelLogic.originYListTop[i] <
                    v.localPosition.dy + wheelDataModel.padding &&
                wheelLogic.originYListTop[wheelDataModel.itemCount] >
                    (v.localPosition.dy +
                        wheelDataModel.margin +
                        wheelDataModel.padding))
              {
                callBack.call(wheelLogic.originYList.indexWhere((element) =>
                    element > (v.localPosition.dy - wheelDataModel.padding))),
              },
          }
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: wheelLogic.heightList
              .getRange(0, wheelDataModel.itemCount)
              .toList()
              .reduce((a, b) => a + b),
          child: Column(
            children: [
              Flexible(
                child: RotatedBox(
                  quarterTurns:
                      wheelDataModel.swipeType == WheelSwipeType.left ? 1 : 3,
                  child: NotificationListener(
                    onNotification: (notificationInfo) {
                      if (notificationInfo is ScrollEndNotification) {
                        wheelLogic.valueSet = wheelLogic.valueSetReady + 1;
                        pageEnd.call(wheelLogic.valueSet);
                        wheelLogic.streamController.sink.add([]);
                      }
                      return true;
                    },
                    child: ListWheelScrollView(
                      controller: wheelLogic.controller,
                      renderChildrenOutsideViewport: false,
                      diameterRatio: wheelDataModel.diameterRatio,
                      itemExtent: MediaQuery.of(context).size.width,
                      physics: const FixedExtentScrollPhysics(),
                      clipBehavior: Clip.antiAlias,
                      onSelectedItemChanged: (index) {
                        pageStart.call(index);
                        wheelLogic.valueSetReady = index;
                        wheelLogic.pageCount = index == 0 ? 1 : index + 1;
                      },
                      children: List<Widget>.generate(
                        wheelDataModel.generate,
                        (value) => Transform.rotate(
                          angle: wheelDataModel.swipeType == WheelSwipeType.left
                              ? 0 * pi / 180
                              : 180 * (pi / 180),
                          child: ListView.builder(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetDesign(BuildContext context, int index) {
    return Row(
      children: [
        SizedBox(
          width: wheelLogic.heightList[index],
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
                    wheelLogic.textList[index],
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
