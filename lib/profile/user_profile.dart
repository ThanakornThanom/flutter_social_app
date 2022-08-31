import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/amity_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/user_feed_viewmodel.dart';

import '../app_navigation/home/home_following_screen.dart';
import '../components/custom_user_avatar.dart';
import 'edit_profile.dart';

class UserProfileScreen extends StatefulWidget {
  final AmityUser amityUser;

  const UserProfileScreen({Key? key, required this.amityUser})
      : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    Provider.of<UserFeedVM>(context, listen: false).getUser(widget.amityUser);
    Provider.of<UserFeedVM>(context, listen: false)
        .listenForUserFeed(widget.amityUser.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      backgroundColor: ApplicationColors.white,
      leading: IconButton(
        color: theme.primaryColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left),
      ),
      elevation: 0,
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    return Consumer<UserFeedVM>(builder: (context, vm, _) {
      return Scaffold(
        backgroundColor: ApplicationColors.white,
        appBar: myAppBar,
        body: SingleChildScrollView(
          child: FadedSlideAnimation(
            child: Column(
              children: [
                Container(
                  color: ApplicationColors.white,
                  height: bheight * 0.4,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      vm.amityMyFollowInfo.followerCount
                                          .toString(),
                                      style: theme.textTheme.headline6),
                                  Text(
                                    'Followers',
                                    style: theme.textTheme.subtitle2!.copyWith(
                                      color: theme.hintColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: FadedScaleAnimation(
                                    child: getAvatarImage(
                                        Provider.of<AmityVM>(
                                          context,
                                        ).currentamityUser?.avatarUrl,
                                        radius: 50)),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      vm.amityMyFollowInfo.followingCount
                                          .toString(),
                                      style: theme.textTheme.headline6),
                                  Text(
                                    S.of(context).following,
                                    style: theme.textTheme.subtitle2!.copyWith(
                                      color: theme.hintColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          vm.amityUser.displayName!,
                          style: theme.textTheme.headline6,
                        ),
                        Text(
                          "",
                          style: theme.textTheme.subtitle2!.copyWith(
                            color: theme.hintColor,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AmityCoreClient.getUserId() != vm.amityUser.userId
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: constraints.maxWidth * 0.35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: theme.primaryColor,
                                                style: BorderStyle.solid,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ApplicationColors.white),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Text(
                                          "Messages",
                                          style: theme.textTheme.subtitle2!
                                              .copyWith(
                                            color: theme.primaryColor,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen()));
                                      },
                                      child: Container(
                                        width: constraints.maxWidth * 0.35,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: theme.primaryColor,
                                                style: BorderStyle.solid,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ApplicationColors.white),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Text(
                                          "Edit",
                                          style: theme.textTheme.subtitle2!
                                              .copyWith(
                                            color: theme.primaryColor,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: constraints.maxWidth * 0.35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: theme.primaryColor,
                                          style: BorderStyle.solid,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                      color: theme.primaryColor),
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    'Follow Now',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.subtitle2!.copyWith(
                                      color: theme.scaffoldBackgroundColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicatorColor: theme.primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                S.of(context).posts,
                                style: theme.textTheme.bodyText1,
                              ),
                            ),
                            Text(
                              S.of(context).stories,
                              style: theme.textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // TabBarView(
                //   controller: _tabController,
                //   children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: vm.amityPosts.length,
                  itemBuilder: (context, index) {
                    var post = vm.amityPosts[index];
                    return StreamBuilder<AmityPost>(
                        stream: vm.amityPosts[index].listen,
                        initialData: vm.amityPosts[index],
                        builder: (context, snapshot) {
                          return PostWidget(
                            post: snapshot.data!,
                            theme: theme,
                            postIndex: index,
                          );
                        });
                  },
                )

                //   Container(),
                // ],
                // ),
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      );
    });
  }
}
