import 'package:flutter/material.dart';

import '../utils/navigation_key.dart';

class AmityDialog {
  Future<void> showAlertErrorDialog(
      {required String title, required String message}) async {
    bool isbarrierDismissible() {
      if (title.toLowerCase().contains("error")) {
        return true;
      } else {
        return false;
      }
    }

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
