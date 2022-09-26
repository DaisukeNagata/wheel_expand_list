import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:wheel_expand_list/wheel_primitive_widget.dart';

class WheelExpandList extends StatelessWidget {
  const WheelExpandList({
    super.key,
    required this.margin,
    required this.padding,
    required this.callBack,
    required this.textList,
    required this.heightList,
    required this.originYList,
    required this.wheelPrimitiveWidget,
    required this.streamController,
  });

  final double margin;
  final double padding;
  final Function(int) callBack;
  final List<String> textList;
  final List<double> heightList;
  final List<double> originYList;
  final WheelPrimitiveWidget wheelPrimitiveWidget;
  final StreamController<List<double>> streamController;
  static int valueSet = 1;
  static int valueSetReady = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (v) => {
        callBack.call(originYList
            .indexWhere((element) => element > (v.localPosition.dy - padding))),
      },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: heightList
                      .getRange(0, valueSet)
                      .toList()
                      .reduce((a, b) => a + b) -
                  margin,
              child: Column(
                children: [
                  Flexible(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: NotificationListener(
                        onNotification: (notificationInfo) {
                          if (notificationInfo is ScrollEndNotification) {
                            Future(() {
                              valueSet = valueSetReady;
                              streamController.sink.add([]);
                            });
                          }
                          return true;
                        },
                        child: ListWheelScrollView(
                          itemExtent: MediaQuery.of(context).size.width,
                          physics: const FixedExtentScrollPhysics(),
                          clipBehavior: Clip.antiAlias,
                          onSelectedItemChanged: (index) {
                            if (valueSet != index + 1) {
                              valueSetReady = index + 1;
                            }
                          },
                          children: List<Widget>.generate(
                            heightList.length,
                            (value) => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: value + 1,
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
          width: heightList[index],
          height: MediaQuery.of(context).size.width - margin,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              transform: Matrix4.identity()
                ..rotateZ(-90 * pi / 180)
                ..setTranslationRaw(
                    0, MediaQuery.of(context).size.width - margin, 0),
              child: Wrap(
                children: [
                  wheelPrimitiveWidget.primitiveWidget(
                      context, textList[index], margin, 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
