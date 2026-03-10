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
    return Consumer5<ThemeNotifier, RoundNotifier, RoundValueNotifier, UnitNotifier, FormulaNotifier>(
      builder: (context, theme, roundWeightStatus, roundWeightValue, unitProvider, formulaProvider, child) {
        final calculatorProvider = Provider.of<CalculatorProvider>(context);

        // Exact Hex Colors from your Stitch HTML
        const Color appBarColor = Color(0xFF2C363F);
        const Color scaffoldColor = Color(0xFFD6DBD2);
        const Color m3SurfaceColor = Color(0xFFF7F9F2);
        const Color inputBottomBorder = Color(0xFF4A5568);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: appBarColor,
            foregroundColor: Colors.white,
            elevation: 4, // Shadow-md
            title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0), // py-10 px-6
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- THE INPUTS (Labels Above) ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Weight (${unitProvider.unit.toLowerCase()})",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: weight,
                                validator: weightValidator,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: "0",
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface, // bg-black/5
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // h-14 px-4
                                  enabledBorder: const UnderlineInputBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                    borderSide: BorderSide(color: inputBottomBorder, width: 2),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                    borderSide: BorderSide(color: appBarColor, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16), // gap-4
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Reps",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: reps,
                                validator: repsValidator,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  hintText: "0",
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surface,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                    borderSide: BorderSide(color: inputBottomBorder, width: 2),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                    borderSide: BorderSide(color: appBarColor, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // --- THE BUTTON ---
                    SizedBox(
                      width: 320, // max-w-xs
                      height: 56, // h-14
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          elevation: 8, // shadow-lg
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)), // rounded-full
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            var weightValue = double.parse(weight.text);
                            var repsValue = int.parse(reps.text);

                            if (repsValue > 6) {
                              printSnackBar("Calculations are more accurate in 1-6 rep range", context);
                            }

                            calculatorProvider.calculate(weightValue, repsValue, formulaProvider.formula!,
                                roundWeightStatus.getRoundStatus(), roundWeightValue.getRoundValue());
                          }
                        },
                        child: const Text('Calculate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24), // mt-4 approx

                    // --- THE RESULT CARD ---
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 200), // min-h-[200px]
                      padding: const EdgeInsets.all(32), // p-8
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24), // rounded-3xl
                        border: Border.all(color: Colors.grey.shade200), // border border-gray-200
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1)) // shadow-sm
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ESTIMATED 1RM',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2.0, // tracking-widest
                            ),
                          ),
                          const SizedBox(height: 8), // mb-2
                          Text(
                            calculatorProvider.estimatedMax == '1RM' ? '0' : calculatorProvider.estimatedMax,
                            style: TextStyle(
                              fontSize: 72, // text-7xl
                              fontWeight: FontWeight.w900, // font-black
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8), // mt-2
                          Text(
                            'Using ${formulaNames[formulaProvider.formula]} formula',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
