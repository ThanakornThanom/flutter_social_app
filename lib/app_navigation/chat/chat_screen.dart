import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_list_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_viewmodel.dart';

import '../../components/custom_user_avatar.dart';
import '../../provider/model/amity_channel_model.dart';
import '../../provider/model/amity_message_model.dart';

class ChatSingleScreen extends StatelessWidget {
  final Channels channel;

  const ChatSingleScreen({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      elevation: 0,
      backgroundColor: ApplicationColors.white,
      leadingWidth: 0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.chevron_left, color: Colors.black, size: 35)),
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: FadedScaleAnimation(
                child: getAvatarImage(null, fileId: channel.avatarFileId),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                child: Text(
                  channel.displayName ?? "N/A",
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headline6!.copyWith(
                    fontSize: 16.7,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;

    final textfielHeight = 60.0;
    return Scaffold(
      backgroundColor: ApplicationColors.white,
      appBar: myAppBar,
      body: SafeArea(
        child: Stack(
          children: [
            FadedSlideAnimation(
              child: SingleChildScrollView(
                reverse: true,
                controller: Provider.of<MessageVM>(context, listen: false)
                    .scrollController,
                child: MessageComponent(
                  bheight: bHeight - textfielHeight,
                  theme: theme,
                  mediaQuery: mediaQuery,
                  channelId: channel.channelId!,
                  channel: channel,
                ),
              ),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ChatTextFieldComponent(
                    theme: theme,
                    textfielHeight: textfielHeight,
                    mediaQuery: mediaQuery),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTextFieldComponent extends StatelessWidget {
  const ChatTextFieldComponent({
    Key? key,
    required this.theme,
    required this.textfielHeight,
    required this.mediaQuery,
  }) : super(key: key);

  final ThemeData theme;
  final double textfielHeight;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: theme.canvasColor,
          border: Border(top: BorderSide(color: theme.highlightColor))),
      height: textfielHeight,
      width: mediaQuery.size.width,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          // SizedBox(
          //   width: 5,
          // ),
          // Icon(
          //   Icons.emoji_emotions_outlined,
          //   color: theme.primaryIconTheme.color,
          //   size: 22,
          // ),
          SizedBox(width: 10),
          Container(
            width: mediaQuery.size.width * 0.7,
            child: TextField(
              controller: Provider.of<MessageVM>(context, listen: false)
                  .textEditingController,
              decoration: InputDecoration(
                hintText: S.of(context).writeYourMessage,
                hintStyle: TextStyle(fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              Provider.of<MessageVM>(context, listen: false).sendMessage();
            },
            child: Icon(
              Icons.send,
              color: theme.primaryColor,
              size: 22,
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}

class MessageComponent extends StatefulWidget {
  const MessageComponent({
    Key? key,
    required this.theme,
    required this.mediaQuery,
    required this.channelId,
    required this.bheight,
    required this.channel,
  }) : super(key: key);
  final String channelId;
  final Channels channel;

  final ThemeData theme;

  final MediaQueryData mediaQuery;

  final double bheight;

  @override
  State<MessageComponent> createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  @override
  void initState() {
    Provider.of<MessageVM>(context, listen: false)
        .initVM(widget.channelId, widget.channel);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getTimeStamp(Messages msg) {
    String hour = "${DateTime.parse(msg.editedAt!).hour.toString()}";
    String minute = "";
    if (DateTime.parse(msg.editedAt!).minute > 9) {
      minute = DateTime.parse(msg.editedAt!).minute.toString();
    } else {
      minute = "0" + DateTime.parse(msg.editedAt!).minute.toString();
    }
    return hour + ":" + minute;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageVM>(builder: (context, vm, _) {
      return vm.amityMessageList == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: widget.theme.highlightColor,
                        color: widget.theme.hintColor,
                      )
                    ],
                  ),
                )
              ],
            )
          : Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: vm.amityMessageList?.length,
                itemBuilder: (context, index) {
                  var data = vm.amityMessageList![index].data;
                  print(data!.text);
                  bool isSendbyCurrentUser =
                      vm.amityMessageList?[index].userId !=
                          AmityCoreClient.getCurrentUser().userId;
                  return Column(
                    crossAxisAlignment: isSendbyCurrentUser
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: isSendbyCurrentUser
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          if (!isSendbyCurrentUser)
                            Container(
                              child: Text(
                                getTimeStamp(vm.amityMessageList![index]),
                                style: TextStyle(
                                    color: ApplicationColors.grey, fontSize: 8),
                              ),
                            ),
                          vm.amityMessageList![index].data!.text == null
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(10, 4, 10, 4),
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red),
                                  child: Text("Unsupport type message😰",
                                      style: TextStyle(color: Colors.white)),
                                )
                              : Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            widget.mediaQuery.size.width * 0.7),
                                    margin: EdgeInsets.fromLTRB(10, 4, 10, 4),
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isSendbyCurrentUser
                                          ? ApplicationColors.lightGrey
                                          : widget.theme.primaryColor,
                                    ),
                                    child: Text(
                                      vm.amityMessageList?[index].data!.text ??
                                          "N/A",
                                      style: widget.theme.textTheme.bodyText1!
                                          .copyWith(
                                              fontSize: 14.7,
                                              color: isSendbyCurrentUser
                                                  ? ApplicationColors.black
                                                  : ApplicationColors.white),
                                    ),
                                  ),
                                ),
                          if (isSendbyCurrentUser)
                            Container(
                              child: Text(
                                getTimeStamp(vm.amityMessageList![index]),
                                style: TextStyle(
                                    color: ApplicationColors.lightGrey500,
                                    fontSize: 8),
                              ),
                            ),
                        ],
                      ),
                      if (index + 1 == vm.amityMessageList?.length)
                        SizedBox(
                          height: 90,
                        )
                    ],
                  );
                },
              ),
            );
    });
  }
}
