import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'utils.dart';

class AppServices {
  static Future<void> initializeAppServices(BuildContext context) async {
    WakelockPlus.enable();
    if (!kDebugMode) {
      _checkForUpdate(context);
      _checkForReview();
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

  static Future<void> _checkForReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
