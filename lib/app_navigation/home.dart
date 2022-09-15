import 'package:amity_uikit_beta_service/view/social/create_post_screen.dart';
import 'package:amity_uikit_beta_service/view/social/home_following_screen.dart';
import 'package:flutter/material.dart';

import '../app_theme/application_colors.dart';
import '../generated/l10n.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: TabBar(
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: ApplicationColors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            // Tab(icon: Icon(Icons.search)),
            Tab(text: S.of(context).following),
            // Tab(text: S.of(context).trending),
            // Tab(text: S.of(context).style),
            // Tab(text: S.of(context).travel),
          ],
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            GlobalFeedScreen(),
            // HomeFollowingTabScreen(),
            // HomeFollowingTabScreen(),
            // HomeFollowingTabScreen(),
            // HomeFollowingTabScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreatePostScreen2()));
          },
          backgroundColor: theme.primaryColor,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
