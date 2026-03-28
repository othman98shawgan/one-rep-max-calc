import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'store_manager.dart';
import 'utils.dart';

class AppServices {
  static Future<void> initializeAppServices(BuildContext context) async {
    WakelockPlus.enable();
    if (!kDebugMode) {
      _checkForUpdate(context);
    }
  }

  static Future<void> _checkForUpdate(BuildContext context) async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
        if (kDebugMode) printSnackBar("Success!", context);
      }
    } catch (e) {
      if (kDebugMode) printSnackBar(e.toString(), context);
    }
  }

  static Future<void> checkForReview() async {
    const String calcCountKey = 'calculation_count_for_review';
    int calcCount = await StorageManager.readData(calcCountKey) ?? 0;

    calcCount++;
    StorageManager.saveData(calcCountKey, calcCount);

    // Prompt at 3, 15, and then every 30 calculations
    if (calcCount == 3 || calcCount == 15 || (calcCount > 15 && calcCount % 30 == 0)) {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }
}
