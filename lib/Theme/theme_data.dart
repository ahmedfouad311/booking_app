// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class MyThemeData {
  static const Color LIGHT_BACKGROUND_COLOR =
      Color.fromARGB(255, 223, 236, 219);
  static const Color DARK_BACKGROUND_COLOR = Color.fromARGB(255, 6, 14, 30);
  static const Color DARK_PRIMARY_COLOR = Color.fromARGB(255, 93, 156, 236);

  static final ThemeData LIGHT_THEME = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: LIGHT_BACKGROUND_COLOR,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 32,
        color: Colors.black,
      ),
      headline2: TextStyle(fontSize: 32, color: Colors.blue),
      headline3: TextStyle(
        fontSize: 28,
        color: Colors.black,
      ),
      headline4: TextStyle(
        fontSize: 28,
        color: Colors.blue,
      ),
      headline5: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
      headline6: TextStyle(fontSize: 24, color: Colors.blue),
      subtitle1: TextStyle(
        fontSize: 18,
        color: Colors.black45,
      ),
      subtitle2: TextStyle(
        fontSize: 16,
        color: Colors.black45,
      ),
    ),
  );
}
