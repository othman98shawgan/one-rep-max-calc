import 'package:flutter/material.dart';
import 'package:one_rep_max_calc/service/formula_service.dart';
import 'package:one_rep_max_calc/service/theme_service.dart';
import 'package:one_rep_max_calc/service/unit_service.dart';
import 'package:provider/provider.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:wakelock/wakelock.dart';

import '../service/utils.dart';
import '../service/round_to_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController weight = TextEditingController(text: "");
  final TextEditingController reps = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  String res = "1RM";

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double height = MediaQuery.of(context).size.height;

    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;

    // Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;

    var flexSpaceSides = 2;
    var flexSpacebetween = 1;
    var flexTextFeild = 3;

    return Consumer5<ThemeNotifier, RoundNotifier, RoundValueNotifier, UnitNotifier,
            FormulaNotifier>(
        builder: (context, theme, roundWeightStatus, roundWeightValue, unitProvider,
                formulaProvider, child) =>
            Center(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text(widget.title),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: 'Settings',
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings').then((value) {
                          setState(() {
                            res = '1RM';
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                        weight.clear();
                        reps.clear();
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min, //So elements be in Center
                      children: [
                        SizedBox(height: height3 * 0.15),
                        Row(
                          children: [
                            Expanded(flex: flexSpaceSides, child: const SizedBox()),
                            Expanded(
                              flex: flexTextFeild,
                              child: SizedBox(
                                height: 80,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  validator: weightValidator,
                                  controller: weight,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    hintText: "Weight",
                                    border: OutlineInputBorder(),
                                    errorStyle: TextStyle(height: 0.5),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(flex: flexSpacebetween, child: const SizedBox()),
                            Expanded(
                              flex: flexTextFeild,
                              child: SizedBox(
                                height: 80,
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  validator: repsValidator,
                                  controller: reps,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    hintText: "Reps",
                                    border: OutlineInputBorder(),
                                    errorStyle: TextStyle(
                                      height: 0.5,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(flex: flexSpaceSides, child: const SizedBox()),
                          ],
                        ),
                        SizedBox(height: height3 * 0.05),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                var weightValue = int.parse(weight.text);
                                var repsValue = int.parse(reps.text);
                                if (repsValue > 6) {
                                  const textSnackbar = SnackBar(
                                    content:
                                        Text("Calculations are more accurate in 1-6 rep range"),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(textSnackbar);
                                }

                                double max = maxCalc(weightValue, repsValue);

                                if (roundWeightStatus.getRoundStatus()) {
                                  var roundValue = roundWeightValue.getRoundValue();
                                  max = roundToNearest(max, roundValue);
                                }

                                var maxString = max.toString();
                                var maxStringNum = maxString.split('.')[0];
                                var maxStringFractions = maxString.split('.')[1].substring(0, 1);
                                res = '$maxStringNum.$maxStringFractions';
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Calculate',
                                  style: TextStyle(
                                    fontSize: 24,
                                  )),
                            )),
                        SizedBox(height: height3 * 0.075),
                        Text(
                          res == '1RM' ? res : '$res ${unitProvider.unit}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 48),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  double maxCalc(int weightValue, int repsValue) {
    return weightValue / (1.0278 - (0.0278 * repsValue));
  }

  String? weightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Missing value';
    }
    return null;
  }

  String? repsValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Missing value';
    }
    return null;
  }

  double roundToNearest(double num, double roundFactor) {
    var roundTo = 1 / roundFactor;
    var val = (num * roundTo).round() / roundTo;
    return val;
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate().then((_) {
          InAppUpdate.completeFlexibleUpdate().then((_) {
            printSnackBar("Success!", context);
          }).catchError((e) {
            printSnackBar(e.toString(), context);
          });
        }).catchError((e) {
          printSnackBar(e.toString(), context);
        });
      }
    }).catchError((e) {
      printSnackBar(e.toString(), context);
    });
  }
}
