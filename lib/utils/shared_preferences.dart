import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sharedPreferences;

/// TODO: Initialize in main.dart
Future<void> initSharedPreferences() async {
  sharedPreferences = await SharedPreferences.getInstance();
}
