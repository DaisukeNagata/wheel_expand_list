import 'dart:ffi';
import 'dart:math';

extension GenerateRandomStrings on String {
  String generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len.toInt(), (index) => chars[r.nextInt(chars.length)])
        .join();
  }
}

extension Range on int {
  int randomIntWithRange(int min, int max) {
    int value = Random().nextInt(max - min);
    return value + min;
  }
}
