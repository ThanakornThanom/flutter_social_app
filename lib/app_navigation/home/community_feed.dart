import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/home/edit_community.dart';
import 'package:verbose_share_world/app_navigation/home/home_following_screen.dart';

import '../../app_theme/application_colors.dart';
import '../../provider/ViewModel/community_viewmodel.dart';
import '../../provider/ViewModel/feed_viewmodel.dart';

class CommunityScreen extends StatefulWidget {
  final AmityCommunity community;

  const CommunityScreen({Key? key, required this.community}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  ScrollController _controller = ScrollController();
  AmityCommunity community = AmityCommunity();
  @override
  void initState() {
    community = widget.community;
    super.initState();
    log("init commu feed state");
    Future.delayed(Duration.zero, () {
      Provider.of<FeedVM>(context, listen: false).initAmityCommunityFeed(
          community.communityId ?? ""); //community.communityId!);
    });
  }

  getAvatarImage(String? url) {
    if (url != null) {
      return NetworkImage(url);
    } else {
      return AssetImage("assets/images/user_placeholder.png");
    }
  }

  Widget communityDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        community.description == null
            ? Container()
            : Text(
                "About",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
        SizedBox(
          height: 5.0,
        ),
        Text(community.description ?? ""),
      ],
    );
  }

  void onCommunityOptionTap(CommunityFeedMenuOption option) {
    switch (option) {
      case CommunityFeedMenuOption.edit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditCommunityScreen(community)));
        break;
      case CommunityFeedMenuOption.members:
        break;
      default:
    }
  }

  Widget communityInfo() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(
                community.displayName != null
                    ? community.displayName!
                    : "Community",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Spacer(),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit Community'),
                              onTap: () {
                                Navigator.of(context).pop();
                                onCommunityOptionTap(
                                    CommunityFeedMenuOption.edit);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.people_alt_rounded),
                              title: Text('Members'),
                              onTap: () {
                                onCommunityOptionTap(
                                    CommunityFeedMenuOption.members);
                              },
                            ),
                            ListTile(
                              title: Text(''),
                            ),
                          ],
                        );
                        // return SizedBox(
                        //   height: 200,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: const <Widget>[],
                        //   ),
                        // );
                      });
                },
                icon: Icon(Icons.more_horiz_rounded, color: Colors.black)),
          ],
        ),
        Row(
          children: [
            Icon(Icons.public_rounded, color: Colors.black),
            SizedBox(
              width: 5,
            ),
            Text(community.isPublic != null
                ? (community.isPublic! ? "Public" : "Private")
                : "N/A"),
            SizedBox(
              width: 20,
            ),
            Text("${community.membersCount} members"),
            Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(theme.primaryColor)),
              onPressed: () {},
              child: Text(community.isJoined != null
                  ? (community.isJoined! ? "Leave" : "Join")
                  : "N/A"),
            )
          ],
        )
      ],
    );
  }

  Widget communityDetailSection() {
    return Column(
      children: [
        OptimizedCacheImage(
          imageUrl: community.avatarImage?.fileUrl != null
              ? community.avatarImage!.fileUrl + "?size=full"
              : "https://f8n-ipfs-production.imgix.net/QmXydmx66BwUCLXsxa2q6Z9ATKht6fbXqdrxU8VFd6c4cD/nft.png?q=80&auto=format%2Ccompress&cs=srgb&max-w=1680&max-h=1680",
          fit: BoxFit.fill,
          placeholder: (context, url) => Container(
            height: 250,
            color: Colors.grey,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [communityInfo(), Divider(), communityDescription()],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height - mediaQuery.padding.top;
    return Consumer<FeedVM>(builder: (context, vm, _) {
      return Scaffold(
        body: FadedSlideAnimation(
          child: SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.chevron_left,
                            color: Colors.black, size: 35),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            // height: (bHeight - 120) * 0.4,
                            child: communityDetailSection()),
                      ],
                    ),
                    Container(
                      color: ApplicationColors.lightGrey,
                      child: FadedSlideAnimation(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: vm.getCommunityPosts().length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<AmityPost>(
                                stream: vm.getCommunityPosts()[index].listen,
                                initialData: vm.getCommunityPosts()[index],
                                builder: (context, snapshot) {
                                  return ImagePostWidget(
                                      post: snapshot.data!, theme: theme);
                                });
                          },
                        ),
                        beginOffset: Offset(0, 0.3),
                        endOffset: Offset(0, 0),
                        slideCurve: Curves.linearToEaseOut,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      );
    });
  }
}
