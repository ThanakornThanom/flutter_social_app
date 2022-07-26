import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../comments.dart';

class AmityPostWidget extends StatefulWidget {
  final AmityPost post;
  const AmityPostWidget(this.post);
  @override
  _AmityPostWidgetState createState() => _AmityPostWidgetState();
}

class _AmityPostWidgetState extends State<AmityPostWidget> {
  AmityPost post = AmityPost(postId: "");
  String? imageURL;
  bool isLoading = true;
  @override
  void initState() {
    post = widget.post;
    super.initState();
    checkPostType();
  }

  void checkPostType() {
    switch (post.type) {
      case AmityDataType.TEXT:
        setState(() {
          isLoading = false;
        });
        break;
      case AmityDataType.IMAGE:
        getImagePost();
        break;
      case AmityDataType.VIDEO:
        getVideoPost();
        break;
      default:
        break;
    }
  }

  void getVideoPost() {}

  void getImagePost() {
    final imageData = post.data as ImageData;
    final largeImageUrl = imageData.getUrl(AmityImageSize.FULL);
    setState(() {
      isLoading = false;
      imageURL = largeImageUrl;
    });
    // final childrenPosts = post.children;
    // if (childrenPosts?.isNotEmpty == true) {
    //   if (childrenPosts?[0].type == AmityDataType.IMAGE) {
    //     final AmityPostData? amityPostData = childrenPosts?[0].data;
    //     if (amityPostData != null) {
    //       final imageData = amityPostData as ImageData;
    //       //to get the full image url without transcoding
    //       final largeImageUrl = imageData.getUrl(AmityImageSize.FULL);
    //       setState(() {
    //         isLoading = false;
    //         imageURL = largeImageUrl;
    //       });
    //     }
    //   }
    // }
  }

  Widget postWidget() {
    switch (post.type) {
      case AmityDataType.TEXT:
        print("enter post widget text post");
        return TextPost(post: post);
      case AmityDataType.IMAGE:
        print("enter post widget image post");
        return ImagePost(post: post,imageURL: imageURL,);
      default:
        return TextPost(post: post);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container() : postWidget();
  }
}

class TextPost extends StatelessWidget {
  final AmityPost post;
  const TextPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textdata = post.data as TextData;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        // Navigator.of(context)
                        //     .push(MaterialPageRoute(builder: (context) => CommentScreen()));
                      },
                      child: post.type == AmityDataType.TEXT
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(textdata.text.toString()),
                            )
                          : Container()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ImagePost extends StatelessWidget {
  final AmityPost post;
  final String? imageURL;
  const ImagePost({Key? key, required this.post, String? this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.all(10),
        //   child: Text(post.data.toString()),
        // ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CommentScreen()));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: OptimizedCacheImage(
              imageUrl: imageURL ?? "",
              placeholder: (context, url) =>  Container(color: Colors.grey,),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ), //Image.asset("assets/images/Layer707.png"),
          ),
        ),
      ],
    );
  }
}
