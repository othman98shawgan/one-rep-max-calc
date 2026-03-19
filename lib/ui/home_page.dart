import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/calculator_provider.dart';
import '../service/formula_service.dart';
import '../service/plate_provider.dart';
import '../service/round_to_service.dart';
import '../service/unit_service.dart';
import '../service/utils.dart';
import '../service/app_services.dart';
import 'widgets/barbell_visualizer.dart';
import 'widgets/result_card.dart';

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

  @override
  void initState() {
    super.initState();
    // All that messy store logic is now a single, clean line.
    AppServices.initializeAppServices(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<RoundNotifier, RoundValueNotifier, UnitNotifier>(
      builder: (context, roundWeightStatus, roundWeightValue, unitProvider, child) {
        final calculatorProvider = Provider.of<CalculatorProvider>(context, listen: false);
        final formulaProvider = Provider.of<FormulaNotifier>(context, listen: false);
        final plateProvider = Provider.of<PlateProvider>(context, listen: false);

        return Scaffold(
          resizeToAvoidBottomInset: false, // Prevents keyboard from crushing the UI
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: const Color(0xFF2C363F),
            foregroundColor: Colors.white,
            elevation: 4,
            title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings').then((_) {
                    calculatorProvider.reset();
                    plateProvider.reset();
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                  weight.clear();
                  reps.clear();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- THE INPUTS ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInputField(
                            controller: weight,
                            label: "Weight (${unitProvider.unit.toLowerCase()})",
                            validator: (v) => v == null || v.isEmpty ? 'Missing value' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(
                            controller: reps,
                            label: "Reps",
                            validator: (v) => v == null || v.isEmpty ? 'Missing value' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // --- THE BUTTON ---
                    SizedBox(
                      width: 320,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          elevation: 8,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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

                            double finalMax = double.parse(calculatorProvider.estimatedMax);
                            plateProvider.calculatePlates(finalMax, unitProvider.unit);
                          }
                        },
                        child: const Text('Calculate', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const ResultCard(),
                    const SizedBox(height: 32),
                    const BarbellVisualizer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // A clean helper method for the repetitive TextFormField code
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: validator,
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
              borderSide: BorderSide(color: Color(0xFF4A5568), width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              borderSide: BorderSide(color: Color(0xFF2C363F), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
