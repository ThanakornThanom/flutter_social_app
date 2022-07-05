import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class ChatSingleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> messages = [
      S.of(context).helloThere,
      S.of(context).howYouDoing,
      S.of(context).heyWassup,
      S.of(context).isntThisAppAmazing,
      S.of(context).itsSoCoolThatICanChatWithMyFriends
    ];
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
      body: FadedSlideAnimation(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: bHeight - 60,
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: index % 2 == 0
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: index % 2 == 0
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            if (index % 2 == 1)
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
                                color: index % 2 == 0
                                    ? ApplicationColors.lightGrey
                                    : theme.primaryColor,
                              ),
                              // width: mediaQuery.size.width * 0.7,
                              width: messages[index % messages.length].length *
                                          10.0 >=
                                      mediaQuery.size.width * 0.7
                                  ? mediaQuery.size.width * 0.7
                                  : messages[index % messages.length].length *
                                      10.0,
                              alignment: index % 2 == 0
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Text(
                                messages[index % messages.length],
                                style: theme.textTheme.bodyText1!.copyWith(
                                    fontSize: 14.7,
                                    color: index % 2 == 0
                                        ? ApplicationColors.black
                                        : ApplicationColors.white),
                              ),
                            ),
                            if (index % 2 == 0)
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
              ),
              Container(
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
                        decoration: InputDecoration(
                          hintText: S.of(context).writeYourComment,
                          hintStyle: TextStyle(fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.send,
                      color: theme.primaryColor,
                      size: 22,
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
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
