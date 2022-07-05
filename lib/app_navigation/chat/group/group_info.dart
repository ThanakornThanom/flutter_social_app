import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class GroupInfoScreen extends StatefulWidget {
  @override
  _GroupInfoScreenState createState() => _GroupInfoScreenState();
}

class GroupItems {
  String image;
  String name;

  GroupItems(this.image, this.name);
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  bool _muteNotiVal = true;

  @override
  Widget build(BuildContext context) {
    List<GroupItems> _groupItems = [
      GroupItems('assets/images/Layer949.png', 'Emili'),
      GroupItems('assets/images/Layer946.png', 'Harsh'),
      GroupItems('assets/images/Layer946.png', 'David'),
      GroupItems('assets/images/Layer948.png', 'Whie'),
      GroupItems('assets/images/Layer949.png', 'Marie'),
      GroupItems('assets/images/Layer949.png', 'Marie'),
    ];
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      backgroundColor: ApplicationColors.white,
      title: Text(S.of(context).groupInfo,
          style: theme.textTheme.headline6!.copyWith(
            fontWeight: FontWeight.w500,
          )),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            S.of(context).edit,
            style: theme.textTheme.button!.copyWith(color: theme.primaryColor),
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
          height: bheight,
          width: mediaQuery.size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadedScaleAnimation(
                  child: Container(
                    height: bheight * 0.15,
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child:
                        Image.asset('assets/images/profile_pics/Layer1550.png'),
                  ),
                ),
                Container(
                  height: bheight * 0.15,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          S.of(context).awesomeFriends,
                          style: theme.textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          S.of(context).hangoutFriendsGroup,
                          style: theme.textTheme.headline6!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ApplicationColors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: ApplicationColors.grey[350],
                  thickness: 2,
                ),
                Container(
                  height: bheight * 0.05,
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).muteNotification,
                        style: theme.textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                      Spacer(),
                      CupertinoSwitch(
                        value: _muteNotiVal,
                        onChanged: (val) {
                          setState(() {
                            _muteNotiVal = val;
                          });
                        },
                        activeColor: theme.primaryColor,
                      )
                    ],
                  ),
                ),
                Divider(
                  color: ApplicationColors.grey[350],
                  thickness: 2,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            left: 20, bottom: 10, right: 10, top: 12),
                        child: Text(
                          S.of(context).mediaShared,
                          style: theme.textTheme.bodyText1!.copyWith(
                              color: ApplicationColors.grey[400], fontSize: 12),
                        ),
                      ),
                      Container(
                        width: mediaQuery.size.width,
                        margin: EdgeInsets.fromLTRB(20, 0, 10, 20),
                        height: 70,
                        child: Row(
                          children: [
                            Image.asset('assets/images/Layer971.png'),
                            SizedBox(width: 1),
                            Image.asset('assets/images/Layer971.png'),
                            SizedBox(width: 1),
                            Image.asset('assets/images/Layer971.png'),
                            SizedBox(width: 1),
                            Image.asset('assets/images/Layer971.png'),
                            SizedBox(width: 1),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Layer971.png',
                                  color: theme.primaryColor,
                                  colorBlendMode: BlendMode.hardLight,
                                ),
                                Text(
                                  S.of(context).viewAll,
                                  style: TextStyle(
                                    color: ApplicationColors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: ApplicationColors.grey[350],
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Members in group (06)',
                    style: theme.textTheme.bodyText1!.copyWith(
                        color: ApplicationColors.grey[600], fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: bheight * 0.4,
                  child: ListView.builder(
                    itemCount: _groupItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              _groupItems[index].image,
                              fit: BoxFit.fill,
                            )),
                        title: Text(
                          _groupItems[index].name,
                          style: theme.textTheme.subtitle2!.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          S.of(context).iamaronsmith,
                          style: theme.textTheme.subtitle2!.copyWith(
                            color: theme.hintColor,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.primaryColor,
        child: Icon(
          Icons.add,
          color: theme.iconTheme.color,
        ),
      ),
    );
  }
}
