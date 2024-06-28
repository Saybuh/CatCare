import 'package:flutter/material.dart';

final ThemeData catCareTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.teal,
  ).copyWith(
    secondary: Colors.orangeAccent,
  ),
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    headlineLarge: TextStyle(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black54),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.teal,
    titleTextStyle: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
  ),
);
