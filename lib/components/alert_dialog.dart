import 'package:flutter/material.dart';

import '../utils/navigation_key.dart';

class AmityDialog {
  Future<void> showAlertErrorDialog(
      {required String title, required String message}) async {
    await showDialog(
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
