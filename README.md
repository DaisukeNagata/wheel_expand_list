# wheel_expand_list

A new Flutter plugin project.

## Construction

### Your favorite design will be reflected in the Widget.
```
  /*
　*You can set your favorite design.
　* */
  @override
  Widget primitiveWidget(
    BuildContext context,
    String text,
    int margin,
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
```


## Example

|  | |
:--: | :--:
|<img width="300" src="https://user-images.githubusercontent.com/16457165/192257620-2e9ad9ba-4251-4ebb-bdc1-aec242441833.gif">|<img width="400" src="https://user-images.githubusercontent.com/16457165/192257599-97c82dfa-e079-4a6b-9e7a-a37f98ad42b3.gif">|
