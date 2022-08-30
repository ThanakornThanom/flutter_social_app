import 'dart:ffi';
import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final File file;
  const LocalVideoPlayer({Key? key, required this.file}) : super(key: key);

  @override
  State<LocalVideoPlayer> createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = await VideoPlayerController.file(widget.file);
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

  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(true ? 10 : 0),
      child: Container(
        height: 250,
        color: Color.fromRGBO(0, 0, 0, 1),
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

class MyVideoPlayer2 extends StatefulWidget {
  final String url;
  final AmityPost post;
  final bool isInFeed;
  final bool isEnableVideoTools;
  const MyVideoPlayer2(
      {Key? key,
      required this.url,
      required this.isInFeed,
      required this.isEnableVideoTools,
      required this.post})
      : super(key: key);

  @override
  State<MyVideoPlayer2> createState() => _MyVideoPlayer2State();
}

class _MyVideoPlayer2State extends State<MyVideoPlayer2> {
  String? thumbnailURL;
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  void initState() {
    var postData = widget.post.data as VideoData;
    if (postData.thumbnail != null) {
      thumbnailURL = postData.thumbnail!.fileUrl;
    }
    if (!widget.isInFeed) {
      initializePlayer();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.isInFeed) {
      videoPlayerController.dispose();
    }
    chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = await VideoPlayerController.network(widget.url);
    await videoPlayerController.initialize();
    ChewieController controller = ChewieController(
      showControls: widget.isInFeed ? false : true,
      videoPlayerController: videoPlayerController,
      autoPlay: widget.isInFeed ? false : true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
      looping: true,
    );

    if (widget.isInFeed) {
      controller.setVolume(0.0);
    } else {
      controller.setVolume(50);
    }

    setState(() {
      chewieController = controller;
    });
  }

  Widget build(BuildContext context) {
    return FadeAnimation(
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(widget.isInFeed ? 10 : 0),
              child: Container(
                height: 250,
                color: Color.fromRGBO(0, 0, 0, 1),
                child: Center(
                    child: !widget.isInFeed
                        ? chewieController != null &&
                                chewieController!
                                    .videoPlayerController.value.isInitialized
                            ? Chewie(
                                controller: chewieController!,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()],
                              )
                        : OptimizedCacheImage(
                            imageBuilder: (context, imageProvider) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.red,
                                        child: Image(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            imageUrl: thumbnailURL ??
                                "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/live-stream-logo-design-template-734b190682052e1a5f76a413c7f751ba_screen.jpg?ts=1589561822",
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )),
              ),
            ),
            widget.isInFeed
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).highlightColor,
                    child: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
