import 'package:flutter/material.dart';

String appName = 'GnuCash Mobile';

Color lightPrimary = const Color(0xfff3f4f9);
Color darkPrimary = const Color(0xff2B2B2B);
Color lightAccent = const Color(0xff597ef7);
Color darkAccent = const Color(0xff597ef7);
Color lightBG = const Color(0xfff3f4f9);
Color darkBG = const Color(0xff2B2B2B);

TextStyle biggerFont = const TextStyle(fontSize: 18.0);

ThemeData lightTheme = ThemeData(
  primaryColor: lightPrimary,
  scaffoldBackgroundColor: lightBG,
  appBarTheme: AppBarTheme(
    elevation: 0,
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ).titleLarge,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkPrimary,
  scaffoldBackgroundColor: darkBG,
  appBarTheme: AppBarTheme(
    backgroundColor: darkBG,
    elevation: 0,
    toolbarTextStyle: TextTheme(
      titleLarge: TextStyle(
        color: lightBG,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ).bodyMedium,
    titleTextStyle: TextTheme(
      titleLarge: TextStyle(
        color: lightBG,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ).titleLarge,
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: darkAccent),
);

//  List<T> map<T>(List list, Function handler) {
//   List<T> result = [];
//   for (var i = 0; i < list.length; i++) {
//     result.add(handler(i, list[i]));
//   }
//
//   return result;
// }
