import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store_manager.dart';

class UnitNotifier with ChangeNotifier {
  String _unit = 'KGS';
  String get unit => _unit;

  String _unitDesc = 'KGS - Kilograms';
  String get unitDesc => _unitDesc;

  UnitNotifier() {
    StorageManager.readData('Unit').then((value) {
      _unit = value ?? 'KGS';
      _unitDesc = _unit == 'KGS' ? 'KGS - Kilograms' : 'LBS - Pounds';
      notifyListeners();
    });
  }

  void setKGS() async {
    _unit = 'KGS';
    _unitDesc = 'KGS - Kilograms';
    StorageManager.saveData('Unit', 'KGS');
    notifyListeners();
  }

  void setLBS() async {
    _unit = 'LBS';
    _unitDesc = 'LBS - Pounds';
    StorageManager.saveData('Unit', 'LBS');
    notifyListeners();
  }
}

showUnitDialog(BuildContext context, String unit) async {
  String? currentUnit = unit;

  var confirmMethod = (() async {
    Navigator.pop(context);
    if (currentUnit == 'KGS') {
      Provider.of<UnitNotifier>(context, listen: false).setKGS();
    } else {
      Provider.of<UnitNotifier>(context, listen: false).setLBS();
    }
  });

  AlertDialog alert = AlertDialog(
      title: const Text('Unit System'),
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
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    value: 'KGS',
                    title: const Text('KGS - Kilogram'),
                    groupValue: currentUnit,
                    onChanged: (val) {
                      setState(() {
                        currentUnit = val;
                      });
                    }),
                RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    value: 'LBS',
                    title: const Text('LBS - Pounds'),
                    groupValue: currentUnit,
                    onChanged: (val) {
                      setState(() {
                        currentUnit = val;
                      });
                    }),
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
