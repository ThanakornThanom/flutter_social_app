import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class AmityVM extends ChangeNotifier {
  Future<void> login(String userID) async {
    log("login with $userID");
    await AmityCoreClient.login(userID).submit().then((value) async {
      log("success");
      await getUserByID(userID);
    }).catchError((error, stackTrace) {
      throw error.toString();
    });
  }

  Future<void> getUserByID(String id) async {
    await AmityCoreClient.newUserRepository().getUser(id).then((user) {
      log("IsGlobalban: ${user.isGlobalBan}");
    }).onError((error, stackTrace) {
      log(error.toString());
    });
  }
}
