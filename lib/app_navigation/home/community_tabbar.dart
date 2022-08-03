import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_navigation/home/community_list.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/app_navigation/home/home_floatin_action_button.dart';
import 'package:verbose_share_world/app_navigation/home/home_following_screen.dart';
import 'package:verbose_share_world/generated/l10n.dart';

import '../../provider/ViewModel/community_viewmodel.dart';

class CommunityTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: ApplicationColors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: "Recommend"),
            Tab(text: "Trending"),
            Tab(text: "My"),
          ],
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            CommunityList(CommunityListType.recommend),
            CommunityList(CommunityListType.trending),
            CommunityList(CommunityListType.my),
          ],
        ),
      ),
    );
  }
}
