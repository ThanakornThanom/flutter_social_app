import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/app_navigation/home/home_floatin_action_button.dart';
import 'package:verbose_share_world/app_navigation/home/home_following_screen.dart';
import 'package:verbose_share_world/generated/l10n.dart';

import '../../post/post/text_post.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: TabBar(
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: ApplicationColors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(icon: Icon(Icons.search)),
            Tab(text: S.of(context).following),
            Tab(text: S.of(context).trending),
            Tab(text: S.of(context).style),
            Tab(text: S.of(context).travel),
          ],
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            HomeFollowingTabScreen(),
            HomeFollowingTabScreen(),
            HomeFollowingTabScreen(),
            HomeFollowingTabScreen(),
            HomeFollowingTabScreen(),
          ],
        ),
        // floatingActionButton: CustomHomeFloatingActionButton(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: theme.primaryColor,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TextPostScreen()));
            }),
      ),
    );
  }
}
