import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/service/round_to_service.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../service/store_manager.dart';
import '../service/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;

    // Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;

    return Consumer3<ThemeNotifier, RoundNotifier, RoundValueNotifier>(
      builder: (context, theme, roundWeightStatus, roundWeightValue, child) => Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SettingsList(
            sections: [
              SettingsSection(
                title: const Text('General'),
                tiles: [
                  SettingsTile.switchTile(
                    title: const Text('Dark Mode'),
                    leading: const Icon(Icons.dark_mode_outlined),
                    initialValue: theme.getTheme() == theme.darkTheme,
                    onToggle: (value) {
                      if (value) {
                        theme.setDarkMode();
                      } else {
                        theme.setLightMode();
                      }
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Calculation'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    title: const Text('Round Weights'),
                    leading: const Icon(Icons.calculate),
                    initialValue: roundWeightStatus.getRoundStatus(),
                    onToggle: (value) {
                      roundWeightStatus.setStatus(value);
                    },
                  ),
                  SettingsTile.navigation(
                    enabled: roundWeightStatus.getRoundStatus(),
                    leading: const Icon(Icons.onetwothree),
                    title: const Text('Round to nearest'),
                    value: Text('${roundWeightValue.getRoundValue()} Kg'),
                    onPressed: (context) {
                      showRoundToDialog(context, roundWeightValue.getRoundValue());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
