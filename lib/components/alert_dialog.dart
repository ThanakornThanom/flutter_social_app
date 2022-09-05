import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/navigation_key.dart';

class AmityDialog {
  var isshowDialog = kDebugMode;

  Future<void> showAlertErrorDialog(
      {required String title, required String message}) async {
    await FirebaseCrashlytics.instance
        .recordError(title, StackTrace.current, reason: message);

    bool isbarrierDismissible() {
      if (title.toLowerCase().contains("error")) {
        return true;
      } else {
        return false;
      }
    }

    if (isshowDialog) {
      await showDialog(
        barrierDismissible: isbarrierDismissible(),
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }
}
