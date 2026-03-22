import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/plate_provider.dart';
import '../service/unit_service.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plateProvider = Provider.of<PlateProvider>(context);
    final unitProvider = Provider.of<UnitNotifier>(context);

    Color surfaceColor = Theme.of(context).colorScheme.surface;
    Color textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Equipment', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // --- BARBELL SECTION ---
          const Text("BARBELL",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              title: Text("Standard Olympic Bar", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
              subtitle: Text(plateProvider.isStandardBar ? "20 KGS / 45 LBS" : "15 KGS / 35 LBS",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              secondary: Icon(Icons.fitness_center, color: textColor),
              value: plateProvider.isStandardBar,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) => plateProvider.toggleBarWeight(value),
            ),
          ),

          const SizedBox(height: 32),

          // --- PLATES SECTION ---
          const Text("AVAILABLE PLATES (PAIRS)",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16)),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plateProvider.inventory.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).dividerColor),
              itemBuilder: (context, index) {
                final plate = plateProvider.inventory[index];
                final weightLabel = unitProvider.unit == 'KGS'
                    ? "${plate.weightKgs.toStringAsFixed(plate.weightKgs % 1 == 0 ? 0 : 2)} kg"
                    : "${plate.weightLbs.toStringAsFixed(plate.weightLbs % 1 == 0 ? 0 : 2)} lb";

                return ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: plate.color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black45),
                    ),
                  ),
                  title: Text(weightLabel, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                        onPressed: plate.availablePairs > 0
                            ? () => plateProvider.updatePlateInventory(index, plate.availablePairs - 1)
                            : null,
                      ),
                      SizedBox(
                        width: 24,
                        child: Text('${plate.availablePairs}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
                        onPressed: () => plateProvider.updatePlateInventory(index, plate.availablePairs + 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
