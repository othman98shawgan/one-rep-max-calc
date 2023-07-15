import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/resources/colors.dart';
import 'package:one_rep_max_calc/service/round_to_service.dart';
import 'package:one_rep_max_calc/service/unit_service.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
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
    return Consumer4<ThemeNotifier, RoundNotifier, RoundValueNotifier, UnitNotifier>(
      builder: (context, theme, roundWeightStatus, roundWeightValue, unitProvider, child) => Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SettingsList(
            lightTheme: const SettingsThemeData(settingsListBackground: backgroudColor),
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
                  SettingsTile.navigation(
                    leading: const Icon(Icons.monitor_weight),
                    title: const Text('Unit'),
                    value: Text(unitProvider.unitDesc),
                    trailing: const Icon(Icons.navigate_next),
                    onPressed: (context) {
                      showUnitDialog(context, unitProvider.unit);
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
                    value: Text('${roundWeightValue.getRoundValue()} ${unitProvider.unit}'),
                    trailing: const Icon(Icons.navigate_next),
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
