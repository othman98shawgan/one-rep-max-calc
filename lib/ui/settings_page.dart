import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/service/formula_service.dart';
import 'package:one_rep_max_calc/service/round_to_service.dart';
import 'package:one_rep_max_calc/service/unit_service.dart';
import 'package:provider/provider.dart';
import '../service/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Consumer5<ThemeNotifier, RoundNotifier, RoundValueNotifier, UnitNotifier, FormulaNotifier>(
      builder: (context, theme, roundWeightStatus, roundWeightValue, unitProvider, formulaProvider, child) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;
        Color surfaceColor = Theme.of(context).colorScheme.surface;
        Color dividerColor = Theme.of(context).dividerColor;
        Color textColor = Theme.of(context).colorScheme.onSurface;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // --- GENERAL SECTION ---
              const Text(
                "GENERAL",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text("Dark Theme", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      secondary: Icon(Icons.dark_mode_outlined, color: textColor),
                      value: isDark,
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                      activeColor: isDark ? Colors.teal : const Color(0xff2C363F),
                      onChanged: (value) {
                        if (value) {
                          theme.setDarkMode();
                        } else {
                          theme.setLightMode();
                        }
                      },
                    ),
                    Divider(height: 1, color: dividerColor),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.monitor_weight_outlined, color: textColor),
                              const SizedBox(width: 16),
                              Text("Weight Unit",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                            ],
                          ),
                          SizedBox(
                            width: 140,
                            child: _buildUnitToggle(context, unitProvider, roundWeightValue, isDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // --- CALCULATION SECTION ---
              const Text(
                "CALCULATION",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.fitness_center, color: textColor),
                      title: Text('Barbell & Plates Inventory',
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      subtitle: Text('Bar: 20 KGS • 6 Plate Types',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      trailing: const Icon(Icons.navigate_next, color: Colors.grey),
                      onTap: () {
                        Navigator.pushNamed(context, '/inventory');
                      },
                    ),
                    Divider(height: 1, color: dividerColor),
                    SwitchListTile(
                      title: Text("Round Weights", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      secondary: Icon(Icons.calculate_outlined, color: textColor),
                      value: roundWeightStatus.getRoundStatus(),
                      activeColor: isDark ? Colors.teal : const Color(0xff2C363F),
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
                      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                      onChanged: (value) {
                        roundWeightStatus.setStatus(value);
                      },
                    ),
                    Divider(height: 1, color: dividerColor),
                    ListTile(
                      enabled: roundWeightStatus.getRoundStatus(),
                      leading: Icon(Icons.tune, color: textColor),
                      title: Text('Round to nearest', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${roundWeightValue.getRoundValue()} ${unitProvider.unit}',
                              style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          const Icon(Icons.navigate_next, color: Colors.grey),
                        ],
                      ),
                      onTap: () => showRoundToDialog(context, roundWeightValue.getRoundValue()),
                    ),
                    Divider(height: 1, color: dividerColor),
                    ListTile(
                      leading: Icon(Icons.functions, color: textColor),
                      title:
                          Text('Calculation formula', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${formulaNames[formulaProvider.formula]}',
                              style: const TextStyle(color: Colors.grey, fontSize: 14)),
                          const Icon(Icons.navigate_next, color: Colors.grey),
                        ],
                      ),
                      onTap: () => showFormulaDialog(context, formulaProvider.formula!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  } // The custom segmented toggle adapted for KGS/LBS

  Widget _buildUnitToggle(
      BuildContext context, UnitNotifier unitProvider, RoundValueNotifier roundValueNotifier, bool isDark) {
    const Color activeColor = Color(0xFF2C363F);
    Color bgColor = isDark ? Colors.black26 : Colors.grey.shade200;

    return Container(
      height: 40,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: ['KGS', 'LBS'].map((unit) {
          final isSelected = unitProvider.unit == unit;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (unit == 'KGS' && unitProvider.unit != 'KGS') {
                  unitProvider.setKGS();
                  roundValueNotifier.convertToKgs();
                } else if (unit == 'LBS' && unitProvider.unit != 'LBS') {
                  unitProvider.setLBS();
                  roundValueNotifier.convertToLbs();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? (isDark ? Colors.teal : activeColor) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  unit,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
