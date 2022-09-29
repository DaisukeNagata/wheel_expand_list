# wheel_expand_list

https://pub.dev/packages/wheel_expand_list

## Construction

### Your favorite design will be reflected in the Widget.
```
  MyApp class ....
  var margin = 30.0;
  var fontSize = 30.0;
  
  wheelWidget = WheelWidget(
    marginSet: margin,
    fontSizeSet: fontSize,
  );
  
  WheelWidget class ....
  check is this 'same widget'
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

```


## Example

||  
|-| 
|<img width="300" src="https://user-images.githubusercontent.com/16457165/193065626-2ac127e0-39cf-49f9-ab43-927e44b1a844.gif">|




