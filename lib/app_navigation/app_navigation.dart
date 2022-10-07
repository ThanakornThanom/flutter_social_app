import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:amity_uikit_beta_service/view/notification/notification_all_tab.dart';
import 'package:amity_uikit_beta_service/view/notification/notification_page.dart';

import 'package:amity_uikit_beta_service/view/social/community_tabbar.dart';

import 'package:amity_uikit_beta_service/view/user/user_profile.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:verbose_share_world/app_config/app_config.dart';
import 'package:verbose_share_world/components/custom_drawer.dart';

import 'package:verbose_share_world/generated/l10n.dart';

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
    // AmitySLEChannelScreen()
    UserProfileScreen(
      amityUser: AmitySLEUIKit().getCurrentUser(),
      isEnableAppbar: false,
    )
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
      label: 'Notification',
    ),
    // BottomNavigationBarItem(
    //   icon: FaIcon(
    //     FontAwesomeIcons.comments,
    //     size: 20,
    //   ),
    //   label: 'Chat',
    // ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
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
      // S.of(context).video,
      S.of(context).notifications,
      // S.of(context).chats,
      "My Profile"
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
                child: Icon(
                  Icons.settings,
                  color: Colors.black,
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
