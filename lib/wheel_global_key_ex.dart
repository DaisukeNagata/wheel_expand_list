import 'package:flutter/cupertino.dart' show GlobalKey, Offset, Rect;

extension GlobalKeyEx on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation == null || renderObject?.paintBounds == null) {
      return null;
    } else {
      return renderObject?.paintBounds
          .shift(Offset(translation.x, translation.y));
    }
  }
}
