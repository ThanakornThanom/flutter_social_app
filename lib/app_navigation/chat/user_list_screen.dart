import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/comments.dart';
import 'package:verbose_share_world/app_navigation/home/community_feed.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';

import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/user_viewmodel.dart';
import 'package:verbose_share_world/provider/model/amity_channel_model.dart';

import '../../generated/l10n.dart';
import '../../provider/ViewModel/category_viewmodel.dart';
import '../../provider/ViewModel/chat_viewmodel/channel_list_viewmodel.dart';
import '../../provider/ViewModel/chat_viewmodel/channel_viewmodel.dart';
import '../../provider/ViewModel/community_viewmodel.dart';

import 'chat_screen.dart';
import 'create_group_chat_screen.dart';

class UserList extends StatefulWidget {
  UserList(Key key);
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // community = widget.community;
    Future.delayed(Duration.zero, () {
      Provider.of<UserVM>(context, listen: false).getUsers();
    });
  }

  int getLength() {
    if (Provider.of<UserVM>(context, listen: false).getUserList().isEmpty)
      return 0;
    int length =
        Provider.of<UserVM>(context, listen: false).getUserList().length;
    print("check length of user list ${length}");
    return length;
  }

  int getSelectedLength() {
    if (Provider.of<UserVM>(context, listen: false).selectedUserList.isEmpty)
      return 0;
    int length =
        Provider.of<UserVM>(context, listen: false).selectedUserList.length;

    return length;
  }

  void onNextTap() async {
    if (getSelectedLength() > 1) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateChatGroup(
          key: UniqueKey(),
          userIds: Provider.of<UserVM>(context, listen: false).selectedUserList,
        ),
      ));
    } else {
      Provider.of<ChannelVM>(context, listen: false).createConversationChannel([
        AmityCoreClient.getUserId(),
        Provider.of<UserVM>(context, listen: false).selectedUserList[0]
      ], (channel, error) {
        Provider.of<UserVM>(context, listen: false).clearSelectedUser();
        if (channel != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                    create: (context) => MessageVM(),
                    child: ChatSingleScreen(
                      key: UniqueKey(),
                      channel: channel.channels![0],
                    ),
                  )));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        AppBar().preferredSize.height;

    final theme = Theme.of(context);
    return Consumer<UserVM>(builder: (context, vm, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Select Users", style: TextStyle(color: Colors.black)),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left, color: Colors.black, size: 35),
          ),
          actions: [
            getSelectedLength() > 0
                ? TextButton(
                    onPressed: () {
                      onNextTap();
                    },
                    child: Text(getSelectedLength() > 1 ? "Next" : "Create"))
                : Container()
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: bHeight,

                  // color: ApplicationColors.lightGrey,
                  child: FadedSlideAnimation(
                    child: Column(
                      children: [
                        getLength() < 1
                            ? Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: theme.primaryColor),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  // shrinkWrap: true,
                                  itemCount: getLength(),
                                  itemBuilder: (context, index) {
                                    return UserWidget(
                                      theme: theme,
                                      index: index,
                                      user: Provider.of<UserVM>(context,
                                              listen: false)
                                          .getUserList()[index],
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                    beginOffset: Offset(0, 0.3),
                    endOffset: Offset(0, 0),
                    slideCurve: Curves.linearToEaseOut,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class UserWidget extends StatelessWidget {
  UserWidget(
      {Key? key, required this.user, required this.theme, required this.index})
      : super(key: key);

  final ThemeData theme;
  final AmityUser user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              onTap: () {
                Provider.of<UserVM>(context, listen: false).setSelectedUserList(
                    Provider.of<UserVM>(context, listen: false)
                        .getUserList()[index]
                        .userId!);
                print(
                    "click index ${index} ${Provider.of<UserVM>(context, listen: false).selectedUserList}");
              },
              leading: FadeAnimation(
                child: (user.avatarUrl != null)
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: (NetworkImage(user.avatarUrl!)))
                    : CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/user_placeholder.png")),
              ),
              title: Text(
                user.displayName ?? "Category",
                style: theme.textTheme.bodyText1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Provider.of<UserVM>(context, listen: true)
                      .checkIfSelected(
                          Provider.of<UserVM>(context, listen: false)
                              .getUserList()[index]
                              .userId!)
                  ? Icon(
                      Icons.check_rounded,
                      color: theme.primaryColor,
                    )
                  : null,
            ),
            Divider(
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
