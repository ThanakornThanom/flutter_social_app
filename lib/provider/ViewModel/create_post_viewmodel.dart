import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/provider/ViewModel/community_Feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';

import '../../components/alert_dialog.dart';

class AmityFileInfoWithUploadStatus {
  AmityFileInfo? fileInfo;
  bool isComplete = false;
  File? file;
  void addFile(AmityFileInfo amityFileInfo) {
    fileInfo = amityFileInfo;
    isComplete = true;
  }

  void addFilePath(File file) {
    this.file = file;
  }
}

class CreatePostVM extends ChangeNotifier {
  final TextEditingController textEditingController =
      TextEditingController(text: "");
  final ImagePicker _picker = ImagePicker();
  List<AmityFileInfoWithUploadStatus> amityImages =
      <AmityFileInfoWithUploadStatus>[];
  AmityFileInfoWithUploadStatus? amityVideo;

  void inits() {
    textEditingController.clear();
    amityVideo = null;
    amityImages.clear();
  }

  bool isNotSelectedImageYet() {
    if (amityImages.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isNotSelectVideoYet() {
    if (amityVideo == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addFiles() async {
    if (isNotSelectVideoYet()) {
      final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 1);
      if (images != null) {
        for (var image in images) {
          var fileWithStatus = AmityFileInfoWithUploadStatus();
          amityImages.add(fileWithStatus);
          notifyListeners();
          await AmityCoreClient.newFileRepository()
              .image(File(image.path))
              .upload()
              .then((value) {
            if (value is AmityUploadComplete) {
              var fileInfo = value as AmityUploadComplete;
              amityImages.last.addFile(fileInfo.getFile);
            } else {
              log(value.toString());
            }
            notifyListeners();
          }).onError((error, stackTrace) async {
            log("error: ${error}");
            await AmityDialog().showAlertErrorDialog(
                title: "Error!", message: error.toString());
          });
        }
      }
    }
  }

  Future<void> addFileFromCamera() async {
    if (isNotSelectVideoYet()) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        var fileWithStatus = AmityFileInfoWithUploadStatus();
        amityImages.add(fileWithStatus);
        notifyListeners();
        await AmityCoreClient.newFileRepository()
            .image(File(image.path))
            .upload()
            .then((value) {
          var fileInfo = value as AmityUploadComplete;

          amityImages.last.addFile(fileInfo.getFile);
          notifyListeners();
        }).onError((error, stackTrace) async {
          log("error: ${error}");
          await AmityDialog()
              .showAlertErrorDialog(title: "Error!", message: error.toString());
        });
      }
    }
  }

  Future<void> addVideo() async {
    if (isNotSelectedImageYet()) {
      try {
        final XFile? video =
            await _picker.pickVideo(source: ImageSource.gallery);

        if (video != null) {
          var fileWithStatus = AmityFileInfoWithUploadStatus();
          amityVideo = fileWithStatus;
          amityVideo!.file = File(video.path);
          ;
          notifyListeners();
          await AmityCoreClient.newFileRepository()
              .video(File(video.path))
              .upload()
              .then((value) {
            var fileInfo = value as AmityUploadComplete;

            amityVideo!.addFile(fileInfo.getFile);
            log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${fileInfo.getFile.fileId}");

            notifyListeners();
          }).onError((error, stackTrace) async {
            log("error: ${error}");
            await AmityDialog().showAlertErrorDialog(
                title: "Error!", message: error.toString());
          });
        } else {
          log("error: video is null");
          await AmityDialog().showAlertErrorDialog(
              title: "Error!", message: "error: video is null");
        }
      } catch (error) {
        log("error: ${error}");
        await AmityDialog()
            .showAlertErrorDialog(title: "Error!", message: error.toString());
      }
    }
  }

  void deleteImageAt({required int index}) {
    amityImages.removeAt(index);
    notifyListeners();
  }

  Future<void> createPost(BuildContext context, {String? communityId}) async {
    HapticFeedback.heavyImpact();
    bool isCommunity = (communityId != null) ? true : false;
    if (isCommunity) {
      if (isNotSelectVideoYet() && isNotSelectedImageYet()) {
        log("isNotSelectVideoYet() & isNotSelectVideoYet()");

        ///create text post
        await createTextpost(context, communityId: communityId);
      } else if (isNotSelectedImageYet()) {
        log("isNotSelectedImageYet");

        ///create video post
        await creatVideoPost(context, communityId: communityId);
      } else if (isNotSelectVideoYet()) {
        log("isNotSelectVideoYet");

        ///create image post
        await creatImagePost(context, communityId: communityId);
      }
    } else {
      if (isNotSelectVideoYet() && isNotSelectedImageYet()) {
        log("isNotSelectVideoYet() & isNotSelectVideoYet()");

        ///create text post
        await createTextpost(context);
      } else if (isNotSelectedImageYet()) {
        log("isNotSelectedImageYet");

        ///create video post
        await creatVideoPost(context);
      } else if (isNotSelectVideoYet()) {
        log("isNotSelectVideoYet");

        ///create image post
        await creatImagePost(context);
      }
    }
  }

  Future<void> createTextpost(BuildContext context,
      {String? communityId}) async {
    log("createTextpost...");
    bool isCommunity = (communityId != null) ? true : false;
    if (isCommunity) {
      log("in community...");
      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetCommunity(communityId)
          .text(textEditingController.text)
          .post()
          .then((AmityPost post) {
        ///add post to feed
        Provider.of<CommuFeedVM>(context, listen: false).addPostToFeed(post);
        Provider.of<CommuFeedVM>(context, listen: false)
            .scrollcontroller
            .jumpTo(0);
        notifyListeners();
      }).onError((error, stackTrace) async {
        log(error.toString());
        await AmityDialog()
            .showAlertErrorDialog(title: "Error!", message: error.toString());
      });
    } else {
      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetMe() // or targetMe(), targetCommunity(communityId: String)
          .text(textEditingController.text)
          .post()
          .then((AmityPost post) {
        ///add post to feed
        Provider.of<FeedVM>(context, listen: false).addPostToFeed(
          post,
        );
        Provider.of<FeedVM>(context, listen: false).scrollcontroller.jumpTo(0);
        notifyListeners();
      }).onError((error, stackTrace) async {
        log(error.toString());
        await AmityDialog()
            .showAlertErrorDialog(title: "Error!", message: error.toString());
      });
    }
  }

  Future<void> creatImagePost(BuildContext context,
      {String? communityId}) async {
    log("creatImagePost...");
    List<AmityImage> _images = [];
    for (var amityImage in amityImages) {
      if (amityImage.fileInfo is AmityImage) {
        var image = amityImage.fileInfo as AmityImage;
        _images.add(image);
        log("add file to _images");
      }
    }
    log(_images.toString());
    bool isCommunity = (communityId != null) ? true : false;
    if (isCommunity) {
      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetCommunity(communityId)
          .image(_images)
          .text(textEditingController.text)
          .post()
          .then((AmityPost post) {
        ///add post to feedx
        Provider.of<CommuFeedVM>(context, listen: false).addPostToFeed(post);
        Provider.of<CommuFeedVM>(context, listen: false)
            .scrollcontroller
            .jumpTo(0);
      }).onError((error, stackTrace) async {
        log(error.toString());
        await AmityDialog()
            .showAlertErrorDialog(title: "Error!", message: error.toString());
      });
    } else {
      await AmitySocialClient.newPostRepository()
          .createPost()
          .targetMe()
          .image(_images)
          .text(textEditingController.text)
          .post()
          .then((AmityPost post) {
        ///add post to feedx
        Provider.of<FeedVM>(context, listen: false).addPostToFeed(post);
        Provider.of<FeedVM>(context, listen: false).scrollcontroller.jumpTo(0);
      }).onError((error, stackTrace) async {
        log(error.toString());
        await AmityDialog()
            .showAlertErrorDialog(title: "Error!", message: error.toString());
      });
    }
  }

  Future<void> creatVideoPost(BuildContext context,
      {String? communityId}) async {
    log("creatVideoPost...");
    if (amityVideo != null) {
      bool isCommunity = (communityId != null) ? true : false;
      if (isCommunity) {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetCommunity(communityId)
            .video([amityVideo?.fileInfo as AmityVideo])
            .text(textEditingController.text)
            .post()
            .then((AmityPost post) {
              ///add post to feedx
              Provider.of<CommuFeedVM>(context, listen: false)
                  .addPostToFeed(post);
              Provider.of<CommuFeedVM>(context, listen: false)
                  .scrollcontroller
                  .jumpTo(0);
            })
            .onError((error, stackTrace) async {
              await AmityDialog().showAlertErrorDialog(
                  title: "Error!", message: error.toString());
            });
      } else {
        await AmitySocialClient.newPostRepository()
            .createPost()
            .targetMe()
            .video([amityVideo?.fileInfo as AmityVideo])
            .text(textEditingController.text)
            .post()
            .then((AmityPost post) {
              ///add post to feedx
              Provider.of<FeedVM>(context, listen: false).addPostToFeed(post);
              Provider.of<FeedVM>(context, listen: false)
                  .scrollcontroller
                  .jumpTo(0);
            })
            .onError((error, stackTrace) async {
              await AmityDialog().showAlertErrorDialog(
                  title: "Error!", message: error.toString());
            });
      }
    }
  }
}
