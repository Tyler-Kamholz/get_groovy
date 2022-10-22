import 'dart:math';
import 'package:flutter/material.dart';

// Can this be an extension to Colors? I can't get it working
class ColorHelper {
  static Color random() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}