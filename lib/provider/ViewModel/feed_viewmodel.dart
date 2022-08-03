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
    notifyListeners();
  }
}
