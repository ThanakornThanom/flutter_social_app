import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/app_navigation/chat/chat_friend_tab.dart';

import 'package:verbose_share_world/generated/l10n.dart';

class ChatsPage extends StatelessWidget {
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
            Tab(text: S.of(context).groups),
            // Tab(text: S.of(context).groups),
          ],
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            ChatFriendTabScreen(),
            // ChatGroupTabScreen(),
          ],
        ),
      ),
    );
  }
}
