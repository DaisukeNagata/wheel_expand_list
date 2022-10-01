import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:wheel_expand_list/wheel_data_model.dart';
import 'package:wheel_expand_list/wheel_logic.dart';
import 'package:wheel_expand_list/wheel_primitive_widget.dart';

class WheelExpandList extends StatelessWidget {
  const WheelExpandList({
    super.key,
    required this.pageCall,
    required this.callBack,
    required this.wheelLogic,
    required this.wheelDataModel,
    required this.wheelPrimitiveWidget,
  });

  final Function(int) pageCall;
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
      child: Padding(
        padding: EdgeInsets.all(wheelDataModel.padding),
        child: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: wheelLogic.heightList
                  .getRange(0, wheelDataModel.itemCount)
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
                              wheelLogic.valueSet =
                                  wheelLogic.valueSetReady + 1;
                              wheelLogic.streamController.sink.add([]);
                            });
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
                            pageCall.call(index);
                            wheelLogic.valueSetReady = index;
                            wheelLogic.pageCount = index == 0 ? 1 : index + 1;
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
          width: wheelLogic.heightList[index],
          height: MediaQuery.of(context).size.width - wheelDataModel.margin,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              transform: Matrix4.identity()
                ..rotateZ(-90 * pi / 180)
                ..setTranslationRaw(
                  0,
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
