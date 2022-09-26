import 'package:flutter/material.dart';
import 'package:wheel_expand_list/wheel_primitive_widget.dart';

class WheelWidget implements WheelPrimitiveWidget {
  /*
　*You can set your favorite design.
　* */
  @override
  Widget primitiveWidget(
    BuildContext context,
    String text,
    double margin,
    double fontSize,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      color: Colors.green,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }

  /*
  * Used to pre-size the Widget.
  * */
  @override
  Widget setSizeWidget(
    BuildContext context,
    GlobalKey<State<StatefulWidget>> key,
    String text,
    double margin,
    double fontSize,
  ) {
    return SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width - margin,
        child: Text(
          key: key,
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
