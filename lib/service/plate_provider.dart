import 'package:flutter/material.dart';
import 'store_manager.dart';

class Plate {
  final double weightKgs;
  final double weightLbs;
  final Color color;
  final double height;
  final double width;
  int availablePairs;

  Plate(this.weightKgs, this.weightLbs, this.color, this.height, this.width, {this.availablePairs = 4});
}

class PlateProvider with ChangeNotifier {
  final List<Plate> inventory = [
    Plate(25.0, 55.0, Colors.red, 140, 20, availablePairs: 4),
    Plate(20.0, 45.0, Colors.blue, 130, 18, availablePairs: 4),
    Plate(15.0, 35.0, Colors.yellow, 120, 16, availablePairs: 2),
    Plate(10.0, 25.0, Colors.green, 110, 14, availablePairs: 2),
    Plate(5.0, 10.0, Colors.white, 100, 12, availablePairs: 2),
    Plate(2.5, 5.0, const Color(0xFF18181B), 80, 10, availablePairs: 2),
    Plate(1.25, 2.5, const Color(0xFF9E9E9E), 60, 8, availablePairs: 2),
  ];

  List<Plate> _loadedPlates = [];
  List<Plate> get loadedPlates => _loadedPlates;

  double _barWeightKgs = 20.0;
  double _barWeightLbs = 45.0;

  double get barWeightKgs => _barWeightKgs;
  double get barWeightLbs => _barWeightLbs;
  bool get isStandardBar => _barWeightKgs == 20.0;

  double _missingWeight = 0.0;
  double get missingWeight => _missingWeight;
  bool get hasMissingPlates => _missingWeight > 0.1;

  // --- NEW: THE BOOT SEQUENCE ---
  PlateProvider() {
    _loadInventoryFromStorage();
  }

  Future<void> _loadInventoryFromStorage() async {
    // 1. Fetch the barbell preference
    var savedBar = await StorageManager.readData('is_standard_bar');
    if (savedBar is bool) {
      _barWeightKgs = savedBar ? 20.0 : 15.0;
      _barWeightLbs = savedBar ? 45.0 : 35.0;
    }

    // 2. Fetch the plate pairs dynamically using their KG weight as the key
    for (var plate in inventory) {
      var savedPairs = await StorageManager.readData('plate_${plate.weightKgs}_pairs');
      if (savedPairs is int) {
        plate.availablePairs = savedPairs;
      }
    }
    notifyListeners();
  }

  // --- NEW: THE SAVE TRIGGERS ---
  void toggleBarWeight(bool isStandard) {
    _barWeightKgs = isStandard ? 20.0 : 15.0;
    _barWeightLbs = isStandard ? 45.0 : 35.0;

    // Save to disk instantly
    StorageManager.saveData('is_standard_bar', isStandard);
    notifyListeners();
  }

  void updatePlateInventory(int index, int newPairs) {
    inventory[index].availablePairs = newPairs;

    // Save to disk instantly using the plate's weight as a unique key
    StorageManager.saveData('plate_${inventory[index].weightKgs}_pairs', newPairs);
    notifyListeners();
  }

  // --- THE CALCULATOR ALGORITHM (Unchanged) ---
  void calculatePlates(double totalWeight, String unit) {
    _loadedPlates.clear();
    _missingWeight = 0.0;

    double barWeight = unit == 'KGS' ? _barWeightKgs : _barWeightLbs;
    double weightPerSide = (totalWeight - barWeight) / 2.0;

    if (weightPerSide <= 0) {
      if (totalWeight > 0 && totalWeight < barWeight) {
        _missingWeight = barWeight - totalWeight;
      }
      notifyListeners();
      return;
    }

    double remainingWeightPerSide = weightPerSide;

    for (var plate in inventory) {
      double plateWeight = unit == 'KGS' ? plate.weightKgs : plate.weightLbs;
      int pairsUsed = 0;

      while (remainingWeightPerSide >= plateWeight && pairsUsed < plate.availablePairs) {
        _loadedPlates.add(plate);
        remainingWeightPerSide = (remainingWeightPerSide - plateWeight) + 0.001;
        pairsUsed++;
      }
    }

    if (remainingWeightPerSide > 0.01) {
      _missingWeight = remainingWeightPerSide * 2.0;
    }

    notifyListeners();
  }

  void reset() {
    _loadedPlates.clear();
    _missingWeight = 0.0;
    notifyListeners();
  }
}
