import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store_manager.dart';

class FormulaNotifier with ChangeNotifier {
  Formula? _formula;
  Formula? get formula => _formula;

  FormulaNotifier() {
    StorageManager.readData('Formula').then((value) {
      _formula = formulaFromString(value);
      notifyListeners();
    });
  }

  FormulaNotifier.fromFormula(Formula formula) {
    _formula = formula;
    notifyListeners();
  }

  void setFormula(Formula newFormula) async {
    _formula = newFormula;
    StorageManager.saveData('Formula', newFormula.toString());
    notifyListeners();
  }

  Formula formulaFromString(String? key) {
    return Formula.values.firstWhere(
      (v) => v.toString().split('.')[1] == key,
      orElse: () => Formula.brzycki,
    );
  }
}

enum Formula { brzycki, epley, lander, lombardi }

const formulaNames = {
  Formula.brzycki: 'Brzycki',
  Formula.epley: 'Epley',
  Formula.lander: 'Lander',
  Formula.lombardi: 'Lombardi',
};

const formulaDescription = {
  Formula.brzycki: 'weight × (36 / (37 - reps))',
  Formula.epley: 'weight × (1 + 0.0333 × reps)',
  Formula.lander: '(100 × weight) / (101.3 - 2.67123 × reps)',
  Formula.lombardi: 'weight × reps ^ 0.1',
};

double calculate1RM(double weight, int reps, Formula formula) {
  switch (formula) {
    case Formula.brzycki:
      return weight * (36 / (37 - reps));
    case Formula.epley:
      return weight * (1 + (0.0333 * reps));
    case Formula.lander:
      return (100 * weight) / (101.3 - (2.67123 * reps));
    case Formula.lombardi:
      return weight * pow(reps, 0.1);
  }
}

showFormulaDialog(BuildContext context, Formula formula) async {
  Formula? currentFormula = formula;

  var confirmMethod = (() async {
    Navigator.pop(context);
    Provider.of<FormulaNotifier>(context, listen: false).setFormula(currentFormula!);
  });

  AlertDialog alert = AlertDialog(
      title: const Text('Calculation formula'),
      contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 16.0),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: confirmMethod,
          child: const Text('Confirm'),
        ),
      ],
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: FormulaRadioListTileBuilder().buildListTiles(
                context: context,
                values: Formula.values,
                groupValue: currentFormula,
                onChanged: (val) {
                  setState(() {
                    currentFormula = val;
                  });
                },
              ),
            ),
          ),
        ]);
      }));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class FormulaRadioListTileBuilder {
  List<RadioListTile> buildListTiles({
    required BuildContext context,
    required List<Formula> values,
    required Formula? groupValue,
    required ValueChanged<Formula?>? onChanged,
  }) {
    return values.map((value) {
      String title = formulaNames[value]!;
      if (value == Formula.brzycki) {
        title += ' (Most popular)';
      }
      return RadioListTile<Formula>(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        value: value,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.info),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.only(top: 24),
                        title: Text(formulaNames[value]!),
                        content: Text(
                          '1RM = ${formulaDescription[value]!}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 1.5),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
        groupValue: groupValue,
        onChanged: onChanged,
      );
    }).toList();
  }
}
