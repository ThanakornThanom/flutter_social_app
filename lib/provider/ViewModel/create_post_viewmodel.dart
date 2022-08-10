import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';

class CreatePostVM extends ChangeNotifier {
  final TextEditingController textEditingController =
      TextEditingController(text: "");
  final ImagePicker _picker = ImagePicker();
  List<AmityFileInfo> amityImages = <AmityFileInfo>[];
  AmityFileInfo? amityVideo;

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
          await AmityCoreClient.newFileRepository()
              .image(File(image.path))
              .upload()
              .then((value) {
            var fileInfo = value as AmityUploadComplete;
            print("upload image success: ${fileInfo.getFile.fileUrl}");

            amityImages.add(fileInfo.getFile);
            notifyListeners();
          }).onError((error, stackTrace) {
            print("error: ${error}");
          });
        }
      }
    }
  }

  Future<void> addFileFromCamera() async {
    if (isNotSelectVideoYet()) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        await AmityCoreClient.newFileRepository()
            .image(File(image.path))
            .upload()
            .then((value) {
          var fileInfo = value as AmityUploadComplete;
          print("upload image success: ${fileInfo.getFile.fileUrl}");

          amityImages.add(fileInfo.getFile);
          notifyListeners();
        }).onError((error, stackTrace) {
          print("error: ${error}");
        });
      }
    }
  }

  Future<void> addVideo() async {
    if (isNotSelectedImageYet()) {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

      if (video != null) {
        await AmityCoreClient.newFileRepository()
            .image(File(video.path))
            .upload()
            .then((value) {
          var fileInfo = value as AmityUploadComplete;
          print("upload image success: ${fileInfo.getFile.fileUrl}");

          amityVideo = fileInfo.getFile;
          notifyListeners();
        }).onError((error, stackTrace) {
          print("error: ${error}");
        });
      }
    }
  }

  void deleteImageAt({required int index}) {
    amityImages.removeAt(index);
    notifyListeners();
  }

  Future<void> createPostToUserFeed(BuildContext context) async {
    if (isNotSelectVideoYet() && isNotSelectVideoYet()) {
      ///create text post
      await createTextpost(context);
    } else if (isNotSelectedImageYet()) {
      ///create video post
    } else if (isNotSelectVideoYet()) {
      ///create image post
    }
  }

  Future<void> createTextpost(BuildContext context) async {
    await AmitySocialClient.newPostRepository()
        .createPost()
        .targetMe() // or targetMe(), targetCommunity(communityId: String)
        .text(textEditingController.text)
        .post()
        .then((AmityPost post) {
      ///add post to feed
      Provider.of<FeedVM>(context, listen: false)
          .addPostToFeed(post, Feedtype.GLOBAL);
      Provider.of<FeedVM>(context, listen: false).scrollcontroller.jumpTo(0);
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
