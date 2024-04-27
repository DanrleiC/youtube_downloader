import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData.light(useMaterial3: true);
  }

  static ThemeData get dark {
    return ThemeData.dark(useMaterial3: true);
  }
}