import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_list_viewmodel.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/repository/chat_repo_imp.dart';

import '../../../utils/navigation_key.dart';
import '../../model/amity_channel_model.dart';

class MessageVM extends ChangeNotifier {
  //asd
  TextEditingController textEditingController = TextEditingController();
  ScrollController? scrollController =
      ScrollController(keepScrollOffset: false);
  AmityChatRepoImp channelRepoImp = AmityChatRepoImp();
  List<Messages>? amityMessageList;
  bool isChatLoading = true;
  late String channelId;
  bool ispaginationLoading = false;

  ///init
  Future<void> initVM(String channelId, Channels channel, String token) async {
    this.channelId = channelId;
    this.isChatLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });

    print("initVM");
    String accessToken =
        "eyJhbGciOiJSUzI1NiIsImtpZCI6IkdTLWNDSUFib1IyQUhfQXczY29Bb0VtR1ZkdzFfaWxjc09BWGx6OXBoSFkifQ.eyJ1c2VyIjp7InJlZnJlc2hUb2tlbiI6Ijg1NGQ1MmFkZDhjMmJlNmJiY2IyZGVhMmI4ZThhOTBjYWZhNDUwY2QzZmExOGQxNjNhNTkwYzFiOGVkNmExZDMxYTZiODY2ZTQ1ZGRmYmE4IiwidXNlcklkIjoiNjE4MmVhYWVmYTJmN2UyYzZiNzI4YjQ4IiwicHVibGljVXNlcklkIjoiam9obndpY2syIiwibmV0d29ya0lkIjoiNWZjYTBiNGFhNmE2YzE4ZDc2MTU4ODZjIiwiZGlzcGxheU5hbWUiOiJqb2hud2ljazIifSwic3ViIjoiNjE4MmVhYWVmYTJmN2UyYzZiNzI4YjQ4IiwiaXNzIjoiaHR0cHM6Ly9hcGkuYW1pdHkuY28iLCJpYXQiOjE2NjExNzIzMjIsImV4cCI6MTY5MjcyOTkyMn0.31c2IW6mZmPyBa6ryJ7AOQpe9vr7ojTUY4v7mpV9F6EAiDTymTXfGlrxJJHIqnxsLde_YPbf-g2Vq6nsvpQ1poP1cf_AqjITz4r2qv9w8x3gi-93nrmgr9CZtFEUdj-Cb89snsu-WTW1-SRzkFbo5ovgiUii42CHfK_GYATngThshHjbZF4slg2UBG72ZREaucnMJmUmL1z-UI0n4A-QiQrgP21TCxsCOY06KKKDgZlZoTuzxmtMWCdykf6b35NUWd-wrE7h9BI05lt3TGCj92gMNpiEdV_CeHddDOgTCrAcodmv2tp2_QkA7zKbtFYKVlyLwfUxU4RdoaFLPjiCxQ";
    await channelRepoImp.initRepo(accessToken);
    channelRepoImp.listenToChannel((messages) async {
      print(messages.messages![0].channelId);
      print(channelId);
      if (messages.messages?[0].channelId == channelId) {
        print("get new messgae...: ${messages.messages?[0].data?.text}");
        amityMessageList?.add(messages.messages!.first);
        channel.messageCount = channel.messageCount! + 1;
        channel.setUnreadCount(channel.unreadCount - 1);
        if (messages.messages?[0].userId ==
            AmityCoreClient.getCurrentUser().userId) {
          scrollToBottom();
        }
      }

      notifyListeners();
    });

    channelRepoImp.fetchChannelById(
        channelId: channelId,
        callback: (data, error) async {
          if (error == null) {
            notifyListeners();
            scrollController?.addListener(() async {
              if (!ispaginationLoading) {
                var currentMessageCount = amityMessageList!.length;
                var totalMessageCount = channel.messageCount!;

                if ((scrollController!.position.pixels ==
                        (scrollController!.position.maxScrollExtent)) &&
                    (currentMessageCount < totalMessageCount)) {
                  ispaginationLoading = true;

                  print("ispaginationLoading = false");
                  var token = data!.paging!.previous;
                  print(token);
                  print("minScrollExtent");
                  await channelRepoImp.fetchChannelById(
                    channelId: channelId,
                    paginationToken: token,
                    callback: (pagingData, error) {
                      if (error == null) {
                        print("paging data: $pagingData");

                        if (pagingData!.paging!.previous == null) {
                          scrollController!.removeListener(() {
                            removeListener(() {
                              print("remove listener");
                            });
                          });
                        } else {
                          data.paging!.previous = pagingData.paging!.previous;
                        }

                        var reversedMessage = pagingData.messages!.reversed;
                        for (var message in reversedMessage) {
                          print(message.data!.text);
                          amityMessageList?.insert(0, message);
                        }
                        notifyListeners();
                        ispaginationLoading = false;
                      } else {
                        ispaginationLoading = false;
                        print(error);
                      }
                    },
                  );
                } else {
                  print(
                      "pagination is not ready: $currentMessageCount/$totalMessageCount");
                }
              }
            });
            amityMessageList = [];
            print("success");
            amityMessageList?.clear();
            for (var message in data!.messages!) {
              amityMessageList?.add(message);
            }
            scrollToBottom();

            channelRepoImp.startReading(
              channelId,
              callback: (data, error) {
                if (error == null) {
                  print("set unread count = 0");
                  Provider.of<ChannelVM>(
                          NavigationService.navigatorKey.currentContext!,
                          listen: false)
                      .removeUnreadCount(channelId);
                }
              },
            );

            notifyListeners();
          } else {
            print(error);
          }
        });
  }

  Future<void> sendMessage() async {
    String text = textEditingController.text;
    textEditingController.clear();
    channelRepoImp.sendTextMessage(channelId, text, (data, error) {
      if (data != null) {
        print("sendMessage: success");
      } else {
        print(error);
      }
    });
  }

  void scrollToBottom() {
    print("scrollToBottom ");
    // scrollController!.animateTo(
    //   1000000,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 500),
    // );
    scrollController?.jumpTo(0);
  }

  @override
  Future<void> dispose() async {
    await channelRepoImp.stopReading(channelId);

    channelRepoImp.disposeRepo();
    scrollController = null;
    amityMessageList?.clear();
    super.dispose();
  }
}
