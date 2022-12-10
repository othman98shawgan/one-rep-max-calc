import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/resources/colors.dart';
import 'store_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    appBarTheme:
        const AppBarTheme(backgroundColor: Color(0xff2C363F), foregroundColor: Colors.white),
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    dividerColor: Colors.black12,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
      secondary: Colors.white,
      brightness: Brightness.dark,
    ),
  );

  final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: appBarColor, foregroundColor: Colors.white),
    primaryColor: Colors.white,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroudColor,
    dialogBackgroundColor: backgroudColor,
    // elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(color)),
    dividerColor: Colors.white54,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
      secondary: Colors.black,
      brightness: Brightness.light,
    ),
  );

  late ThemeData _themeData = lightTheme;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      if (kDebugMode) {
        print('value read from storage: $value');
      }
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        if (kDebugMode) {
          print('setting dark theme');
        }
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
