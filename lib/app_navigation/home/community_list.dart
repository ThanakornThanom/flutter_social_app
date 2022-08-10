import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/comments.dart';
import 'package:verbose_share_world/app_navigation/home/community_feed.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';

import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';

import '../../generated/l10n.dart';
import '../../provider/ViewModel/community_viewmodel.dart';

class CommunityList extends StatefulWidget {
  CommunityListType communityType;

  CommunityList(this.communityType);
  @override
  _CommunityListState createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  CommunityListType communityType = CommunityListType.recommend;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    communityType = widget.communityType;
    Future.delayed(Duration.zero, () {
      switch (communityType) {
        case CommunityListType.my:
          Provider.of<CommunityVM>(context, listen: false)
              .initAmityMyCommunityList();
          break;
        case CommunityListType.recommend:
          Provider.of<CommunityVM>(context, listen: false)
              .initAmityRecommendCommunityList();
          break;
        case CommunityListType.trending:
          Provider.of<CommunityVM>(context, listen: false)
              .initAmityTrendingCommunityList();
          break;
        default:
          Provider.of<CommunityVM>(context, listen: false)
              .initAmityMyCommunityList();
          break;
      }
    });
  }

  List<AmityCommunity> getList() {
    switch (communityType) {
      case CommunityListType.my:
        return Provider.of<CommunityVM>(context, listen: false)
            .getAmityMyCommunities();

      case CommunityListType.recommend:
        return Provider.of<CommunityVM>(context, listen: false)
            .getAmityRecommendCommunities();

      case CommunityListType.trending:
        return Provider.of<CommunityVM>(context, listen: false)
            .getAmityTrendingCommunities();

      default:
        return [];
    }
  }

  int getLength() {
    switch (communityType) {
      case CommunityListType.my:
        return Provider.of<CommunityVM>(context, listen: false)
            .getAmityMyCommunities()
            .length;

      case CommunityListType.recommend:
        return Provider.of<CommunityVM>(context, listen: false)
            .getAmityRecommendCommunities()
            .length;

      case CommunityListType.trending:
        return Provider.of<CommunityVM>(context, listen: false)
            .getAmityTrendingCommunities()
            .length;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        AppBar().preferredSize.height;

    final theme = Theme.of(context);
    return Consumer<CommunityVM>(builder: (context, vm, _) {
      return Column(
        children: [
          Expanded(
            child: Container(
              height: bHeight,
              color: ApplicationColors.lightGrey,
              child: FadedSlideAnimation(
                child: getLength() < 1
                    ? Center(
                        child: CircularProgressIndicator(
                            color: theme.primaryColor),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: getLength(),
                        itemBuilder: (context, index) {
                          return StreamBuilder<AmityCommunity>(
                              stream: getList()[index].listen,
                              initialData: getList()[index],
                              builder: (context, snapshot) {
                                return CommunityWidget(
                                  community: snapshot.data!,
                                  theme: theme,
                                  communityType: communityType,
                                );
                              });
                        },
                      ),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class CommunityWidget extends StatelessWidget {
  const CommunityWidget(
      {Key? key,
      required this.community,
      required this.theme,
      required this.communityType})
      : super(key: key);

  final AmityCommunity community;
  final ThemeData theme;
  final CommunityListType communityType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommunityScreen(
                  community: community,
                )));
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: FadeAnimation(
                    child: (community.avatarImage?.fileUrl != null)
                        ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                (NetworkImage(community.avatarImage!.fileUrl)))
                        : CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/images/user_placeholder.png")),
                  ),
                  title: Text(
                    community.displayName ?? "Community",
                    style: theme.textTheme.bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    " ${community.membersCount} members",
                    style: theme.textTheme.bodyText1!.copyWith(
                        color: ApplicationColors.textGrey, fontSize: 11),
                  ),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            theme.primaryColor)),
                    onPressed: () {
                      if (community.isJoined != null) {
                        if (community.isJoined!) {
                          Provider.of<CommunityVM>(context, listen: false)
                              .leaveCommunity(
                                  community.communityId ?? "", type: communityType);
                        } else {
                          Provider.of<CommunityVM>(context, listen: false)
                              .joinCommunity(
                                  community.communityId ?? "", type: communityType);
                        }
                      }
                    },
                    child: Text(community.isJoined != null
                        ? (community.isJoined! ? "Leave" : "Join")
                        : "Join"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
