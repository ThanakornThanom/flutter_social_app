import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/repository/chat_repo_imp.dart';

import '../../model/amity_channel_model.dart';

class ChannelVM extends ChangeNotifier {
  ScrollController? scrollController = ScrollController();
  AmityChatRepoImp channelRepoImp = AmityChatRepoImp();
  List<Channels> _amityChannelList = [];
  Map<String, ChannelUsers> channelUserMap = {};
  List<Channels> getChannelList() {
    return _amityChannelList;
  }

  Future<void> initVM() async {
    print("initVM");
    String accessToken =
        "eyJhbGciOiJSUzI1NiIsImtpZCI6IkdTLWNDSUFib1IyQUhfQXczY29Bb0VtR1ZkdzFfaWxjc09BWGx6OXBoSFkifQ.eyJ1c2VyIjp7InJlZnJlc2hUb2tlbiI6IjA1YzBhZGYyNmY3ZTAwMzZiN2Q5MzBlZTU3OTkxNTE4M2Q1MzU4MjI2MGM0MWNlOGFkZGZjMTE1NWNmODViYmNjMTZkM2M0YWIwMmE1ODg1IiwidXNlcklkIjoiNjE4MmVhYWVmYTJmN2UyYzZiNzI4YjQ4IiwicHVibGljVXNlcklkIjoiam9obndpY2syIiwiZGV2aWNlSW5mbyI6eyJraW5kIjoiaW9zIiwibW9kZWwiOiJzdHJpbmciLCJzZGtWZXJzaW9uIjoic3RyaW5nIn0sIm5ldHdvcmtJZCI6IjVmY2EwYjRhYTZhNmMxOGQ3NjE1ODg2YyIsImRpc3BsYXlOYW1lIjoiam9obndpY2syIn0sInN1YiI6IjYxODJlYWFlZmEyZjdlMmM2YjcyOGI0OCIsImlzcyI6Imh0dHBzOi8vYXBpLmFtaXR5LmNvIiwiaWF0IjoxNjYwOTcwOTExLCJleHAiOjE2OTI1Mjg1MTF9.MsYr0hQAtn6rGYyJ41GkNwe41nxFxT6UHyPX6DZYtTNA2PSHT-o2tgjGLFj1UJEPwnxbCdv4z1jjHb__q9Id1bACy_CHoQ-sKrXurwYbhSS4W3FRyGpbGGoAZiRBztEkk0RiUbHQOGsWz0E-f3iDz7kOmeWNL72q1JWqPI7-yokmLfdLUanVJnG_gS08I6UoxNnt64wUk28Z_CyalhEdxyidenN1UGjeWqMzxsE5iivtsfR56f_D6UtFsDZuyqtFCrQk09WmE_0lAc-Auj2At0HK3sFzvPapdSUmi8t5OR6i0oWuvK51xUm8PisW3y5Lk8ChivV-1Qaa9Uk8Aj--hg";
    await channelRepoImp.initRepo(accessToken);
    await channelRepoImp.listenToChannel((messages) {
      ///get channel where channel id == new message channelId
      var channel = _amityChannelList.firstWhere((amityMessage) =>
          amityMessage.channelId == messages.messages?[0].channelId);
      print("${channel.channelId} got new message");

      ///add unread count by 1
      channel.setUnreadCount(channel.unreadCount! + 1);

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

            if (channelUserMap[channel.channelId] != null) {
              var count = channel.messageCount! -
                  channelUserMap[channel.channelId]!.readToSegment!;
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
  }

  void _addUnreadCountToEachChannel(ChannelList data) {
    for (var channelUser in data.channelUsers!) {
      channelUserMap[channelUser.channelId!] = channelUser;
    }
    print("mapReadSegment complete");
  }
}
