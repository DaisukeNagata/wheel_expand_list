import 'package:flutter/widgets.dart';

class WheelPrimitiveWidget {
  Widget primitiveWidget(
    BuildContext context,
    String text,
    int margin,
    double fontSize,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - margin,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }

  Widget setSizeWidget(
    BuildContext context,
    GlobalKey key,
    String text,
    int margin,
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
          ),
        ),
      ),
    );
  }
}
