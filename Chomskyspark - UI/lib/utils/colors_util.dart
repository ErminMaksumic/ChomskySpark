import 'dart:math';
import 'package:flutter/material.dart';

class ColorsUtil {
  static Color getRandomColor() {
    List<Color> colorList = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.yellow,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.cyan,
      Colors.indigo,
      Colors.teal,
      Colors.lime,
      Colors.grey,
    ];

    return colorList[Random().nextInt(colorList.length)];
  }
}

