import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class CreatePostVM extends ChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
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

  void createPost() {}
}
