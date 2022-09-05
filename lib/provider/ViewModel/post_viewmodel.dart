import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/alert_dialog.dart';

class PostVM extends ChangeNotifier {
  late AmityPost amityPost;
  late PagingController<AmityComment> _controller;
  final amityComments = <AmityComment>[];

  final scrollcontroller = ScrollController();

  AmityComment? _replyToComment;

  AmityCommentSortOption _sortOption = AmityCommentSortOption.FIRST_CREATED;

  void getPost(String postId, AmityPost initialPostData) {
    amityPost = initialPostData;
    AmitySocialClient.newPostRepository()
        .getPost(postId)
        .then((AmityPost post) {
      amityPost = post;
    }).onError<AmityException>((error, stackTrace) async {
      log(error.toString());
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
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
        () async {
          if (_controller.error == null) {
            amityComments.clear();
            amityComments.addAll(_controller.loadedItems);

            notifyListeners();
          } else {
            //Error on pagination controller

            log("error");
            await AmityDialog().showAlertErrorDialog(
                title: "Error!", message: _controller.error.toString());
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
        .then((_comment) async {
      _controller.add(_comment);
      amityComments.clear();
      amityComments.addAll(_controller.loadedItems);
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        scrollcontroller.jumpTo(scrollcontroller.position.maxScrollExtent);
      });
    }).onError((error, stackTrace) async {
      log(error.toString());
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  void addCommentReaction(AmityComment comment) {
    HapticFeedback.heavyImpact();
    comment.react().addReaction('like').then((value) {});
  }

  void addPostReaction(AmityPost post) {
    HapticFeedback.heavyImpact();
    post.react().addReaction('like').then((value) => {
          //success
        });
  }

  void flagPost(AmityPost post) {
    post.report().flag().then((value) {
      log("flag success ${value}");
      notifyListeners();
    }).onError((error, stackTrace) async {
      log("flag error ${error.toString()}");
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  void unflagPost(AmityPost post) {
    post.report().unflag().then((value) {
      //success
      log("unflag success ${value}");
      notifyListeners();
    }).onError((error, stackTrace) async {
      log("unflag error ${error.toString()}");
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  void removePostReaction(AmityPost post) {
    HapticFeedback.heavyImpact();
    post.react().removeReaction('like').then((value) => {
          //success
        });
  }

  void removeCommentReaction(AmityComment comment) {
    HapticFeedback.heavyImpact();
    comment.react().removeReaction('like').then((value) => {
          //success
        });
  }

  bool isliked(AmityComment comment) {
    return comment.myReactions?.isNotEmpty ?? false;
  }
}
