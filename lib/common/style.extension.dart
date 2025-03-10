import 'package:flutter/material.dart';

extension CommonExtensions on BuildContext {
  // Colors
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  // Text styles
  TextStyle get widgetTitle =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle get widgetLabel =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  TextStyle get widgetBody =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.normal);

  TextStyle get widgetBodyBold =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  int get iconSize => 50;
}
