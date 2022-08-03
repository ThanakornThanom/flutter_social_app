import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class UserFeedVM extends ChangeNotifier {
  late AmityUser amityUser;

  late PagingController<AmityPost> _controller;
  final amityPosts = <AmityPost>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  void getUser(AmityUser user) {
    if (user == AmityCoreClient.getUserId()) {
      amityUser = AmityCoreClient.getCurrentUser();
    } else {
      amityUser = user;
    }
  }

  void listenForUserFeed(String userId) {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newFeedRepository()
          .getUserFeed(userId)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_controller.error == null) {
            amityPosts.clear();
            amityPosts.addAll(_controller.loadedItems);

            notifyListeners();
          } else {
            //Error on pagination controller

            print("error");
          }
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.fetchNextPage();
    });

    scrollcontroller.addListener(loadnextpage);
  }

  void loadnextpage() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _controller.hasMoreItems) {
      _controller.fetchNextPage();
    }
  }
}
