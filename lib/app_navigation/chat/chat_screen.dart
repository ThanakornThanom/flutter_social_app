import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_viewmodel.dart';

class ChatSingleScreen extends StatelessWidget {
  final String channelId;

  const ChatSingleScreen({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      elevation: 0,
      backgroundColor: ApplicationColors.white,
      title: Transform(
        transform: Matrix4.translationValues(-25, 6, 0),
        child: Row(
          children: [
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: FadedScaleAnimation(
                child: Image.asset(
                  'assets/images/profile_pics/Layer1804.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              S.of(context).kevinTaylor,
              style: theme.textTheme.headline6!.copyWith(
                fontSize: 16.7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.chevron_left),
      ),
    );
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    return Scaffold(
      backgroundColor: ApplicationColors.white,
      appBar: myAppBar,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: theme.canvasColor,
                child: FadedSlideAnimation(
                  child: SingleChildScrollView(
                    reverse: true,
                    controller: Provider.of<MessageVM>(context, listen: false)
                        .scrollController,
                    child: MessageComponent(
                      theme: theme,
                      mediaQuery: mediaQuery,
                      channelId: channelId,
                    ),
                  ),
                  beginOffset: Offset(0, 0.3),
                  endOffset: Offset(0, 0),
                  slideCurve: Curves.linearToEaseOut,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme.highlightColor))),
              height: 60,
              width: mediaQuery.size.width,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: theme.primaryIconTheme.color,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: mediaQuery.size.width * 0.7,
                    child: TextField(
                      controller: Provider.of<MessageVM>(context, listen: false)
                          .textEditingController,
                      decoration: InputDecoration(
                        hintText: S.of(context).writeYourComment,
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      Provider.of<MessageVM>(context, listen: false)
                          .sendMessage();
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
            ),
          ],
        ),
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
  }) : super(key: key);
  final String channelId;

  final ThemeData theme;

  final MediaQueryData mediaQuery;

  @override
  State<MessageComponent> createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  @override
  void initState() {
    Provider.of<MessageVM>(context, listen: false).initVM(widget.channelId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageVM>(builder: (context, vm, _) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: vm.amityMessageList.length,
          itemBuilder: (context, index) {
            bool issSendbyCurrentUser = vm.amityMessageList[index].userId !=
                AmityCoreClient.getCurrentUser().userId;
            return Column(
              crossAxisAlignment: issSendbyCurrentUser
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: issSendbyCurrentUser
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    if (!issSendbyCurrentUser)
                      Container(
                        child: Text(
                          S.of(context).am1207,
                          style: TextStyle(
                              color: ApplicationColors.lightGrey300,
                              fontSize: 8),
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 4, 10, 4),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: issSendbyCurrentUser
                            ? ApplicationColors.lightGrey
                            : widget.theme.primaryColor,
                      ),
                      // width: mediaQuery.size.width * 0.7,
                      width: vm.amityMessageList[index].data!.text!.length *
                                  10.0 >=
                              widget.mediaQuery.size.width * 0.7
                          ? widget.mediaQuery.size.width * 0.7
                          : null,
                      alignment: issSendbyCurrentUser
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        vm.amityMessageList[index].data!.text ?? "N/A",
                        style: widget.theme.textTheme.bodyText1!.copyWith(
                            fontSize: 14.7,
                            color: issSendbyCurrentUser
                                ? ApplicationColors.black
                                : ApplicationColors.white),
                      ),
                    ),
                    if (issSendbyCurrentUser)
                      Container(
                        child: Text(
                          S.of(context).am1207,
                          style: TextStyle(
                              color: ApplicationColors.lightGrey300,
                              fontSize: 8),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
