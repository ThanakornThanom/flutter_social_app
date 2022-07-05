import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';

import 'group_chat_screen.dart';

class GroupInfoEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      backgroundColor: ApplicationColors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left),
      ),
      title: Text(
        S.of(context).groupInfo,
        style: theme.textTheme.headline6,
      ),
    );
    return Scaffold(
      backgroundColor: ApplicationColors.white,
      appBar: myAppBar,
      body: FadedSlideAnimation(
        child: Container(
          width: mediaQuery.size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ApplicationColors.lightGrey,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: ApplicationColors.grey,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 30),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: S.of(context).addGroupName,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Divider(
                color: ApplicationColors.lightGrey,
                thickness: 2,
              ),
              Container(
                alignment: Alignment.center,
                height: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: S.of(context).addABriefDescription,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                child: Container(color: ApplicationColors.lightGrey),
              ),
              Container(
                color: ApplicationColors.lightGrey,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => GroupChatScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: theme.primaryColor,
                    ),
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      S.of(context).createGroup,
                      style: theme.textTheme.button,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
