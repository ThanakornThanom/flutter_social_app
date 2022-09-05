import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/amity_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/custom_image_picker.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';

import '../components/custom_user_avatar.dart';
import '../provider/ViewModel/user_feed_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _displayNameController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    Provider.of<ImagePickerVM>(context, listen: false).init();
    Provider.of<UserFeedVM>(context, listen: false)
        .getUser(AmityCoreClient.getCurrentUser());

    _displayNameController.text =
        AmityCoreClient.getCurrentUser().displayName ?? "";
    _descriptionController.text =
        AmityCoreClient.getCurrentUser().description ?? "";
    super.initState();
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      title: Text(
        S.of(context).my_Profile,
        style: theme.textTheme.headline6,
      ),
      backgroundColor: ApplicationColors.white,
      leading: IconButton(
        color: theme.primaryColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left),
      ),
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () async {
            //edit profile
            if (Provider.of<ImagePickerVM>(context, listen: false).amityImage !=
                null) {
              await Provider.of<UserFeedVM>(context, listen: false)
                  .editCurrentUserInfo(
                      displayName: _displayNameController.text,
                      description: _descriptionController.text,
                      avatarFileID:
                          Provider.of<ImagePickerVM>(context, listen: false)
                              .amityImage!
                              .fileId);

              Provider.of<AmityVM>(context, listen: false)
                  .refreshCurrentUserData();
            } else {
              await Provider.of<UserFeedVM>(context, listen: false)
                  .editCurrentUserInfo(
                displayName: _displayNameController.text,
                description: _descriptionController.text,
              );
            }
          },
          child: Text(
            S.of(context).edit,
            style: theme.textTheme.button!.copyWith(
                color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    return Consumer<UserFeedVM>(builder: (context, vm, _) {
      return Scaffold(
        appBar: myAppBar,
        body: FadedSlideAnimation(
          child: Container(
            color: ApplicationColors.white,
            height: bheight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        FadedScaleAnimation(
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<ImagePickerVM>(context, listen: false)
                                  .showBottomSheet(context);
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: Provider.of<ImagePickerVM>(
                                              context,
                                              listen: true)
                                          .amityImage !=
                                      null
                                  ? NetworkImage(Provider.of<ImagePickerVM>(
                                          context,
                                          listen: false)
                                      .amityImage!
                                      .fileUrl)
                                  : getImageProvider(
                                      Provider.of<AmityVM>(
                                        context,
                                      ).currentamityUser?.avatarUrl,
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 7,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.primaryColor,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                        alignment: Alignment.centerLeft,
                        color: ApplicationColors.lightGrey,
                        width: double.infinity,
                        child: Text(
                          S.of(context).profile_Info,
                          style: theme.textTheme.headline6!.copyWith(
                            color: Colors.grey,
                            fontSize: ApplicationColors.fontSize16,
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: TextField(
                          enabled: false,
                          controller:
                              TextEditingController(text: vm.amityUser.userId),
                          decoration: InputDecoration(
                            labelText: "User Id",
                            labelStyle: TextStyle(height: 1),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(
                        color: ApplicationColors.lightGrey,
                        thickness: 3,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: TextField(
                          controller: _displayNameController,
                          decoration: InputDecoration(
                            labelText: "Display Name",
                            alignLabelWithHint: false,
                            border: InputBorder.none,
                            labelStyle: TextStyle(height: 1),
                          ),
                        ),
                      ),
                      Divider(
                        color: ApplicationColors.lightGrey,
                        thickness: 3,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: "Description",
                            alignLabelWithHint: false,
                            border: InputBorder.none,
                            labelStyle: TextStyle(height: 1),
                          ),
                        ),
                      ),
                      Divider(
                        color: ApplicationColors.lightGrey,
                        thickness: 3,
                      ),

                      // Container(
                      //   color: Colors.white,
                      //   width: double.infinity,
                      //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      //   child: TextField(
                      //     controller:
                      //         TextEditingController(text: '+1 9876543210'),
                      //     decoration: InputDecoration(
                      //       labelText: S.of(context).phoneNumber,
                      //       labelStyle: TextStyle(height: 1),
                      //       border: InputBorder.none,
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   color: ApplicationColors.lightGrey,
                      //   thickness: 3,
                      // ),
                      // Container(
                      //   color: Colors.white,
                      //   width: double.infinity,
                      //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      //   child: TextField(
                      //     controller: TextEditingController(
                      //         text: S.of(context).samanthasmithmailcom),
                      //     decoration: InputDecoration(
                      //       labelText: S.of(context).emailAddress,
                      //       labelStyle: TextStyle(height: 1),
                      //       border: InputBorder.none,
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   color: ApplicationColors.lightGrey,
                      //   thickness: 3,
                      // ),
                      // Container(
                      //   color: Colors.white,
                      //   width: double.infinity,
                      //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      //   child: TextField(
                      //     controller:
                      //         TextEditingController(text: S.of(context).female),
                      //     decoration: InputDecoration(
                      //       labelText: S.of(context).gender,
                      //       labelStyle: TextStyle(height: 1),
                      //       border: InputBorder.none,
                      //     ),
                      //   ),
                      // ),
                      // Divider(
                      //   color: ApplicationColors.lightGrey,
                      //   thickness: 3,
                      // ),
                    ],
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
