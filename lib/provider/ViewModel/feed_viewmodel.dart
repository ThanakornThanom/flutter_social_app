import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

enum Feedtype { GLOBAL, COOMU }

class FeedVM extends ChangeNotifier {
  var _amityGlobalFeedPosts = <AmityPost>[];
  var _amityCommunityFeedPosts = <AmityPost>[];

  late PagingController<AmityPost> _controllerGlobal;
  final scrollcontroller = ScrollController();

  List<AmityPost> getAmityPosts() {
    return _amityGlobalFeedPosts;
  }

  List<AmityPost> getCommunityPosts() {
    return _amityCommunityFeedPosts;
  }

  void addPostToFeed(AmityPost post, Feedtype feedtype) {
    if (feedtype == Feedtype.GLOBAL) {
      _controllerGlobal.addAtIndex(0, post);
      notifyListeners();
    } else if (feedtype == Feedtype.COOMU) {
      ///Coommu controller add posts
      notifyListeners();
    }
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

  Future<void> initAmityGlobalfeed() async {
    _controllerGlobal = PagingController(
      pageFuture: (token) => AmitySocialClient.newFeedRepository()
          .getGlobalFeed()
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          log("initAmityGlobalfeed");
          if (_controllerGlobal.error == null) {
            _amityGlobalFeedPosts.clear();
            _amityGlobalFeedPosts.addAll(_controllerGlobal.loadedItems);

            notifyListeners();
          } else {
            //Error on pagination controller

            print("error");
          }
        },
      );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controllerGlobal.fetchNextPage();
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
        _controllerGlobal.hasMoreItems) {
      _controllerGlobal.fetchNextPage();
    }
  }
}
