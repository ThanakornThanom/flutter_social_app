import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/app_navigation/notification/notification_all_tab.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: TabBar(
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: ApplicationColors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: S.of(context).all),
            Tab(text: S.of(context).likes),
            Tab(text: S.of(context).comments),
            Tab(text: S.of(context).repost),
          ],
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            NotificationAllTabScreen(),
            NotificationAllTabScreen(),
            NotificationAllTabScreen(),
            NotificationAllTabScreen(),
          ],
        ),
      ),
    );
  }
}
