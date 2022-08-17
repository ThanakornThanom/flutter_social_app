import 'dart:ffi';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  final File file;
  const MyVideoPlayer({Key? key, required this.file}) : super(key: key);

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
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
  final VideoPlayerController videoPlayerController;
  final bool isCornerRadiusEnabled;
  final bool isEnableVideoTools;
  const MyVideoPlayer2(
      {Key? key,
      required this.url,
      required this.videoPlayerController,
      required this.isCornerRadiusEnabled,
      required this.isEnableVideoTools})
      : super(key: key);

  @override
  State<MyVideoPlayer2> createState() => _MyVideoPlayer2State();
}

class _MyVideoPlayer2State extends State<MyVideoPlayer2> {
  ChewieController? chewieController;

  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    //videoPlayerController = await VideoPlayerController.network(widget.url);
    await widget.videoPlayerController.initialize();
    ChewieController controller = ChewieController(
      showControls: widget.isCornerRadiusEnabled ? false : true,
      videoPlayerController: widget.videoPlayerController,
      autoPlay: widget.isCornerRadiusEnabled ? false : true,
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
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(widget.isCornerRadiusEnabled ? 10 : 0),
          child: Container(
            height: 250,
            color: Color.fromRGBO(0, 0, 0, 1),
            child: Center(
              child: chewieController != null &&
                      chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.isCornerRadiusEnabled
                            ? Container()
                            : CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        // SizedBox(height: 20),
                      ],
                    ),
            ),
          ),
        ),
        widget.isCornerRadiusEnabled
            ? CircleAvatar(
                backgroundColor: Theme.of(context).highlightColor,
                child: Icon(
                  Icons.play_arrow,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Container()
      ],
    );
  }
}
