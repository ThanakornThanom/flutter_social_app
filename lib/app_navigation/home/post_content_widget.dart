import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../comments.dart';

class AmityPostWidget extends StatelessWidget {
  final AmityPost post;
  const AmityPostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (post.data is TextData) {
      log("is Text post");
      return TextPost(post: post);
    } else if (post.data is ImageData) {
      log("is image post");
      return ImagePost(post: post);
    } else {
      log("is other type: ${post.data.toString()}");
      return TextPost(post: post);
    }
  }
}

class TextPost extends StatelessWidget {
  final AmityPost post;
  const TextPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textdata = post.data as TextData;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommentScreen(
                  amityPost: post,
                )));
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        textdata.text.toString(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImagePost extends StatelessWidget {
  final AmityPost post;
  const ImagePost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(post.data.toString()),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CommentScreen(
                      amityPost: post,
                    )));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset("assets/images/Layer707.png"),
          ),
        ),
      ],
    );
  }
}
