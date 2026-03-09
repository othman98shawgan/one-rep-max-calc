import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:one_rep_max_calc/service/formula_service.dart';
import 'package:one_rep_max_calc/service/theme_service.dart';
import 'package:one_rep_max_calc/service/unit_service.dart';
import 'package:provider/provider.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../service/calculator_provider.dart';
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
  final InAppReview inAppReview = InAppReview.instance;
  String res = "1RM";

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    if (!kDebugMode) {
      checkForUpdate();
      checkForReview();
    }
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

    return Consumer6<ThemeNotifier, RoundNotifier, RoundValueNotifier, UnitNotifier, FormulaNotifier,
            CalculatorProvider>(
        builder: (context, theme, roundWeightStatus, roundWeightValue, unitProvider, formulaProvider,
                calculatorProvider, child) =>
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
                          calculatorProvider.reset();
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
                                var weightValue = double.parse(weight.text);
                                var repsValue = int.parse(reps.text);

                                // Keep the UI logic (SnackBar) in the UI
                                if (repsValue > 6) {
                                  printSnackBar("Calculations are more accurate in 1-6 rep range", context);
                                }

                                // Send the math to the logic layer
                                Provider.of<CalculatorProvider>(context, listen: false).calculate(
                                    weightValue,
                                    repsValue,
                                    formulaProvider.formula!,
                                    roundWeightStatus.getRoundStatus(),
                                    roundWeightValue.getRoundValue());
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
                          calculatorProvider.estimatedMax == '1RM'
                              ? calculatorProvider.estimatedMax
                              : '${calculatorProvider.estimatedMax} ${unitProvider.unit}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 48),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
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

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate().then((_) {
          InAppUpdate.completeFlexibleUpdate().then((_) {
            if (kDebugMode) {
              printSnackBar("Success!", context);
            }
          }).catchError((e) {
            if (kDebugMode) {
              printSnackBar(e.toString(), context);
            }
          });
        }).catchError((e) {
          if (kDebugMode) {
            printSnackBar(e.toString(), context);
          }
        });
      }
    }).catchError((e) {
      if (kDebugMode) {
        printSnackBar(e.toString(), context);
      }
    });
  }

  Future<void> checkForReview() async {
    inAppReview.isAvailable().then((isAvailable) {
      if (isAvailable) {
        inAppReview.requestReview();
      }
    });
  }
}
