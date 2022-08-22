import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/repository/chat_repo_imp.dart';

import '../../model/amity_channel_model.dart';

class ChannelVM extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  AmityChatRepoImp channelRepoImp = AmityChatRepoImp();
  List<Channels> _amityChannelList = [];
  Map<String, ChannelUsers> channelUserMap = {};
  List<Channels> getChannelList() {
    return _amityChannelList;
  }

  Future<void> initVM() async {
    print("initVM");
    String accessToken =
        "eyJhbGciOiJSUzI1NiIsImtpZCI6IkdTLWNDSUFib1IyQUhfQXczY29Bb0VtR1ZkdzFfaWxjc09BWGx6OXBoSFkifQ.eyJ1c2VyIjp7InJlZnJlc2hUb2tlbiI6IjhlNjVhYmY0MjM3OThkOWMwNmViMzBlMmRkMTU1YjcwZTJjNzM0NjdjNDA1MDRlY2U2NGRkNGUxMDk1NmIzNjNkZDFhNzIwN2Q0YjdkYTg3IiwidXNlcklkIjoiNjE4MmVhYWVmYTJmN2UyYzZiNzI4YjQ4IiwicHVibGljVXNlcklkIjoiam9obndpY2syIiwiZGV2aWNlSW5mbyI6eyJraW5kIjoiaW9zIiwibW9kZWwiOiJzdHJpbmciLCJzZGtWZXJzaW9uIjoic3RyaW5nIn0sIm5ldHdvcmtJZCI6IjVmY2EwYjRhYTZhNmMxOGQ3NjE1ODg2YyIsImRpc3BsYXlOYW1lIjoiam9obndpY2syIn0sInN1YiI6IjYxODJlYWFlZmEyZjdlMmM2YjcyOGI0OCIsImlzcyI6Imh0dHBzOi8vYXBpLmFtaXR5LmNvIiwiaWF0IjoxNjYxMTU5MTUyLCJleHAiOjE2OTI3MTY3NTJ9.ZlQXS6ZZZJngjkmNjzasBmUoAmOclqovoRizw1PVAcMeU5xfZrcUiP-8RLDzixaFitVmlZpZhr_qEnJ2Ian6BpAaHByqiR8gP4I8O3AGeDmCGvihp3BVAc7Uo1pzmxfCsz7ykWOhrn9ho-5ke8wPieTSGDNKe_27qQqlv5edCNzo1zPQSVHZUN5ZGE6TfaZQaVJ-OaAWTbEVALoXHw95rEzvlwRvF23TPX3-xdiY_9wOX05kbKC9MA0Llf8VajqcXglqxEL1smguA9K-kz50j4JVqm-L4Xn8adtf9faL_e1U8H-ZWqtu1uh-dSMUwpiyDw8xtgrdr6VEkX_b4Nklxg";

    await channelRepoImp.initRepo(accessToken);
    await channelRepoImp.listenToChannel((messages) {
      ///get channel where channel id == new message channelId
      var channel = _amityChannelList.firstWhere((amityMessage) =>
          amityMessage.channelId == messages.messages?[0].channelId);
      print(
          "${channel.channelId} got new message from ${messages.messages![0].userId}");

      if (messages.messages![0].userId !=
          AmityCoreClient.getCurrentUser().userId) {
        ///add unread count by 1
        channel.setUnreadCount(channel.unreadCount + 1);
      }

      //move channel to the top
      _amityChannelList.remove(channel);
      _amityChannelList.insert(0, channel);
      notifyListeners();
    });
    await channelRepoImp.fetchChannels((data, error) {
      if (error == null && data != null) {
        print("success ${data.channels}");
        _amityChannelList.clear();

        _addUnreadCountToEachChannel(data);

        if (data.channels != null) {
          print("success 2");

          for (var channel in data.channels!) {
            print("success 3");
            _amityChannelList.add(channel);
            String key =
                channel.channelId! + AmityCoreClient.getCurrentUser().userId!;
            if (channelUserMap[key] != null) {
              var count =
                  channel.messageCount! - channelUserMap[key]!.readToSegment!;
              channel.setUnreadCount(count);
              print(channel.unreadCount);
            }
          }

          print(channelUserMap);
        }
      } else {
        print(error);
      }

      notifyListeners();
    });

    // scrollController.addListener(loadnextpage);
  }

  // void loadnextpage() {
  //   if ((scrollController.position.pixels ==
  //           scrollController.position.maxScrollExtent) &&
  //       scrollController.hasMoreItems) {
  //     scrollController.fetchNextPage();
  //   }
  // }

  void _addUnreadCountToEachChannel(ChannelList data) {
    for (var channelUser in data.channelUsers!) {
      channelUserMap[channelUser.channelId! + channelUser.userId!] =
          channelUser;
    }
    print("mapReadSegment complete");
  }

  void removeUnreadCount(String channelId) {
    ///get channel where channel id == new message channelId
    var channel = _amityChannelList
        .firstWhere((amityMessage) => amityMessage.channelId == channelId);

    ///set unread count = 0
    channel.setUnreadCount(0);

    notifyListeners();
  }
}
