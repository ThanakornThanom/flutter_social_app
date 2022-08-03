import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class FeedVM extends ChangeNotifier {
  var _amityGlobalFeedPosts = <AmityPost>[];
  var _amityImagePosts = <AmityPost>[];
  late PagingController<AmityPost> _controller;
  List<AmityPost> getAmityPosts() {
    return _amityGlobalFeedPosts;
  }

  void initAmityGlobalfeed() async {
    log("initAmityGlobalfeed");
    //inititate the PagingController
    await AmitySocialClient.newFeedRepository()
        .getGlobalFeed()
        .getPagingData()
        .then((value) {
      _amityGlobalFeedPosts = value.data;
    });
    notifyListeners();
  }
}
