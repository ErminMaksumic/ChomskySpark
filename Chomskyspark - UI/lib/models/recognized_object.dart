import 'dart:ui';

import 'package:flutter/material.dart';

class RecognizedObject {
  final String name;
  late Color color = Colors.red;
  final double confidence;
  final double x;
  final double y;
  final double h;
  final double w;

  RecognizedObject({
    required this.name,
    required this.confidence,
    required this.x,
    required this.y,
    required this.h,
    required this.w,
  });

  factory RecognizedObject.fromJson(Map<String, dynamic> json) {
    return RecognizedObject(
      name: json['name'],
      confidence: _toDouble(json['confidence']),
      x: _toDouble(json['x']),
      y: _toDouble(json['y']),
      h: _toDouble(json['h']),
      w: _toDouble(json['w']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      throw ArgumentError('Invalid type for double conversion');
    }
  }
}