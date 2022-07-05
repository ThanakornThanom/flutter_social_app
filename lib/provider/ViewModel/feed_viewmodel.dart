import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class FeedVM extends ChangeNotifier {
  var _amityGlobalFeedPosts = <AmityPost>[];
  late PagingController<AmityPost> _controller;
  List<AmityPost> getAmityPosts() {
    return _amityGlobalFeedPosts;
  }

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

  void initAmityGlobalfeed() async {
    log("initAmityGlobalfeed");
    //inititate the PagingController
    await AmitySocialClient.newFeedRepository()
        .getGlobalFeed()
        .getPagingData()
        .then((value) {
      _amityGlobalFeedPosts = value.item1;
    });
    // _controller = await PagingController(
    //   pageFuture: (token) => AmitySocialClient.newFeedRepository()
    //       .getGlobalFeed()
    //       .getPagingData(token: token, limit: 20),
    //   pageSize: 20,
    // )
    //   ..addListener(
    //     () {
    //       if (_controller.error == null) {
    //         log("success");
    //         //handle results, we suggest to clear the previous items
    //         //and add with the latest _controller.loadedItems
    //         _amityGlobalFeedPosts.clear();
    //         _amityGlobalFeedPosts.addAll(_controller.loadedItems);
    //         //update widgets

    //       } else {
    //         log("error");
    //         //error on pagination controller
    //         //update widgets
    //       }
    //     },
    //   );
    notifyListeners();
  }
}
