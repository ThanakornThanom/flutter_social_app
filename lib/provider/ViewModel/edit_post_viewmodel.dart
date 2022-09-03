import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:verbose_share_world/provider/ViewModel/create_post_viewmodel.dart';

class EditPostVM extends CreatePostVM {
  List<String> imageUrlList = [];
  String? videoUrl;

  void initForEditPost(AmityPost post) {
    textEditingController.clear();
    imageUrlList.clear();
    videoUrl = null;

    var textdata = post.data as TextData;
    textEditingController.text = textdata.text!;
    var children = post.children;
    if (children != null) {
      if (children[0].data is ImageData) {
        imageUrlList = [];
        for (var child in children) {
          var imageData = child.data as ImageData;
          imageUrlList.add(imageData.fileInfo.fileUrl);
        }

        log("ImageData: $imageUrlList");
      } else if (children[0].data is VideoData) {
        var videoData = children[0].data as VideoData;

        videoUrl =
            "https://api.${dotenv.env["REGION"]}.amity.co/api/v3/files/${videoData.fileId}/download?size=full";
        log("VideoPost: $videoUrl");
      }
    }
  }

  void deleteImageAt({required int index}) {
    if (imageUrlList != null) {
      imageUrlList.removeAt(index);
      notifyListeners();
    }
  }

  bool isNotSelectedImageYet() {
    if (imageUrlList.isEmpty) {
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

  Future<void> editPost() async {}
}
