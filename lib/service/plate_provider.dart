import 'package:flutter/material.dart';

// The blueprint for a physical plate
class Plate {
  final double weightKgs;
  final double weightLbs;
  final Color color;
  final double height;
  final double width;

  const Plate(this.weightKgs, this.weightLbs, this.color, this.height, this.width);
}

class PlateProvider with ChangeNotifier {
  // Standard Olympic/Powerlifting specs using your exact UI dimensions
  final List<Plate> _standardPlates = const [
    Plate(25.0, 55.0, Colors.red, 140, 20),
    Plate(20.0, 45.0, Colors.blue, 130, 18),
    Plate(15.0, 35.0, Colors.yellow, 120, 16),
    Plate(10.0, 25.0, Colors.green, 110, 14),
    Plate(5.0, 10.0, Colors.white, 100, 12),
    Plate(2.5, 5.0, Color(0xFF18181B), 80, 10), // Black
    Plate(1.25, 2.5, Color(0xFF9E9E9E), 60, 8), // Silver (fractional)
  ];

  List<Plate> _loadedPlates = [];
  List<Plate> get loadedPlates => _loadedPlates;

  // Defaults to a standard 20kg / 45lb bar
  double get barWeightKgs => 20.0;
  double get barWeightLbs => 45.0;

  void calculatePlates(double totalWeight, String unit) {
    _loadedPlates.clear();

    double barWeight = unit == 'KGS' ? barWeightKgs : barWeightLbs;
    double weightPerSide = (totalWeight - barWeight) / 2.0;

    if (weightPerSide <= 0) {
      notifyListeners();
      return; // Just the empty bar
    }

    // Greedy algorithm: Try to fit the heaviest plates first
    for (var plate in _standardPlates) {
      double plateWeight = unit == 'KGS' ? plate.weightKgs : plate.weightLbs;

      // Keep adding this specific plate as long as it fits
      while (weightPerSide >= plateWeight) {
        _loadedPlates.add(plate);
        // Using a tiny tolerance (0.001) to avoid floating point math rounding errors
        weightPerSide = (weightPerSide - plateWeight) + 0.001;
      }
    }
    notifyListeners();
  }

  void reset() {
    _loadedPlates.clear();
    notifyListeners();
  }
}
