import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';

import '../components/custom_user_avatar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      title: Text(
        S.of(context).my_Profile,
        style: theme.textTheme.headline6,
      ),
      backgroundColor: ApplicationColors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left),
      ),
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () {
            Phoenix.rebirth(context);
          },
          child: Text(
            S.of(context).logout,
            style: theme.textTheme.button!.copyWith(
                color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    return Scaffold(
      appBar: myAppBar,
      body: FadedSlideAnimation(
        child: Container(
          color: ApplicationColors.white,
          height: bheight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      FadedScaleAnimation(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: getAvatarImage(
                              AmityCoreClient.getCurrentUser().avatarUrl),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 7,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.primaryColor,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                      alignment: Alignment.centerLeft,
                      color: ApplicationColors.lightGrey,
                      width: double.infinity,
                      child: Text(
                        S.of(context).profile_Info,
                        style: theme.textTheme.headline6!.copyWith(
                          color: Colors.grey,
                          fontSize: ApplicationColors.fontSize16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextField(
                        controller: TextEditingController(
                            text: S.of(context).samanthaSmith),
                        decoration: InputDecoration(
                          labelText: S.of(context).Full_name,
                          alignLabelWithHint: false,
                          border: InputBorder.none,
                          labelStyle: TextStyle(height: 1),
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: TextEditingController(
                            text: S.of(context).samanthasmith),
                        decoration: InputDecoration(
                          labelText: S.of(context).username,
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller:
                            TextEditingController(text: '+1 9876543210'),
                        decoration: InputDecoration(
                          labelText: S.of(context).phoneNumber,
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: TextEditingController(
                            text: S.of(context).samanthasmithmailcom),
                        decoration: InputDecoration(
                          labelText: S.of(context).emailAddress,
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller:
                            TextEditingController(text: S.of(context).female),
                        decoration: InputDecoration(
                          labelText: S.of(context).gender,
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
