import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class PostVM extends ChangeNotifier {
  late PagingController<AmityComment> _controller;
  final amityComments = <AmityComment>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  AmityComment? _replyToComment;

  AmityCommentSortOption _sortOption = AmityCommentSortOption.LAST_CREATED;

  void listenForComments(String postID) {
    _controller = PagingController(
      pageFuture: (token) => AmitySocialClient.newCommentRepository()
          .getComments()
          .post(postID)
          .sortBy(_sortOption)
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          print("listenForComments...");
          if (_controller.error == null) {
            amityComments.clear();
            amityComments.addAll(_controller.loadedItems);
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

  Future<void> createComment(String postId, String text) async {
    final _comment = await AmitySocialClient.newCommentRepository()
        .createComment()
        .post(postId)
        .create()
        .text(text)
        .send();
    _controller.addAtIndex(0, _comment);

    AmitySocialClient.newPostRepository().getPost("asdasd").then((value) {
      print("getpost : ${value}");
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
