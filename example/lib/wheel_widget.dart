import 'package:flutter/material.dart'
    show
        Alignment,
        AnimatedOpacity,
        BuildContext,
        Card,
        Colors,
        Column,
        Container,
        GlobalKey,
        Icon,
        Icons,
        IgnorePointer,
        ListTile,
        MediaQuery,
        SafeArea,
        SingleChildScrollView,
        State,
        StatefulWidget,
        Text,
        TextStyle,
        Widget;
import 'package:wheel_expand_list/wheel_primitive_widget.dart';

class WheelWidget implements WheelPrimitiveWidget {
  const WheelWidget({
    required this.marginSet,
    required this.fontSizeSet,
  });
  final double marginSet;
  final double fontSizeSet;
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
      width: MediaQuery.of(context).size.width - marginSet,
      color: Colors.green,

      /// same widget
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.people),
          title: Text(
            text,
            style: TextStyle(
              fontSize: fontSizeSet,
            ),
          ),
        ),
      ),
    );
  }

  /*
  * Used to pre-size the Widget.
  * */
  @override
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
    return IgnorePointer(
      ignoring: true,
      child: SafeArea(
        child: Container(
          key: key,
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width - margin,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1),
            opacity: 0,

            /// same widget
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSizeSet,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
