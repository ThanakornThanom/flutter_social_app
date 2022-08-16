import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:video_player/video_player.dart';

import '../../components/video_player.dart';
import '../comments.dart';
import 'image_viewer.dart';

class AmityPostWidget extends StatefulWidget {
  final List<AmityPost> posts;
  final bool isChildrenPost;
  final bool isCornerRadiusEnabled;
  const AmityPostWidget(
      this.posts, this.isChildrenPost, this.isCornerRadiusEnabled);
  @override
  _AmityPostWidgetState createState() => _AmityPostWidgetState();
}

class _AmityPostWidgetState extends State<AmityPostWidget> {
  VideoPlayerController? videoPlayerController;
  List<String> imageURLs = [];
  String videoUrl = "";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    if (!widget.isChildrenPost) {
      setState(() {
        isLoading = false;
      });
    } else {
      checkPostType();
    }
  }

  Future<void> checkPostType() async {
    switch (widget.posts[0].type) {
      case AmityDataType.IMAGE:
        await getImagePost();
        break;
      case AmityDataType.VIDEO:
        await getVideoPost();
        break;
      default:
        break;
    }
  }

  Future<void> getVideoPost() async {
    final videoData = widget.posts[0].data as VideoData;

    await videoData.getVideo(AmityVideoQuality.HIGH).then((AmityVideo video) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
          videoUrl = video.fileUrl;
        });
      }
    });
  }

  Future<void> getImagePost() async {
    List<String> imageUrlList = [];

    for (var post in widget.posts) {
      final imageData = post.data as ImageData;
      final largeImageUrl = await imageData.getUrl(AmityImageSize.MEDIUM);

      imageUrlList.add(largeImageUrl);
    }
    setState(() {
      isLoading = false;
      imageURLs = imageUrlList;
    });
  }

  Widget postWidget() {
    if (!widget.isChildrenPost) {
      return TextPost(post: widget.posts[0]);
    } else {
      switch (widget.posts[0].type) {
        case AmityDataType.IMAGE:
          return ImagePost(
              posts: widget.posts,
              imageURLs: imageURLs,
              isCornerRadiusEnabled:
                  widget.isCornerRadiusEnabled || imageURLs.length > 1
                      ? true
                      : false);
        case AmityDataType.VIDEO:
          return MyVideoPlayer2(
            url: videoUrl,
            videoPlayerController: videoPlayerController =
                VideoPlayerController.network(videoUrl),
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentScreen(
                                  amityPost: post,
                                )));
                      },
                      child: post.type == AmityDataType.TEXT
                          ? Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(textdata.text.toString()),
                            )
                          : Container()),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ImagePost extends StatelessWidget {
  final List<AmityPost> posts;
  final List<String> imageURLs;
  final bool isCornerRadiusEnabled;
  const ImagePost(
      {Key? key,
      required this.posts,
      required this.imageURLs,
      required this.isCornerRadiusEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        disableCenter: false,
        enableInfiniteScroll: imageURLs.length > 1,
        viewportFraction: imageURLs.length > 1 ? 0.9 : 1.0,
      ),
      items: imageURLs.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(_goToImageViewer(url));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                    horizontal: imageURLs.length > 1 ? 5.0 : 0.0),
                decoration: BoxDecoration(color: Colors.transparent),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(isCornerRadiusEnabled ? 10 : 0),
                  child: OptimizedCacheImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Route _goToImageViewer(String url) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ImageViewer(
          imageURLs: imageURLs, initialIndex: imageURLs.indexOf(url)),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class VideoPost extends StatefulWidget {
  final AmityPost post;
  final String videoURL;
  final bool isCornerRadiusEnabled;
  const VideoPost(
      {Key? key,
      required this.post,
      required this.videoURL,
      required this.isCornerRadiusEnabled})
      : super(key: key);
  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends State<VideoPost> {
  AmityPost post = AmityPost(postId: "");
  String videoURL = "";
  bool isCornerRadiusEnabled = true;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    post = widget.post;
    videoURL = widget.videoURL;
    isCornerRadiusEnabled = widget.isCornerRadiusEnabled;
    initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(videoURL);
    await videoPlayerController.initialize();
    ChewieController controller = ChewieController(
      showControlsOnInitialize: true,
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
      looping: true,
    );

    controller.setVolume(0.0);

    setState(() {
      chewieController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isCornerRadiusEnabled ? 10 : 0),
      child: Container(
        height: 250,
        color: Colors.black,
        child: Center(
          child: chewieController != null &&
                  chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: chewieController!,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    // SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
