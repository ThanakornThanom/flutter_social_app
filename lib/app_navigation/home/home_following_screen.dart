import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/comments.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';

import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';

import '../../generated/l10n.dart';

class FollowingItems {
  String image;
  String name;

  FollowingItems(this.image, this.name);
}

class HomeFollowingTabScreen extends StatefulWidget {
  @override
  _HomeFollowingTabScreenState createState() => _HomeFollowingTabScreenState();
}

class _HomeFollowingTabScreenState extends State<HomeFollowingTabScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<FeedVM>(context, listen: false).initAmityGlobalfeed();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        AppBar().preferredSize.height;

    final theme = Theme.of(context);
    return Consumer<FeedVM>(builder: (context, vm, _) {
      return Column(
        children: [
          Expanded(
            child: Container(
              height: bHeight,
              color: ApplicationColors.lightGrey,
              child: FadedSlideAnimation(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: vm.getAmityPosts().length,
                  controller: vm.scrollcontroller,
                  itemBuilder: (context, index) {
                    return StreamBuilder<AmityPost>(
                        stream: vm.getAmityPosts()[index].listen,
                        initialData: vm.getAmityPosts()[index],
                        builder: (context, snapshot) {
                          return ImagePostWidget(
                              key: UniqueKey(),
                              post: snapshot.data!,
                              theme: theme);
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

class ImagePostWidget extends StatefulWidget {
  const ImagePostWidget({
    Key? key,
    required this.post,
    required this.theme,
  }) : super(key: key);

  final AmityPost post;
  final ThemeData theme;

  @override
  State<ImagePostWidget> createState() => _ImagePostWidgetState();
}

class _ImagePostWidgetState extends State<ImagePostWidget>
    with AutomaticKeepAliveClientMixin {
  Widget postWidgets() {
    List<Widget> widgets = [];
    if (widget.post.data != null) {
      widgets.add(AmityPostWidget([widget.post], false, false));
    }
    final childrenPosts = widget.post.children;
    if (childrenPosts != null && childrenPosts.isNotEmpty) {
      widgets.add(AmityPostWidget(childrenPosts, true, true));
    }
    return Column(
      children: widgets,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CommentScreen(
                  amityPost: widget.post,
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => UserProfileScreen(
                                amityUser: widget.post.postedUser!,
                              )));
                    },
                    child: (widget.post.postedUser?.avatarUrl != null)
                        ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: (NetworkImage(
                                widget.post.postedUser?.avatarUrl ?? "")))
                        : CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/images/user_placeholder.png")),
                  ),
                ),
                title: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => UserProfileScreen(
                              amityUser: widget.post.postedUser!,
                            )));
                  },
                  child: Text(
                    widget.post.postedUser?.displayName ?? "Display name",
                    style: widget.theme.textTheme.bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Text(
                  " ${widget.post.createdAt?.toLocal().day}-${widget.post.createdAt?.toLocal().month}-${widget.post.createdAt?.toLocal().year}",
                  style: widget.theme.textTheme.bodyText1!.copyWith(
                      color: ApplicationColors.textGrey, fontSize: 11),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/Icons/ic_share.png',
                      scale: 3,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.bookmark_border,
                      size: 18,
                      color: ApplicationColors.grey,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.more_vert,
                      size: 18,
                      color: ApplicationColors.grey,
                    ),
                  ],
                ),
              ),
              postWidgets(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.remove_red_eye,
                    //       size: 18,
                    //       color: ApplicationColors.grey,
                    //     ),
                    //     SizedBox(width: 8.5),
                    //     Text(
                    //       S.of(context).onepointtwok,
                    //       style: TextStyle(
                    //           color: ApplicationColors.grey,
                    //           fontSize: 12,
                    //           letterSpacing: 1),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     FaIcon(
                    //       Icons.repeat_rounded,
                    //       color: ApplicationColors.grey,
                    //       size: 18,
                    //     ),
                    //     SizedBox(width: 8.5),
                    //     Text(
                    //       '287',
                    //       style: TextStyle(
                    //           color: ApplicationColors.grey,
                    //           fontSize: 12,
                    //           letterSpacing: 0.5),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        widget.post.myReactions!.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  widget.post.react().removeReaction('like');
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  widget.post.react().addReaction('like');
                                },
                                child: Icon(
                                  Icons.favorite_border,
                                  color: ApplicationColors.grey,
                                  size: 18,
                                ),
                              ),
                        SizedBox(width: 8.5),
                        Text(
                          widget.post.reactionCount.toString(),
                          style: TextStyle(
                              color: ApplicationColors.grey,
                              fontSize: 12,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CommentScreen(
                                  amityPost: widget.post,
                                )));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: ApplicationColors.grey,
                            size: 18,
                          ),
                          SizedBox(width: 8.5),
                          Text(
                            widget.post.commentCount.toString(),
                            style: TextStyle(
                                color: ApplicationColors.grey,
                                fontSize: 12,
                                letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
