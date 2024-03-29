import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/home/edit_community.dart';
import 'package:verbose_share_world/app_navigation/home/home_following_screen.dart';
import 'package:verbose_share_world/provider/ViewModel/community_Feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/create_post_viewmodel.dart';

import '../../app_theme/application_colors.dart';
import '../../post/post/create_post_screen.dart';
import '../../provider/ViewModel/community_viewmodel.dart';
import '../../provider/ViewModel/feed_viewmodel.dart';

class CommunityScreen extends StatefulWidget {
  final AmityCommunity community;
  final bool isFromFeed;

  const CommunityScreen(
      {Key? key, required this.community, this.isFromFeed = false})
      : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    Provider.of<CommuFeedVM>(context, listen: false)
        .initAmityCommunityFeed(widget.community.communityId!);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getAvatarImage(String? url) {
    if (url != null) {
      return NetworkImage(url);
    } else {
      return AssetImage("assets/images/user_placeholder.png");
    }
  }

  Widget communityDescription(CommuFeedVM vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.community.description == null
            ? Container()
            : Text(
                "About",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
        SizedBox(
          height: 5.0,
        ),
        Text(widget.community.description ?? ""),
      ],
    );
  }

  void onCommunityOptionTap(CommunityFeedMenuOption option) {
    switch (option) {
      case CommunityFeedMenuOption.edit:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditCommunityScreen(widget.community)));
        break;
      case CommunityFeedMenuOption.members:
        break;
      default:
    }
  }

  Widget communityInfo(CommuFeedVM vm) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(
                widget.community.displayName != null
                    ? widget.community.displayName!
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
            Text(widget.community.isPublic != null
                ? (widget.community.isPublic! ? "Public" : "Private")
                : "N/A"),
            SizedBox(
              width: 20,
            ),
            Text("${widget.community.membersCount} members"),
            Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(theme.primaryColor)),
              onPressed: () {
                if (widget.community.isJoined != null) {
                  if (widget.community.isJoined!) {
                    AmitySocialClient.newCommunityRepository()
                        .leaveCommunity(widget.community.communityId!)
                        .then((value) {
                      setState(() {
                        widget.community.isJoined =
                            !(widget.community.isJoined!);
                      });
                    }).onError((error, stackTrace) {
                      //handle error
                      log(error.toString());
                    });
                  } else {
                    AmitySocialClient.newCommunityRepository()
                        .joinCommunity(widget.community.communityId!)
                        .then((value) {
                      setState(() {
                        widget.community.isJoined =
                            !(widget.community.isJoined!);
                      });
                    }).onError((error, stackTrace) {
                      log(error.toString());
                    });
                  }
                }
              },
              child: Text(widget.community.isJoined != null
                  ? (widget.community.isJoined! ? "Leave" : "Join")
                  : "N/A"),
            )
          ],
        )
      ],
    );
  }

  Widget communityDetailSection(CommuFeedVM vm) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OptimizedCacheImage(
                height: 400,
                imageUrl: widget.community.avatarImage?.fileUrl != null
                    ? widget.community.avatarImage!.fileUrl + "?size=full"
                    : "https://f8n-ipfs-production.imgix.net/QmXydmx66BwUCLXsxa2q6Z9ATKht6fbXqdrxU8VFd6c4cD/nft.png?q=80&auto=format%2Ccompress&cs=srgb&max-w=1680&max-h=1680",
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 400,
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [communityInfo(vm), Divider(), communityDescription(vm)],
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

    return Consumer<CommuFeedVM>(builder: (context, vm, _) {
      return Scaffold(
        floatingActionButton: (widget.community.isJoined!)
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context2) => CreatePostScreen2(
                            communityID: widget.community.communityId,
                            context: context,
                          )));
                },
                backgroundColor: theme.primaryColor,
                child: Icon(Icons.add),
              )
            : null,
        backgroundColor: ApplicationColors.lightGrey,
        body: FadedSlideAnimation(
          child: SafeArea(
            child: SingleChildScrollView(
              controller: vm.scrollcontroller,
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
                  Container(
                      width: double.infinity,
                      // height: (bHeight - 120) * 0.4,
                      child: communityDetailSection(vm)),
                  Container(
                    child: FadedSlideAnimation(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: vm.getCommunityPosts().length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<AmityPost>(
                              key: Key(vm.getCommunityPosts()[index].postId!),
                              stream: vm.getCommunityPosts()[index].listen,
                              initialData: vm.getCommunityPosts()[index],
                              builder: (context, snapshot) {
                                return PostWidget(
                                  post: snapshot.data!,
                                  theme: theme,
                                  postIndex: index,
                                );
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
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      );
    });
  }
}
