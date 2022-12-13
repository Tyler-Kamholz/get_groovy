/// Name: Matthew
/// Date: January 13, 2022
/// Bugs: N/A
/// Reflection: Simple random color helper function

import 'dart:math';
import 'package:flutter/material.dart';

// Can this be an extension to Colors? I can't get it working
class ColorHelper {
  /// Generates a random color
  static Color random() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
