import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/calculator_provider.dart';
import '../../service/formula_service.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
    final formulaProvider = Provider.of<FormulaNotifier>(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
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
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            calculatorProvider.estimatedMax == '1RM' ? '0' : calculatorProvider.estimatedMax,
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Using ${formulaNames[formulaProvider.formula]} formula',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
