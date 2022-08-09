import 'dart:io';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerVM extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  AmityFileInfo? amityImage;

  void init() {
    amityImage = null;
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                ListTile(
                    leading: Icon(Icons.photo),
                    title: Text('Gallery'),
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      await AmityCoreClient.newFileRepository()
                          .image(File(image!.path))
                          .upload()
                          .then((value) {
                        var fileInfo = value as AmityUploadComplete;
                        print(
                            "upload image success: ${fileInfo.getFile.fileUrl}");

                        amityImage = fileInfo.getFile;
                        notifyListeners();
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        print("error: ${error}");
                      });
                    }),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: new Icon(Icons.camera_alt),
                  title: new Text('Camera'),
                  onTap: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    await AmityCoreClient.newFileRepository()
                        .image(File(image!.path))
                        .upload()
                        .then((value) {
                      var fileInfo = value as AmityUploadComplete;
                      print(
                          "upload image success: ${fileInfo.getFile.fileUrl}");
                      amityImage = fileInfo.getFile;
                      notifyListeners();
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      print("error: ${error}");
                    });
                  },
                ),
              ],
            ),
          );
        });
  }
}