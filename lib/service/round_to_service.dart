import 'package:flutter/material.dart';
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
}

showRoundToDialog(BuildContext context, double roundValue) async {
  var currentRoundValue = roundValue;

  var confirmMethod = (() {
    Navigator.pop(context);
    Provider.of<RoundValueNotifier>(context, listen: false).setValue(currentRoundValue);
  });

  AlertDialog alert = AlertDialog(
      title: const Text("Round Weights to"),
      // titlePadding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0),
      contentPadding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 24.0),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: confirmMethod,
          child: const Text('Confirm'),
        ),
      ],
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        // currentRoundValue = RoundNotifier().getRoundValue();
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('0 KG'),
                  value: 0.0,
                  groupValue: currentRoundValue,
                  onChanged: (double? value) {
                    setState(() {
                      currentRoundValue = value ?? 0;
                    });
                  },
                ),
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('2.5 KG'),
                  value: 2.5,
                  groupValue: currentRoundValue,
                  onChanged: (double? value) {
                    setState(() {
                      currentRoundValue = value ?? 0;
                    });
                  },
                ),
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('5.0 KG'),
                  value: 5.0,
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
