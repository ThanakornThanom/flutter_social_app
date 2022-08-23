import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/repository/chat_repo_imp.dart';

import '../../../utils/navigation_key.dart';
import '../../model/amity_channel_model.dart';
import '../user_viewmodel.dart';

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
    var accessToken = Provider.of<UserVM>(
            NavigationService.navigatorKey.currentContext!,
            listen: false)
        .accessToken;

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
