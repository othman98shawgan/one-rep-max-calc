import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/service/formula_service.dart';

class CalculatorProvider with ChangeNotifier {
  String _estimatedMax = "1RM";
  String get estimatedMax => _estimatedMax;

  void calculate(double weight, int reps, Formula formula, bool shouldRound, double roundValue) {
    // Calls the base math from your formula_service.dart
    double max = calculate1RM(weight, reps, formula);

    // Logic extracted from home_page.dart
    if (shouldRound) {
      max = _roundToNearest(max, roundValue);
    }

    // String formatting extracted from home_page.dart
    var maxString = max.toString();
    var maxStringNum = maxString.split('.')[0];
    var maxStringFractions = maxString.split('.')[1].substring(0, 1);

    _estimatedMax = '$maxStringNum.$maxStringFractions';
    notifyListeners();
  }

  void reset() {
    _estimatedMax = "1RM";
    notifyListeners();
  }

  // Helper pulled directly out of home_page.dart
  double _roundToNearest(double num, double roundFactor) {
    var roundTo = 1 / roundFactor;
    return (num * roundTo).round() / roundTo;
  }
}
