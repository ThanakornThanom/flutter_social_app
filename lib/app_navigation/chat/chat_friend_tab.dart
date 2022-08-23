import 'dart:math';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/chat/chat_screen.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_list_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_viewmodel.dart';

import '../../components/custom_user_avatar.dart';

class ChatItems {
  String image;
  String name;

  ChatItems(this.image, this.name);
}

class ChatFriendTabScreen extends StatefulWidget {
  @override
  _ChatFriendTabScreenState createState() => _ChatFriendTabScreenState();
}

class _ChatFriendTabScreenState extends State<ChatFriendTabScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ChannelVM>(context, listen: false).initVM();
    });
    super.initState();
  }

  int getLength(ChannelVM vm) {
    print(
        "check channel list length ${vm.getChannelList().length > 0 ? vm.getChannelList()[0] : ""}");
    return vm.getChannelList().length;
  }

  String getDateTime(String dateTime) {
    var convertedTimestamp =
        DateTime.parse(dateTime); // Converting into [DateTime] object
    var result = GetTimeAgo.parse(
      convertedTimestamp,
    );

    if (result == "0 seconds ago") {
      return "just now";
    } else {
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ChannelVM>(builder: (context, vm, _) {
      return Scaffold(
        body: FadedSlideAnimation(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: getLength(vm),
              itemBuilder: (context, index) {
                var messageCount = vm.getChannelList()[index].unreadCount;

                bool _rand = messageCount > 0 ? true : false;
                // if ((Random().nextInt(10)) % 2 == 0) {
                //   _rand = true;
                // } else {
                //   _rand = false;
                // }
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (context) => MessageVM(),
                                child: ChatSingleScreen(
                                  key: UniqueKey(),
                                  channel: vm.getChannelList()[index],
                                ),
                              )));
                    },
                    leading: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: FadedScaleAnimation(
                            child: getAvatarImage(null,
                                fileId:
                                    vm.getChannelList()[index].avatarFileId),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: _rand
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.fromLTRB(4, 0, 4, 2),
                                  child: Center(
                                    child: Text(
                                      vm
                                          .getChannelList()[index]
                                          .unreadCount
                                          .toString(),
                                      style: theme.textTheme.bodyText1!
                                          .copyWith(
                                              color: ApplicationColors.white,
                                              fontSize: 8),
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                    title: Text(
                      vm.getChannelList()[index].displayName ?? "Display name",
                      style: TextStyle(
                        color: _rand
                            ? theme.primaryColor
                            : ApplicationColors.black,
                        fontSize: 13.3,
                      ),
                    ),
                    subtitle: Text(
                      S.of(context).yesThatWasAwesome,
                      style: theme.textTheme.subtitle2!.copyWith(
                        color: theme.hintColor,
                        fontSize: 10.7,
                      ),
                    ),
                    trailing: Text(
                      (vm.getChannelList()[index].lastActivity == null)
                          ? ""
                          : getDateTime(
                              vm.getChannelList()[index].lastActivity!),
                      style: theme.textTheme.bodyText1!.copyWith(
                          color: ApplicationColors.grey, fontSize: 9.3),
                    ),
                  ),
                );
              },
            ),
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'chat',
          child: Icon(Icons.person_add),
          backgroundColor: theme.primaryColor,
          onPressed: () {},
        ),
      );
    });
  }
}
