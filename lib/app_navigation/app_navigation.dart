import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_config/app_config.dart';
import 'package:verbose_share_world/components/custom_drawer.dart';
import 'package:verbose_share_world/app_navigation/chat/chats_page.dart';
import 'package:verbose_share_world/app_navigation/home/home_page.dart';
import 'package:verbose_share_world/app_navigation/notification/notification_page.dart';
import 'package:verbose_share_world/app_navigation/story/story_page.dart';
import 'package:verbose_share_world/generated/l10n.dart';

import '../components/custom_user_avatar.dart';
import '../provider/ViewModel/feed_viewmodel.dart';
import 'home/community_feed.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _children = [
    HomePage(),
    CommunityScreen(community: AmityCommunity(),),
    StoryPage(),
    NotificationPage(),
    ChatsPage(),
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
        FontAwesomeIcons.video,
        size: 20,
      ),
      label: 'Video',
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
      S.of(context).stories,
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              child: FadedScaleAnimation(
                child: CircleAvatar(
                  backgroundImage: getAvatarImage(
                      AmityCoreClient.getCurrentUser().avatarUrl),
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
