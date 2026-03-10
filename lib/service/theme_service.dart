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
    brightness: Brightness.dark, // <--- THIS FIXES THE WHITE SCREEN
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff2C363F),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white70,
    ),
    dividerColor: Colors.white10,
  );

  //*** Light Theme ***/
  final lightTheme = ThemeData(
    brightness: Brightness.light, // <--- ADDED HERE TOO
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      brightness: Brightness.light,
      surface: const Color(0xFFF7F9F2),
      onSurface: const Color(0xff2C363F),
    ),
    scaffoldBackgroundColor: const Color(0xFFD6DBD2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff2C363F),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xff2C363F),
      iconColor: Color(0xff2C363F),
    ),
    dividerColor: Colors.black12,
  );
}
