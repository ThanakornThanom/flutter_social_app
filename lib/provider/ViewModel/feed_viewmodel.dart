import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

import '../../components/alert_dialog.dart';

enum Feedtype { GLOBAL, COOMU }

class FeedVM extends ChangeNotifier {
  var _amityGlobalFeedPosts = <AmityPost>[];

  late PagingController<AmityPost> _controllerGlobal;

  final scrollcontroller = ScrollController();

  bool loadingNexPage = false;
  List<AmityPost> getAmityPosts() {
    return _amityGlobalFeedPosts;
  }

  Future<void> addPostToFeed(AmityPost post) async {
    _controllerGlobal.addAtIndex(0, post);
    notifyListeners();
  }

  void deletePost(AmityPost post, int postIndex) async {
    AmitySocialClient.newPostRepository()
        .deletePost(postId: post.postId!)
        .then((value) {
      _amityGlobalFeedPosts.removeAt(postIndex);
      notifyListeners();
    }).onError((error, stackTrace) async {
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  Future<void> initAmityGlobalfeed() async {
    _controllerGlobal = PagingController(
      pageFuture: (token) => AmitySocialClient.newFeedRepository()
          .getGlobalFeed()
          .getPagingData(token: token, limit: 5),
      pageSize: 5,
    )..addListener(
        () async {
          log("initAmityGlobalfeed");
          if (_controllerGlobal.error == null) {
            _amityGlobalFeedPosts.clear();
            _amityGlobalFeedPosts.addAll(_controllerGlobal.loadedItems);

            notifyListeners();
          } else {
            //Error on pagination controller

            print("error");
            await AmityDialog().showAlertErrorDialog(
                title: "Error!", message: _controllerGlobal.error.toString());
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

  void loadnextpage() async {
    if ((scrollcontroller.position.pixels >
            scrollcontroller.position.maxScrollExtent - 800) &&
        _controllerGlobal.hasMoreItems &&
        !loadingNexPage) {
      loadingNexPage = true;
      notifyListeners();
      print("loading Next Page...");
      await _controllerGlobal.fetchNextPage().then((value) {
        loadingNexPage = false;
        notifyListeners();
      });
    }
  }
}
