import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/create_post_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/edit_post_viewmodel.dart';
import 'package:video_player/video_player.dart';

import '../../app_navigation/home/community_feed.dart';
import '../../components/custom_user_avatar.dart';
import '../../components/video_player.dart';
import '../../profile/user_profile.dart';
import '../../provider/ViewModel/community_Feed_viewmodel.dart';

// ignore: must_be_immutable
class EditPostScreen extends StatefulWidget {
  AmityPost? post; // Must extract children post from parent post

  EditPostScreen({Key? key, this.post}) : super(key: key);
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  @override
  void initState() {
    Provider.of<EditPostVM>(context, listen: false)
        .initForEditPost(widget.post!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppbar = AppBar(
      backgroundColor: ApplicationColors.white,
      elevation: 0,
      title: Text(S.of(context).edit,
          style:
              theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.w500)),
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: theme.indicatorColor,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppbar.preferredSize.height;
    return Consumer<EditPostVM>(builder: (context, vm, _m) {
      return Scaffold(
        appBar: myAppbar,
        body: SafeArea(
          child: FadedSlideAnimation(
            child: Container(
              // height: bheight,
              color: ApplicationColors.white,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: FadeAnimation(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => UserProfileScreen(
                                        amityUser: widget.post!.postedUser!,
                                      )));
                            },
                            child: getAvatarImage(
                                widget.post!.postedUser?.avatarUrl))),
                    title: Wrap(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => UserProfileScreen(
                                      amityUser: widget.post!.postedUser!,
                                    )));
                          },
                          child: Text(
                            widget.post!.postedUser?.displayName ??
                                "Display name",
                            style: theme.textTheme.bodyText1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        widget.post!.targetType == AmityPostTargetType.COMMUNITY
                            ? Icon(
                                Icons.arrow_right_rounded,
                                color: Colors.black,
                              )
                            : Container(),
                        widget.post!.targetType == AmityPostTargetType.COMMUNITY
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                            create: (context) => CommuFeedVM(),
                                            child: CommunityScreen(
                                              isFromFeed: true,
                                              community: (widget.post!.target
                                                      as CommunityTarget)
                                                  .targetCommunity!,
                                            ),
                                          )));
                                },
                                child: Text(
                                  (widget.post!.target as CommunityTarget)
                                          .targetCommunity!
                                          .displayName ??
                                      "Community name",
                                  style: theme.textTheme.bodyText1!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: vm.textEditingController,
                            scrollPhysics: NeverScrollableScrollPhysics(),
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: S.of(context).writeSomethingToPost,
                            ),
                            // style: t/1heme.textTheme.bodyText1.copyWith(color: Colors.grey),
                          ),
                          (vm.videoUrl != null)
                              ? MyVideoPlayer2(
                                  url: vm.videoUrl!,
                                  isCornerRadiusEnabled: true,
                                  isEnableVideoTools: false,
                                  videoPlayerController:
                                      VideoPlayerController.network(
                                          vm.videoUrl!),
                                )
                              : Container(),
                          vm.imageUrlList == null
                              ? Container()
                              : GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 150,
                                          childAspectRatio: 1,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemCount: vm.imageUrlList.length,
                                  itemBuilder: (_, i) {
                                    return FadeAnimation(
                                      child: Container(
                                          child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            vm.imageUrlList[i],
                                            fit: BoxFit.cover,
                                          ),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    vm.deleteImageAt(index: i);
                                                  },
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: Colors.grey.shade100,
                                                  ))),
                                        ],
                                      )),
                                    );
                                  },
                                )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await vm.addVideo();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ApplicationColors.lightGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.fromLTRB(5, 0, 10, 5),
                          child: FaIcon(
                            FontAwesomeIcons.video,
                            color: vm.isNotSelectedImageYet()
                                ? theme.primaryColor
                                : theme.disabledColor,
                            size: ApplicationColors.iconSize20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await vm.addFiles();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ApplicationColors.lightGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.fromLTRB(5, 0, 10, 5),
                          child: Icon(
                            Icons.photo,
                            color: vm.isNotSelectVideoYet()
                                ? theme.primaryColor
                                : theme.disabledColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await vm.addFileFromCamera();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ApplicationColors.lightGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.fromLTRB(5, 0, 10, 5),
                          child: Icon(
                            Icons.camera_alt,
                            color: vm.isNotSelectVideoYet()
                                ? theme.primaryColor
                                : theme.disabledColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      //edit post
                      //waiting for update

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        S.of(context).edit,
                        style: theme.textTheme.button,
                      ),
                    ),
                  ),
                ],
              ),
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
