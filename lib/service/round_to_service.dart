import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/service/unit_service.dart';
import 'package:provider/provider.dart';

import 'store_manager.dart';

class RoundNotifier with ChangeNotifier {
  bool _roundStatus = false;
  bool getRoundStatus() => _roundStatus;

  RoundNotifier() {
    StorageManager.readData('roundStatus').then((value) {
      _roundStatus = value ?? false;
      notifyListeners();
    });
  }

  void setStatus(bool status) async {
    _roundStatus = status;
    StorageManager.saveData('roundStatus', status);
    notifyListeners();
  }
}

class RoundValueNotifier with ChangeNotifier {
  double _roundValue = 5.0;

  double getRoundValue() => _roundValue;

  RoundValueNotifier() {
    StorageManager.readData('roundValue').then((value) {
      _roundValue = value ?? 2.5;
      notifyListeners();
    });
  }

  void setValue(double value) async {
    _roundValue = value;
    StorageManager.saveData('roundValue', value);
    notifyListeners();
  }

  void convertToKgs() async {
    _roundValue /= 2;
    StorageManager.saveData('roundValue', _roundValue);
    notifyListeners();
  }

  void convertToLbs() async {
    _roundValue *= 2;
    StorageManager.saveData('roundValue', _roundValue);
    notifyListeners();
  }
}

showRoundToDialog(BuildContext context, double roundValue) async {
  var currentRoundValue = roundValue;
  var isKg = Provider.of<UnitNotifier>(context, listen: false).unit == 'KGS';

  var confirmMethod = (() {
    Navigator.pop(context);
    Provider.of<RoundValueNotifier>(context, listen: false).setValue(currentRoundValue);
  });

  AlertDialog alert = AlertDialog(
      title: const Text("Round Weights to"),
      contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
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
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  title: isKg ? const Text('2.5 KG') : const Text('5.0 LBS'),
                  value: isKg ? 2.5 : 5.0,
                  groupValue: currentRoundValue,
                  onChanged: (double? value) {
                    setState(() {
                      currentRoundValue = value ?? 0;
                    });
                  },
                ),
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  title: isKg ? const Text('5.0 KG') : const Text('10.0 LBS'),
                  value: isKg ? 5.0 : 10.0,
                  groupValue: currentRoundValue,
                  onChanged: (double? value) {
                    setState(() {
                      currentRoundValue = value ?? 0;
                    });
                  },
                ),
              ],
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
