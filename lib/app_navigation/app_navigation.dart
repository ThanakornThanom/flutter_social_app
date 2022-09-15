import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:amity_uikit_beta_service/components/custom_user_avatar.dart';
import 'package:amity_uikit_beta_service/view/chat/chat_friend_tab.dart';
import 'package:amity_uikit_beta_service/view/social/community_tabbar.dart';
import 'package:amity_uikit_beta_service/view/social/home_following_screen.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:verbose_share_world/app_config/app_config.dart';
import 'package:verbose_share_world/components/custom_drawer.dart';

import 'package:verbose_share_world/app_navigation/notification/notification_page.dart';

import 'package:verbose_share_world/generated/l10n.dart';

import '../components/custom_user_avatar.dart';
import 'home.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _children = [
    HomePage(),

    // CommunityScreen(community: AmityCommunity(),),
    CommunityTabbar(),
    NotificationPage(),
    AmitySLEChannelScreen()
  ];

  void changeLanguage(String langCode) {
    setState(() {
      S.load(Locale(langCode, ''));
    });
  }

  final List<BottomNavigationBarItem> _bottomBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(
        FontAwesomeIcons.bars,
        size: 20,
      ),
      label: 'Explore',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Noti',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(
        FontAwesomeIcons.comments,
        size: 20,
      ),
      label: 'Chat',
    ),
  ];

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _titles = [
      AppConfig.appName,
      "Explore",
      S.of(context).video,
      S.of(context).notifications,
      S.of(context).chats,
    ];

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 24),
        ),
        actions: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: Container(
                  child: FadedScaleAnimation(
                      child: getAvatarImage(
                          AmitySLEUIKit().getCurrentUser().avatarUrl,
                          radius: 25)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        children: _children,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        unselectedItemColor: Theme.of(context).disabledColor,
        items: _bottomBarItems,
        onTap: onTap,
      ),
    );
  }
}
