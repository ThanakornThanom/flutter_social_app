import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/repository/chat_repo_imp.dart';

class MessageVM extends ChangeNotifier {
  ChannelRepoImp channelRepoImp = ChannelRepoImp();
  List<AmittyMessage> amityMessageList = [];
  Future<void> initVM(String channelId) async {
    print("initVM");
    String accessToken =
        "eyJhbGciOiJSUzI1NiIsImtpZCI6IkdTLWNDSUFib1IyQUhfQXczY29Bb0VtR1ZkdzFfaWxjc09BWGx6OXBoSFkifQ.eyJ1c2VyIjp7InJlZnJlc2hUb2tlbiI6IjA1YzBhZGYyNmY3ZTAwMzZiN2Q5MzBlZTU3OTkxNTE4M2Q1MzU4MjI2MGM0MWNlOGFkZGZjMTE1NWNmODViYmNjMTZkM2M0YWIwMmE1ODg1IiwidXNlcklkIjoiNjE4MmVhYWVmYTJmN2UyYzZiNzI4YjQ4IiwicHVibGljVXNlcklkIjoiam9obndpY2syIiwiZGV2aWNlSW5mbyI6eyJraW5kIjoiaW9zIiwibW9kZWwiOiJzdHJpbmciLCJzZGtWZXJzaW9uIjoic3RyaW5nIn0sIm5ldHdvcmtJZCI6IjVmY2EwYjRhYTZhNmMxOGQ3NjE1ODg2YyIsImRpc3BsYXlOYW1lIjoiam9obndpY2syIn0sInN1YiI6IjYxODJlYWFlZmEyZjdlMmM2YjcyOGI0OCIsImlzcyI6Imh0dHBzOi8vYXBpLmFtaXR5LmNvIiwiaWF0IjoxNjYwOTcwOTExLCJleHAiOjE2OTI1Mjg1MTF9.MsYr0hQAtn6rGYyJ41GkNwe41nxFxT6UHyPX6DZYtTNA2PSHT-o2tgjGLFj1UJEPwnxbCdv4z1jjHb__q9Id1bACy_CHoQ-sKrXurwYbhSS4W3FRyGpbGGoAZiRBztEkk0RiUbHQOGsWz0E-f3iDz7kOmeWNL72q1JWqPI7-yokmLfdLUanVJnG_gS08I6UoxNnt64wUk28Z_CyalhEdxyidenN1UGjeWqMzxsE5iivtsfR56f_D6UtFsDZuyqtFCrQk09WmE_0lAc-Auj2At0HK3sFzvPapdSUmi8t5OR6i0oWuvK51xUm8PisW3y5Lk8ChivV-1Qaa9Uk8Aj--hg";
    await channelRepoImp.initRepo(accessToken, channelId);
    await channelRepoImp.listenToChannel((messages) {
      print(messages.messages![0].channelId);
      print(channelId);
      if (messages.messages?[0].channelId == channelId) {
        print("get new messgae...: ${messages.messages?[0].data?.text}");
        amityMessageList.add(messages);
        notifyListeners();
      }
    });
  }
}
