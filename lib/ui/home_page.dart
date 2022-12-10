import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;

    // Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;
    var flexSpaceSides = 2;
    var flexSpacebetween = 1;
    var flexTextFeild = 3;
    return Consumer2<RoundNotifier, RoundValueNotifier>(
        builder: (context, roundWeightStatus, roundWeightValue, _) => Center(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  title: Text(widget.title),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: 'Settings',
                      onPressed: () {
                        weight.clear();
                        reps.clear();
                        res = '1RM';
                        Navigator.pushNamed(context, '/settings');
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Row(
                          children: [
                            Expanded(flex: flexSpaceSides, child: const SizedBox()),
                            Expanded(
                              flex: flexTextFeild,
                              child: SizedBox(
                                width: width * 0.3,
                                height: 80,
                                child: TextFormField(
                                  validator: weightValidator,
                                  controller: weight,
                                  obscureText: false,
                                  decoration: const InputDecoration(
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
                                width: width * 0.3,
                                height: 80,
                                child: TextFormField(
                                  validator: repsValidator,
                                  controller: reps,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    hintText: "Reps",
                                    border: OutlineInputBorder(),
                                    errorStyle: TextStyle(height: 0.5),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(flex: flexSpaceSides, child: const SizedBox()),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              var weightValue = int.parse(weight.text);
                              var repsValue = int.parse(reps.text);
                              if (repsValue > 6) {
                                const textSnackbar = SnackBar(
                                  content: Text("Calculations are more accurate in 1-6 rep range"),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(textSnackbar);
                              }

                              double max = weightValue / (1.0278 - (0.0278 * repsValue));
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                          ),
                          elevation: 5.0,
                          child: const Text('Calculate',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ),
                        SizedBox(height: 30),
                        Text(res == '1RM' ? res : '$res KG',
                            style: const TextStyle(
                              fontSize: 48,
                            )),
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

  double roundToNearest(double num, double roundFactor) {
    var roundTo = 1 / roundFactor;
    var val = (num * roundTo).round() / roundTo;
    return val;
  }
}
