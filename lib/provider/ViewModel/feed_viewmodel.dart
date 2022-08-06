import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class FeedVM extends ChangeNotifier {
  var _amityGlobalFeedPosts = <AmityPost>[];
  var _amityCommunityFeedPosts = <AmityPost>[];

  late PagingController<AmityPost> _controller;
  final scrollcontroller = ScrollController();

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
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newFeedRepository()
          .getGlobalFeed()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_controller.error == null) {
            _amityGlobalFeedPosts.clear();
            _amityGlobalFeedPosts.addAll(_controller.loadedItems);

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

    //inititate the PagingController
    await AmitySocialClient.newFeedRepository()
        .getGlobalFeed()
        .getPagingData()
        .then((value) {
      _amityGlobalFeedPosts = value.data;
    });
    notifyListeners();
  }

  void loadnextpage() {
    if ((scrollcontroller.position.pixels ==
            scrollcontroller.position.maxScrollExtent) &&
        _controller.hasMoreItems) {
      _controller.fetchNextPage();
    }
  }
}
