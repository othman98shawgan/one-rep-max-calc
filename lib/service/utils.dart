import 'package:flutter/material.dart';

void printSnackBar(String message, BuildContext context, {int durationInSeconds = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: durationInSeconds),
  ));
}
