import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../components/alert_dialog.dart';
import '../../repository/chat_repo_imp.dart';

class UserVM extends ChangeNotifier {
  List<AmityUser> _userList = [];
  List<String> selectedUserList = [];
  AmityChatRepoImp channelRepoImp = AmityChatRepoImp();
  String accessToken = "";
  List<AmityUser> getUserList() {
    return _userList;
  }

  void clearSelectedUser() {
    selectedUserList.clear();
    notifyListeners();
  }

  // Future<void> searchUser(String keyword) async {
  //   AmityCoreClient.newUserRepository()
  //       .searchUserByDisplayName(keyword)
  //       .keyword(keyword)
  //       .query()
  //       .then((value) {
  //     print("get new user value ${value}");
  //     _userList.clear();
  //     _userList.addAll(value);
  //     notifyListeners();
  //   });

  // }

  Future<String> initAccessToken() async {
    var dio = Dio();
    final response = await dio.post(
      "https://api.${dotenv.env["REGION"]}.amity.co/api/v3/sessions",
      data: {
        'userId': AmityCoreClient.getUserId(),
        'deviceId': AmityCoreClient.getUserId()
      },
      options: Options(
        headers: {
          "x-api-key": dotenv.env["API_KEY"] // set content-length
        },
      ),
    );
    if (response.statusCode == 200) {
      accessToken = response.data["accessToken"];
      return accessToken;
    } else {
      return "error :initAccessToken";
    }
  }

  Future<AmityUser?> getUserByID(String id) async {
    await AmityCoreClient.newUserRepository().getUser(id).then((user) {
      log("IsGlobalban: ${user.isGlobalBan}");
      return user;
    }).onError((error, stackTrace) async {
      log(error.toString());
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
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

  Future<void> searchUser(String keyword, String accessToken) async {
    await channelRepoImp.searchUser(keyword, callback: (data, error) {
      if (data != null) {
        _userList.clear();
        _userList.addAll(data);
        print("check user list ${data} ==== ${_userList}");
        notifyListeners();
      } else {}
    }, accessToken: accessToken);
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
    }).catchError((error, stackTrace) async {
      log(error.toString());
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
      notifyListeners();
    });
  }
}
