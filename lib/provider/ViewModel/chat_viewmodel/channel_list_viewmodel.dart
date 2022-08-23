import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        "eyJhbGciOiJSUzI1NiIsImtpZCI6IkdTLWNDSUFib1IyQUhfQXczY29Bb0VtR1ZkdzFfaWxjc09BWGx6OXBoSFkifQ.eyJ1c2VyIjp7InJlZnJlc2hUb2tlbiI6Ijg1NGQ1MmFkZDhjMmJlNmJiY2IyZGVhMmI4ZThhOTBjYWZhNDUwY2QzZmExOGQxNjNhNTkwYzFiOGVkNmExZDMxYTZiODY2ZTQ1ZGRmYmE4IiwidXNlcklkIjoiNjE4MmVhYWVmYTJmN2UyYzZiNzI4YjQ4IiwicHVibGljVXNlcklkIjoiam9obndpY2syIiwibmV0d29ya0lkIjoiNWZjYTBiNGFhNmE2YzE4ZDc2MTU4ODZjIiwiZGlzcGxheU5hbWUiOiJqb2hud2ljazIifSwic3ViIjoiNjE4MmVhYWVmYTJmN2UyYzZiNzI4YjQ4IiwiaXNzIjoiaHR0cHM6Ly9hcGkuYW1pdHkuY28iLCJpYXQiOjE2NjExNzIzMjIsImV4cCI6MTY5MjcyOTkyMn0.31c2IW6mZmPyBa6ryJ7AOQpe9vr7ojTUY4v7mpV9F6EAiDTymTXfGlrxJJHIqnxsLde_YPbf-g2Vq6nsvpQ1poP1cf_AqjITz4r2qv9w8x3gi-93nrmgr9CZtFEUdj-Cb89snsu-WTW1-SRzkFbo5ovgiUii42CHfK_GYATngThshHjbZF4slg2UBG72ZREaucnMJmUmL1z-UI0n4A-QiQrgP21TCxsCOY06KKKDgZlZoTuzxmtMWCdykf6b35NUWd-wrE7h9BI05lt3TGCj92gMNpiEdV_CeHddDOgTCrAcodmv2tp2_QkA7zKbtFYKVlyLwfUxU4RdoaFLPjiCxQ";
    await channelRepoImp.initRepo(accessToken);
    await channelRepoImp.listenToChannel((messages) {
      ///get channel where channel id == new message channelId
      var channel = _amityChannelList.firstWhere((amityMessage) =>
          amityMessage.channelId == messages.messages?[0].channelId);
      print(
          "${channel.channelId} got new message from ${messages.messages![0].userId}");
      channel.lastActivity = messages.messages![0].createdAt;
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

    await channelRepoImp.listenToChannelList((channel) {
      _amityChannelList.insert(0, channel);
      notifyListeners();
    });

    await channelRepoImp.fetchChannels((data, error) {
      if (error == null && data != null) {
        _amityChannelList.clear();

        _addUnreadCountToEachChannel(data);

        if (data.channels != null) {
          for (var channel in data.channels!) {
            _amityChannelList.add(channel);
            String key =
                channel.channelId! + AmityCoreClient.getCurrentUser().userId!;
            if (channelUserMap[key] != null) {
              var count =
                  channel.messageCount! - channelUserMap[key]!.readToSegment!;
              channel.setUnreadCount(count);
            }
          }
        }
      } else {
        print(error);
      }

      notifyListeners();
    });
  }

  Future<void> createGroupChannel(String displayName, List<String> userIds,
      Function(ChannelList? data, String? error) callback,
      {String? avatarFileId}) async {
    await channelRepoImp.createGroupChannel(displayName, userIds,
        (data, error) {
      if (data != null) {
        print("createGroupChannel: success");
        callback(data, null);
      } else {
        print(error);
        callback(null, error);
      }
    }, avatarFileId: avatarFileId);
  }

  createConversationChannel(List<String> userIds,
      Function(ChannelList? data, String? error) callback) async {
    await channelRepoImp.createConversationChannel(userIds, (data, error) {
      if (data != null) {
        print("createConversationChannel: success ${data}");
       
        callback(data, null);
        
      } else {
        print(error);
        callback(null, error);
      }
    });
  }

  void _addUnreadCountToEachChannel(ChannelList data) {
    for (var channelUser in data.channelUsers!) {
      channelUserMap[channelUser.channelId! + channelUser.userId!] =
          channelUser;
    }
    print("mapReadSegment complete");
  }

  void removeUnreadCount(String channelId) {
    ///get channel where channel id == new message channelId

    try {
      if (_amityChannelList.length > 0) {
        var channel = _amityChannelList
            .firstWhere((amityMessage) => amityMessage.channelId == channelId);

        ///set unread count = 0
        channel.setUnreadCount(0);

        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }
}
