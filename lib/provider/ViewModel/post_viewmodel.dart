import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class PostVM extends ChangeNotifier {
  late AmityPost amityPost;
  late PagingController<AmityComment> _controller;
  final amityComments = <AmityComment>[];

  final scrollcontroller = ScrollController();
  bool loading = false;

  AmityComment? _replyToComment;

  AmityCommentSortOption _sortOption = AmityCommentSortOption.LAST_CREATED;

  void getPost(String postId, AmityPost initialPostData) {
    amityPost = initialPostData;
    AmitySocialClient.newPostRepository()
        .getPost(postId)
        .then((AmityPost post) {
      amityPost = post;
    }).onError<AmityException>((error, stackTrace) {
      log(error.toString());
    });
  }

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
        .send()
        .then((_comment) {
      _controller.addAtIndex(0, _comment);
      amityComments.clear();
      amityComments.addAll(_controller.loadedItems);
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  void addCommentReaction(AmityComment comment) {
    comment.react().addReaction('like').then((value) {});
  }

  void addPostReaction(AmityPost post) {
    post.react().addReaction('like').then((value) => {
          //success
        });
  }

  void removePostReaction(AmityPost post) {
    post.react().removeReaction('like').then((value) => {
          //success
        });
  }

  void removeCommentReaction(AmityComment comment) {
    comment.react().removeReaction('like').then((value) => {
          //success
        });
  }

  bool isliked(AmityComment comment) {
    return comment.myReactions?.isNotEmpty ?? false;
  }
}
