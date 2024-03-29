import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/create_post_viewmodel.dart';
import 'package:video_player/video_player.dart';

import '../../components/custom_user_avatar.dart';
import '../../components/video_player.dart';

// ignore: must_be_immutable
class CreatePostScreen2 extends StatefulWidget {
  String? communityID;
  BuildContext? context;
  CreatePostScreen2({Key? key, this.communityID, this.context})
      : super(key: key);
  @override
  _CreatePostScreen2State createState() => _CreatePostScreen2State();
}

class _CreatePostScreen2State extends State<CreatePostScreen2> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CreatePostVM>(context, listen: false).inits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppbar = AppBar(
      backgroundColor: ApplicationColors.white,
      elevation: 0,
      title: Text(S.of(context).createPost,
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
    return Consumer<CreatePostVM>(builder: (context, vm, _m) {
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
                  Align(
                      alignment: Alignment.topLeft,
                      child: getAvatarImage(
                          AmityCoreClient.getCurrentUser().avatarUrl)),
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
                          (vm.amityVideo != null)
                              ? (vm.amityVideo!.isComplete)
                                  ? LocalVideoPlayer(
                                      file: vm.amityVideo!.file!,
                                    )
                                  : CircularProgressIndicator()
                              : Container(),
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: vm.amityImages.length,
                            itemBuilder: (_, i) {
                              return (vm.amityImages[i].isComplete)
                                  ? FadeAnimation(
                                      child: Container(
                                          child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            vm.amityImages[i].fileInfo!.fileUrl,
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
                                    )
                                  : FadeAnimation(
                                      child: Container(
                                        color: theme.highlightColor,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
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
                      if (widget.communityID == null) {
                        //creat post in user Timeline
                        await vm.createPost(context);
                      } else {
                        //create post in Community
                        await vm.createPost(widget.context!,
                            communityId: widget.communityID);
                      }

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
                        S.of(context).submitPost,
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
