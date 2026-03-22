import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/plate_provider.dart';
import '../../service/unit_service.dart';

class BarbellVisualizer extends StatelessWidget {
  const BarbellVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    Color borderColor = Theme.of(context).dividerColor;
    Color shaftColor = Colors.grey.shade400;
    Color collarColor = Colors.grey.shade500;
    Color sleeveColor = Colors.grey.shade400;

    final plateProvider = Provider.of<PlateProvider>(context);
    final unitProvider = Provider.of<UnitNotifier>(context);

    return Column(
      children: [
        // 1. THE BARBELL (With your horizontal scrolling plates)
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // The Shaft
                Container(
                  width: 50,
                  height: 16,
                  decoration: BoxDecoration(
                    color: shaftColor,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                    border: const Border(
                      top: BorderSide(color: Colors.black12, width: 1),
                      bottom: BorderSide(color: Colors.black12, width: 1),
                      left: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                ),

                // The Collar
                Container(
                  width: 16,
                  height: 56,
                  decoration: BoxDecoration(
                    color: collarColor,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.black26, width: 1),
                  ),
                ),

                // Horizontally Scrolling Plates + Sleeve
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        ...plateProvider.loadedPlates
                            .map((plate) => _buildPlate(plate.color, plate.height, plate.width)),
                        Container(
                          width: 110,
                          height: 28,
                          decoration: BoxDecoration(
                            color: sleeveColor,
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
                            border: const Border(
                              top: BorderSide(color: Colors.black12, width: 1),
                              bottom: BorderSide(color: Colors.black12, width: 1),
                              right: BorderSide(color: Colors.black12, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. THE WARNING BANNER (Now underneath)
        if (plateProvider.hasMissingPlates) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.5), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 22),
                const SizedBox(width: 8),
                Text(
                  "Inventory short by ${plateProvider.missingWeight.toStringAsFixed(1)} ${unitProvider.unit}",
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlate(Color color, double height, double width) {
    return Container(
      margin: const EdgeInsets.only(left: 1),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.black.withOpacity(0.4), width: 1),
      ),
    );
  }
}
