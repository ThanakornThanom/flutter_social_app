import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/post_viewmodel.dart';

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
  ScrollController _controller = ScrollController();
  final _commentTextEditController = TextEditingController();
  AmityPost post = AmityPost(postId: "");
  @override
  void initState() {
    // TODO: implement initState

    //query comment here
    post = widget.amityPost;
    Provider.of<PostVM>(context, listen: false).listenForComments(post.postId!);

    super.initState();
  }

  getAvatarImage(String? url) {
    if (url != null) {
      return NetworkImage(url);
    } else {
      return AssetImage("assets/images/user_placeholder.png");
    }
  }

  bool isMediaPosts() {
    final childrenPosts = post.children;
    if (childrenPosts != null && childrenPosts.isNotEmpty) {
      return true;
    }
    return false;
  }

  Widget mediaPostWidgets() {
    final childrenPosts = post.children;
    if (childrenPosts != null && childrenPosts.isNotEmpty) {
      return AmityPostWidget(childrenPosts, true, false);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var postData = post.data as TextData;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height - mediaQuery.padding.top;
    return Scaffold(
      body: FadedSlideAnimation(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon:
                        Icon(Icons.chevron_left, color: Colors.black, size: 35),
                  ),
                ),
                Stack(
                  children: [
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
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: FadedSlideAnimation(
                          child: Container(
                            // height: (bHeight - 60) * 0.6,
                            color: Colors.white,
                            // decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      color: ApplicationColors.lightGrey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundImage: getAvatarImage(
                                                    post.postedUser!.avatarUrl),
                                                backgroundColor:
                                                    Colors.grey[400],
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                flex: 12,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget
                                                          .amityPost
                                                          .postedUser!
                                                          .displayName!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      S.of(context).today1000Am,
                                                      style: theme
                                                          .textTheme.bodyText1!
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 11),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Image.asset(
                                                'assets/Icons/ic_share.png',
                                                scale: 3,
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.bookmark_outline,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 10),
                                              FaIcon(
                                                Icons.repeat_rounded,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.favorite_border,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                S.of(context).eightpointtwok,
                                                style: theme
                                                    .textTheme.bodyText1!
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        letterSpacing: 1),
                                              ),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 9),
                                          child: Text(
                                            postData.text ?? "",
                                            textAlign: TextAlign.left,
                                            style: theme.textTheme.headline6!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // height: constraints.maxHeight * 0.7,
                                  // color: Colors.white,
                                  child: Consumer<PostVM>(
                                      builder: (context, vm, widget) {
                                    return ListView.builder(
                                      controller: _controller,
                                      itemCount: vm.amityComments.length,
                                      itemBuilder: (context, index) {
                                        var _comments = vm.amityComments;
                                        var _commentData = _comments[index].data
                                            as CommentTextData;
                                        return Container(
                                          color: Colors.white,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                backgroundImage: getAvatarImage(
                                                    _comments[index]
                                                        .user!
                                                        .avatarUrl),
                                                backgroundColor:
                                                    Colors.grey[300]),
                                            title: RichText(
                                              text: TextSpan(
                                                style: theme
                                                    .textTheme.bodyText1!
                                                    .copyWith(fontSize: 17),
                                                children: [
                                                  TextSpan(
                                                    text: _comments[index]
                                                        .user!
                                                        .displayName!,
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                  TextSpan(
                                                      text: '   ' +
                                                          S
                                                              .of(context)
                                                              .today1000Am,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                            subtitle: Text(
                                              _commentData.text!,
                                              style: theme.textTheme.subtitle2!
                                                  .copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                            trailing:
                                                Icon(Icons.favorite_border),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          beginOffset: Offset(0, 0.3),
                          endOffset: Offset(0, 0),
                          slideCurve: Curves.linearToEaseOut,
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
                          leading: CircleAvatar(
                              backgroundImage:
                                  getAvatarImage(post.postedUser!.avatarUrl)),
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
                                    .createComment(post.postId!,
                                        _commentTextEditController.text);

                                _commentTextEditController.clear();
                                _controller.animateTo(0,
                                    curve: Curves.linear,
                                    duration: Duration(milliseconds: 500));
                              },
                              child:
                                  Icon(Icons.send, color: theme.primaryColor)),
                        ),
                      ),
                    ],
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
  }
}
