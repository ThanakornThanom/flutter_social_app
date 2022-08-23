import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_list_viewmodel.dart';
import 'package:verbose_share_world/provider/model/amity_message_model.dart';
import 'package:verbose_share_world/repository/chat_repo_imp.dart';

import '../../../utils/navigation_key.dart';
import '../../model/amity_channel_model.dart';
import '../user_viewmodel.dart';

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
  Future<void> initVM(String channelId, Channels channel) async {
    this.channelId = channelId;
    this.isChatLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });

    print("initVM");
    var accessToken = Provider.of<UserVM>(
            NavigationService.navigatorKey.currentContext!,
            listen: false)
        .accessToken;

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
