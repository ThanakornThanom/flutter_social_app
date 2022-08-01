import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../comments.dart';

class AmityPostWidget extends StatefulWidget {
  final List<AmityPost> posts;
  final bool isChildrenPost;
  const AmityPostWidget(this.posts, this.isChildrenPost);
  @override
  _AmityPostWidgetState createState() => _AmityPostWidgetState();
}

class _AmityPostWidgetState extends State<AmityPostWidget> {
  List<AmityPost> posts = [];
  bool isChildrenPost = false;
  List<String> imageURLs = [];
  bool isLoading = true;
  @override
  void initState() {
    posts = widget.posts;
    isChildrenPost = widget.isChildrenPost;
    super.initState();
    if (!isChildrenPost) {
      setState(() {
        isLoading = false;
      });
    } else {
      checkPostType();
    }
  }

  void checkPostType() {
    print("check post type ${posts[0].type}");
    switch (posts[0].type) {
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
    print("enter get image post");
    List<String> imageUrlList = [];
    for (var post in posts) {
      final imageData = post.data as ImageData;
      final largeImageUrl = imageData.getUrl(AmityImageSize.FULL);
      imageUrlList.add(largeImageUrl);
    }
    setState(() {
      isLoading = false;
      imageURLs = imageUrlList;
    });
  }

  Widget postWidget() {
    if (!isChildrenPost) {
      return TextPost(post: posts[0]);
    } else {
      switch (posts[0].type) {
        case AmityDataType.IMAGE:
          print("enter post widget image post");
          return ImagePost(
            posts: posts,
            imageURLs: imageURLs,
          );
        default:
          return Container();
      }
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
  final List<AmityPost> posts;
  final List<String> imageURLs;
  const ImagePost({Key? key, required this.posts, required this.imageURLs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        disableCenter: false,
        enableInfiniteScroll: imageURLs.isNotEmpty,
        viewportFraction: imageURLs.length > 1 ? 0.9 : 1.0,
      ),
      items: imageURLs.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                  horizontal: imageURLs.length > 1 ? 5.0 : 0.0),
              decoration: BoxDecoration(color: Colors.transparent),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: OptimizedCacheImage(
                  imageUrl: url,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
    // Column(
    //   children: [
    //     // Padding(
    //     //   padding: EdgeInsets.all(10),
    //     //   child: Text(post.data.toString()),
    //     // ),
    //     // GestureDetector(
    //     //   onTap: () {
    //     //     Navigator.of(context)
    //     //         .push(MaterialPageRoute(builder: (context) => CommentScreen()));
    //     //   },
    //     //   child: ClipRRect(
    //     //     borderRadius: BorderRadius.circular(15),
    //     //     child: Container()
    //     //     // OptimizedCacheImage(
    //     //     //   imageUrl: imageURL ?? "",
    //     //     //   placeholder: (context, url) => Container(
    //     //     //     color: Colors.grey,
    //     //     //   ),
    //     //     //   errorWidget: (context, url, error) => Icon(Icons.error),
    //     //     // ), //Image.asset("assets/images/Layer707.png"),
    //     //   ),
    //     // ),
    //   ],
    // );
  }
}
