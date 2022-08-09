import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/post_viewmodel.dart';

import '../components/custom_user_avatar.dart';

class CommentScreen extends StatefulWidget {
  final AmityPost amityPost;

  const CommentScreen({Key? key, required this.amityPost}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class Comments {
  String image;
  String name;

  Comments(this.image, this.name);
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentTextEditController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    //query comment here
    Provider.of<PostVM>(context, listen: false)
        .listenForComments(widget.amityPost.postId!);
    Provider.of<PostVM>(context, listen: false)
        .getPost(widget.amityPost.postId!, widget.amityPost);

    super.initState();
  }

  bool isMediaPosts() {
    final childrenPosts =
        Provider.of<PostVM>(context, listen: false).amityPost.children;
    if (childrenPosts != null && childrenPosts.isNotEmpty) {
      return true;
    }
    return false;
  }

  Widget mediaPostWidgets() {
    final childrenPosts =
        Provider.of<PostVM>(context, listen: false).amityPost.children;
    if (childrenPosts != null && childrenPosts.isNotEmpty) {
      return AmityPostWidget(childrenPosts, true, false);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var postData =
        Provider.of<PostVM>(context, listen: false).amityPost.data as TextData;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height - mediaQuery.padding.top;

    return Consumer<PostVM>(builder: (context, vm, _) {
      return StreamBuilder<AmityPost>(
          stream: vm.amityPost.listen,
          initialData: vm.amityPost,
          builder: (context, snapshot) {
            return Scaffold(
              body: FadedSlideAnimation(
                child: SafeArea(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
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
                                isMediaPosts()
                                    ? Container(
                                        width: double.infinity,
                                        height: (bHeight - 120) * 0.4,
                                        child: mediaPostWidgets()
                                        // Image.asset(
                                        //   'assets/images/Layer709.png',
                                        //   fit: BoxFit.fitWidth,
                                        // ),
                                        )
                                    : Container(),
                                FadedSlideAnimation(
                                  child: Container(
                                    // height: (bHeight - 60) * 0.6,
                                    color: Colors.white,
                                    // decoration: BoxDecoration(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ApplicationColors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  ApplicationColors.lightGrey,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      getAvatarImage(
                                                          widget
                                                              .amityPost
                                                              .postedUser!
                                                              .avatarUrl!,
                                                          radius: 25),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                        flex: 12,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              widget
                                                                  .amityPost
                                                                  .postedUser!
                                                                  .displayName!,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              DateFormat
                                                                      .yMMMMEEEEd()
                                                                  .format(vm
                                                                      .amityPost
                                                                      .createdAt!),
                                                              style: theme
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          11),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      // Image.asset(
                                                      //   'assets/Icons/ic_share.png',
                                                      //   scale: 3,
                                                      // ),
                                                      // SizedBox(width: 10),
                                                      // Icon(
                                                      //   Icons.bookmark_outline,
                                                      //   size: 17,
                                                      //   color: Colors.grey,
                                                      // ),
                                                      // SizedBox(width: 10),
                                                      // FaIcon(
                                                      //   Icons.repeat_rounded,
                                                      //   size: 17,
                                                      //   color: Colors.grey,
                                                      // ),
                                                      // SizedBox(width: 10),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .chat_bubble_outline,
                                                            color:
                                                                ApplicationColors
                                                                    .grey,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8.5),
                                                          Text(
                                                            snapshot.data!
                                                                .commentCount
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    ApplicationColors
                                                                        .grey,
                                                                fontSize: 12,
                                                                letterSpacing:
                                                                    0.5),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 10),
                                                      snapshot
                                                              .data!
                                                              .myReactions!
                                                              .isNotEmpty
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "remove reaction");

                                                                Provider.of<PostVM>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .removePostReaction(
                                                                        widget
                                                                            .amityPost);
                                                              },
                                                              child: Icon(
                                                                Icons.favorite,
                                                                size: 17,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                log(widget
                                                                    .amityPost
                                                                    .myReactions!
                                                                    .toString());
                                                                Provider.of<PostVM>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .addPostReaction(
                                                                        widget
                                                                            .amityPost);
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .favorite_border,
                                                                size: 17,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        snapshot
                                                            .data!.reactionCount
                                                            .toString(),
                                                        style: theme.textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                color:
                                                                    Colors.grey,
                                                                letterSpacing:
                                                                    1),
                                                      ),
                                                      SizedBox(width: 10),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 10, 0, 9),
                                                  child: Text(
                                                    postData.text ?? "",
                                                    textAlign: TextAlign.left,
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: vm.amityComments.length,
                                          itemBuilder: (context, index) {
                                            return StreamBuilder<AmityComment>(
                                                key: UniqueKey(),
                                                stream: vm.amityComments[index]
                                                    .listen,
                                                initialData:
                                                    vm.amityComments[index],
                                                builder: (context, snapshot) {
                                                  var _comments =
                                                      snapshot.data!;
                                                  var _commentData = snapshot
                                                      .data!
                                                      .data as CommentTextData;
                                                  var isliked =
                                                      vm.isliked(_comments);
                                                  return Container(
                                                    color: Colors.white,
                                                    child: ListTile(
                                                      leading: getAvatarImage(
                                                          widget
                                                              .amityPost
                                                              .postedUser!
                                                              .avatarUrl!),
                                                      title: RichText(
                                                        text: TextSpan(
                                                          style: theme.textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  fontSize: 17),
                                                          children: [
                                                            TextSpan(
                                                              text: _comments
                                                                  .user!
                                                                  .displayName!,
                                                              style: theme
                                                                  .textTheme
                                                                  .headline6!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                            TextSpan(
                                                                text: '   ' +
                                                                    DateFormat
                                                                            .yMMMMEEEEd()
                                                                        .format(_comments
                                                                            .createdAt!),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .grey)),
                                                          ],
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        _commentData.text!,
                                                        style: theme.textTheme
                                                            .subtitle2!
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      trailing: isliked
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                vm.removeCommentReaction(
                                                                    _comments);
                                                              },
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                vm.addCommentReaction(
                                                                    _comments);
                                                              },
                                                              child: Icon(Icons
                                                                  .favorite_border)),
                                                    ),
                                                  );
                                                });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  beginOffset: Offset(0, 0.3),
                                  endOffset: Offset(0, 0),
                                  slideCurve: Curves.linearToEaseOut,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ApplicationColors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 0.8,
                                  spreadRadius: 0.5,
                                ),
                              ]),
                          height: 60,
                          child: ListTile(
                            leading: getAvatarImage(
                                widget.amityPost.postedUser!.avatarUrl!),
                            title: TextField(
                              controller: _commentTextEditController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: S.of(context).writeYourComment,
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                            trailing: GestureDetector(
                                onTap: () async {
                                  await Provider.of<PostVM>(context,
                                          listen: false)
                                      .createComment(snapshot.data!.postId!,
                                          _commentTextEditController.text);

                                  _commentTextEditController.clear();
                                  await vm.scrollcontroller.animateTo(0,
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 500));
                                },
                                child: Icon(Icons.send,
                                    color: theme.primaryColor)),
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
    });
  }
}
