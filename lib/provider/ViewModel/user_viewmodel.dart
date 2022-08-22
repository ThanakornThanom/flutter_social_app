import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class UserVM extends ChangeNotifier {
  List<AmityUser> _userList = [];
  List<String> selectedUserList = [];
  List<AmityUser> getUserList() {
    return _userList;
  }

  void clearSelectedUser() {
    selectedUserList.clear();
    notifyListeners();
  }

  Future<AmityUser?> getUserByID(String id) async {
    await AmityCoreClient.newUserRepository().getUser(id).then((user) {
      log("IsGlobalban: ${user.isGlobalBan}");
      return user;
    }).onError((error, stackTrace) {
      log(error.toString());
      return AmityUser();
    });
  }

  void setSelectedUserList(String id) {
    if (selectedUserList.length > 0 && selectedUserList.contains(id)) {
      selectedUserList.remove(id);
    } else {
      selectedUserList.add(id);
    }
    notifyListeners();
  }

  bool checkIfSelected(String id) {
    return selectedUserList.contains(id);
  }

  Future<void> getUsers() async {
    AmityCoreClient.newUserRepository()
        .getUsers()
        .sortBy(AmityUserSortOption.DISPLAY)
        .query()
        .then((users) async {
      _userList.clear();
      _userList.addAll(users);
      notifyListeners();
    }).catchError((error, stackTrace) {
      print(error.toString());
      notifyListeners();
    });
  }
}
