import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserVM extends ChangeNotifier {
  List<AmityUser> _userList = [];
  List<String> selectedUserList = [];
  String accessToken = "";
  List<AmityUser> getUserList() {
    return _userList;
  }

  void clearSelectedUser() {
    selectedUserList.clear();
    notifyListeners();
  }

  Future<String> generateAccessToken() async {
    var dio = Dio();
    final response = await dio.post(
      "https://api.${dotenv.env["REGION"]}.amity.co/api/v3/sessions",
      data: {
        'userId': AmityCoreClient.getUserId(),
        'deviceId': AmityCoreClient.getUserId()
      },
      options: Options(
        headers: {
          "x-api-key":
              dotenv.env["API_KEY"] // set content-length
        },
      ),
    );
    if (response.statusCode == 200) {
      return response.data["accessToken"];
    } else {
      return "";
    }
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
