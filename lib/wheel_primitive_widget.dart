import 'package:flutter/widgets.dart'
    show
        Alignment,
        BuildContext,
        Column,
        Container,
        GlobalKey,
        MediaQuery,
        SafeArea,
        SingleChildScrollView,
        SizedBox,
        Text,
        TextStyle,
        Widget;

class WheelPrimitiveWidget {
  Widget primitiveWidget(
    BuildContext context,
    String text,
    double margin,
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
          ),
        ),
      ),
    );
  }

  Widget loopWidget(
    BuildContext context,
    List<GlobalKey> keys,
    List<String> textList,
    double margin,
    double fontSize,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < keys.length; i++) ...[
            setSizeWidget(
              context,
              keys[i],
              textList[i],
              margin,
              fontSize,
            ),
          ],
        ],
      ),
    );
  }
}
