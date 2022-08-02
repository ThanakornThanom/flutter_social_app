import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class FeedVM extends ChangeNotifier {
  var _amityGlobalFeedPosts = <AmityPost>[];
  var _amityCommunityFeedPosts = <AmityPost>[];
  var _amityImagePosts = <AmityPost>[];
  late PagingController<AmityPost> _controller;

  List<AmityPost> getAmityPosts() {
    return _amityGlobalFeedPosts;
  }

  List<AmityPost> getCommunityPosts() {
    return _amityCommunityFeedPosts;
  }

  void initAmityCommunityFeed(String communityId) async {
    log("initAmityCommunityFeed");
    await AmitySocialClient.newPostRepository()
        .getPosts()
        .targetCommunity(communityId)
        //feedType could be AmityFeedType.PUBLISHED, AmityFeedType.REVIEWING, AmityFeedType.DECLINED
        .feedType(AmityFeedType.PUBLISHED)
        .includeDeleted(false)
        .getPagingData()
        .then((value) {
      print("successfully query community feed");
      _amityCommunityFeedPosts = value.data;
    });
    notifyListeners();
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
