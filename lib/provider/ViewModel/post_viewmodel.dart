import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class PostVM extends ChangeNotifier {
  var _amityComments = <AmityComment>[];

  List<AmityComment> getAmityPosts() {
    return _amityComments;
  }

  late PagingController<AmityComment> _commentController;
  CommentRepository _commentRepository =
      AmitySocialClient.newCommentRepository();

// To query for all first level comments without parentId
  Future<void> queryComments(String postId) async {
    log("queryComments for post:$postId");
    _commentRepository.getComments().post(postId).getPagingData().then((value) {
      _amityComments = value.item1;
      notifyListeners();
    });

    // _commentController = await PagingController(
    //   pageFuture: (token) => _commentRepository
    //       .getComments()
    //       .post(postId)
    //       .includeDeleted(false) //optional
    //       .getPagingData(token: token, limit: 20),
    //   pageSize: 20,
    // )
    //   ..addListener(
    //     () {
    //       log("query");
    //       if (_commentController.error == null) {
    //         //handle results, we suggest to clear the previous items
    //         //and add with the latest _controller.loadedItems
    //         _amityComments.clear();
    //         _amityComments.addAll(_commentController.loadedItems);
    //         //update widgets
    //         notifyListeners();
    //       } else {
    //         //error on pagination controller
    //         //update widgets
    //         log("error");
    //       }
    //     },
    //   );
  }

  void clearComments() {
    _amityComments = [];
  }

  final amityRepliedComments = <AmityComment>[];
  late PagingController<AmityComment> _repliedCommentController;

// To query for replies on a comment, pass the commentId as a parentId
  void queryRepliedComments(String postId, String commentParentId) {
    _repliedCommentController = PagingController(
      pageFuture: (token) => _commentRepository
          .getComments()
          .post(postId)
          .parentId(commentParentId)
          .includeDeleted(true) //optional
          .getPagingData(token: token, limit: 20),
      pageSize: 20,
    )..addListener(
        () {
          if (_repliedCommentController.error == null) {
            //handle results, we suggest to clear the previous items
            //and add with the latest _controller.loadedItems
            _amityComments.clear();
            _amityComments.addAll(_repliedCommentController.loadedItems);
            //update widgets
            notifyListeners();
          } else {
            //error on pagination controller
            //update widgets
          }
        },
      );
  }
}
