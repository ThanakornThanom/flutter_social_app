import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/comments.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/components/custom_user_avatar.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';

import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/post_viewmodel.dart';

import '../../generated/l10n.dart';
import '../../post/post/create_post.dart';
import '../../post/post/create_post_screen.dart';
import '../../post/post/edit_post_screen.dart';

class GlobalFeedTabScreen extends StatefulWidget {
  @override
  _GlobalFeedTabScreenState createState() => _GlobalFeedTabScreenState();
}

class _GlobalFeedTabScreenState extends State<GlobalFeedTabScreen> {
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
                        key: Key(vm.getAmityPosts()[index].postId!),
                        stream: vm.getAmityPosts()[index].listen,
                        initialData: vm.getAmityPosts()[index],
                        builder: (context, snapshot) {
                          return PostWidget(post: snapshot.data!, theme: theme);
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

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.post,
    required this.theme,
  }) : super(key: key);

  final AmityPost post;
  final ThemeData theme;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
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

  Widget postOptions(BuildContext context) {
    bool isPostOwner =
        widget.post.postedUserId == AmityCoreClient.getCurrentUser().userId;
    List<String> postOwnerMenu = ['Edit Post', 'Delete Post'];

    final isFlaggedByMe = widget.post.isFlaggedByMe;
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'Report Post':
          case 'Unreport Post':
            print("isflag by me ${isFlaggedByMe}");
            if (isFlaggedByMe) {
              Provider.of<PostVM>(context, listen: false).unflagPost(widget.post);
            } else {
              Provider.of<PostVM>(context, listen: false).flagPost(widget.post);
            }

            break;
          case 'Edit Post':
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditPostScreen(post: widget.post)));
            break;
          case 'Delete Post':
            AmitySocialClient.newPostRepository()
                .deletePost(postId: widget.post.postId ?? "")
                .then((value) {})
                .onError((error, stackTrace) {});
            break;
          default:
        }
      },
      child: Icon(
        Icons.more_horiz_rounded,
        size: 24,
        color: ApplicationColors.grey,
      ),
      itemBuilder: (context) {
        return List.generate(isPostOwner ? 2 : 1, (index) {
          return PopupMenuItem(
              value: isPostOwner
                  ? postOwnerMenu[index]
                  : isFlaggedByMe
                      ? 'Unreport Post'
                      : 'Report Post',

              // : isFlaggedByMe != null ? (isFlaggedByMe ? 'Unreport Post'
              //     : 'Report Post') : '',

              child: Text(isPostOwner
                  ? postOwnerMenu[index]
                  : isFlaggedByMe
                      ? 'Unreport Post'
                      : 'Report Post')
              // : isFlaggedByMe != null ? (isFlaggedByMe ? 'Unreport Post'
              //     : 'Report Post') : '',)
              );
        });
      },
    );
  }

  // @override
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
                      child: CircleAvatar(
                        backgroundImage:
                            getImageProvider(widget.post.postedUser?.avatarUrl),
                      )),
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
                    // Image.asset(
                    //   'assets/Icons/ic_share.png',
                    //   scale: 3,
                    // ),
                    // SizedBox(width: 20),
                    // Icon(
                    //   Icons.bookmark_border,
                    //   size: 18,
                    //   color: ApplicationColors.grey,
                    // ),
                    // SizedBox(width: 20),
                    postOptions(context),
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
                                  HapticFeedback.heavyImpact();
                                  Provider.of<PostVM>(context, listen: false)
                                      .removePostReaction(widget.post);
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  Provider.of<PostVM>(context, listen: false)
                                      .addPostReaction(widget.post);
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
  bool get wantKeepAlive {
    final childrenPosts = widget.post.children;
    if (childrenPosts != null && childrenPosts.isNotEmpty) {
      if (childrenPosts[0].data is VideoData) {
        print("keep ${childrenPosts[0].parentPostId} alive");
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
