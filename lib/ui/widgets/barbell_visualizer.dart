import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/plate_provider.dart';

class BarbellVisualizer extends StatelessWidget {
  const BarbellVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    Color borderColor = Theme.of(context).dividerColor;
    Color shaftColor = Colors.grey.shade400;
    Color collarColor = Colors.grey.shade500;
    Color sleeveColor = Colors.grey.shade400;

    // Grab the plate provider
    final plateProvider = Provider.of<PlateProvider>(context);

    return Container(
      width: double.infinity,
      height: 200,
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
            // 1. The Shaft
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

            // 2. The Collar
            Container(
              width: 16,
              height: 56,
              decoration: BoxDecoration(
                color: collarColor,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.black26, width: 1),
              ),
            ),

            // 3 & 4. Dynamic Plates & Sleeve (Wrapped in a scroller for safety)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    // Maps over the calculated plates!
                    ...plateProvider.loadedPlates.map((plate) => _buildPlate(plate.color, plate.height, plate.width)),

                    // The Sleeve (Fills the rest of the space)
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
