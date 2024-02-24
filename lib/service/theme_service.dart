import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/resources/colors.dart';
import 'store_manager.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;

  ThemeNotifier(ThemeMode themeMode) {
    if (themeMode == ThemeMode.light) {
      _themeData = lightTheme;
    } else {
      _themeData = darkTheme;
    }
    notifyListeners();
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    StorageManager.saveData('isDark', true);
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    StorageManager.saveData('isDark', false);
    notifyListeners();
  }

  //=============================================================================
  // Themes
  //=============================================================================

  //*** Dark Theme ***/
  final darkTheme = ThemeData(
    appBarTheme:
        const AppBarTheme(backgroundColor: Color(0xff2C363F), foregroundColor: Colors.white),
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    dividerColor: Colors.black12,
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: darkThemeSwatch).copyWith(
      secondary: Colors.white,
      brightness: Brightness.dark,
      background: const Color(0xFF212121),
    ),
  );

  //*** Light Theme ***/
  final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: appBarColor, foregroundColor: Colors.white),
    primaryColor: Colors.white,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroudColor,
    dialogBackgroundColor: backgroudColor,
    // elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(color)),
    dividerColor: Colors.white54,
    focusColor: lightThemeSwatch,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: lightThemeSwatch).copyWith(
      secondary: Colors.black,
      brightness: Brightness.light,
    ),
  );
}
