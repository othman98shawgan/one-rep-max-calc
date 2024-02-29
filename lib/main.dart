import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/service/round_to_service.dart';
import 'package:one_rep_max_calc/service/unit_service.dart';
import 'package:one_rep_max_calc/ui/settings_page.dart';

import 'service/store_manager.dart';
import 'service/theme_service.dart';
import 'ui/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  StorageManager.init().then((value) {
    var prefs = value;

    //Theme
    var isDark = StorageManager.readDataFromPrefs('isDark', prefs) ?? true;
    ThemeMode themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeNotifier(themeMode)),
          ChangeNotifierProvider(create: (context) => UnitNotifier()),
          ChangeNotifierProvider(create: (context) => RoundNotifier()),
          ChangeNotifierProvider(create: (context) => RoundValueNotifier()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: '1RM',
              theme: theme.getTheme(),
              initialRoute: '/home',
              routes: {
                '/home': (context) => const MyHomePage(title: '1RM Calculator'),
                '/settings': (context) => const SettingsPage(title: 'Settings'),
              },
            ));
  }
}
