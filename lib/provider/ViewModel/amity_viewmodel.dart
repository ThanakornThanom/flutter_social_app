import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class AmityVM extends ChangeNotifier {
  Future<void> login(String userID) async {
    log("login with $userID");
    await AmityCoreClient.login(userID)
        .displayName(userID)
        .submit()
        .then((value) {
      log("success");
    }).catchError((error, stackTrace) {
      throw error.toString();
    });
  }
}
