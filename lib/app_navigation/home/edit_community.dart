import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/home/category_list.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/category_viewmodel.dart';

import '../../components/custom_user_avatar.dart';
import '../../provider/ViewModel/community_viewmodel.dart';
import '../../provider/ViewModel/custom_image_picker.dart';

class EditCommunityScreen extends StatefulWidget {
  AmityCommunity community;
  EditCommunityScreen(this.community);
  @override
  _EditCommunityScreenState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends State<EditCommunityScreen> {
  CommunityType communityType = CommunityType.public;
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    // Provider.of<CommunityVM>(context, listen: false)
    //     .getUser(AmityCoreClient.getCurrentUser());

    _displayNameController.text = widget.community.displayName ?? "";
    _descriptionController.text = widget.community.description ?? "";
    _categoryController.text = widget.community.categories != null
        ? widget.community.categories![0]!.name!
        : "No category";
    communityType = widget.community.isPublic!
        ? CommunityType.public
        : CommunityType.private;
    super.initState();
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      title: Text(
        "Edit Community",
        style: theme.textTheme.headline6,
      ),
      backgroundColor: ApplicationColors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left, color: Colors.black, size: 30),
      ),
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () async {
            await Provider.of<CommunityVM>(context, listen: false)
                .updateCommunity(
                    widget.community.communityId ?? "",
                    widget.community.avatarImage,
                    _displayNameController.text,
                    _descriptionController.text,
                    Provider.of<CategoryVM>(context, listen: false)
                        .getSelectedCategory(),
                    communityType == CommunityType.public ? true : false);

            //edit profile
            // await Provider.of<CommunityVM>(context, listen: false)
            //     .editCurrentUserInfo(
            //         displayName: _displayNameController.text,
            //         description: _descriptionController.text);
          },
          child: Text(
            "Save",
            style: theme.textTheme.button!.copyWith(
                color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    return Consumer<CommunityVM>(builder: (context, vm, _) {
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
                        GestureDetector(
                            onTap: () {
                              Provider.of<ImagePickerVM>(context, listen: false)
                                  .showBottomSheet(context);
                            },
                            child: FadedScaleAnimation(
                                child: CircleAvatar(
                              radius: 50,
                              backgroundImage: getImageProvider(
                                  widget.community.avatarImage?.fileUrl),
                            ))),
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
                          "Community Info",
                          style: theme.textTheme.headline6!.copyWith(
                            color: Colors.grey,
                            fontSize: ApplicationColors.fontSize16,
                          ),
                        ),
                      ),
                      // Container(
                      //   color: Colors.white,
                      //   width: double.infinity,
                      //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      //   child: TextField(
                      //     enabled: false,
                      //     controller:
                      //         TextEditingController(text: ""),//vm.amityUser.userId),
                      //     decoration: InputDecoration(
                      //       labelText: "Community Name",
                      //       labelStyle: TextStyle(height: 1),
                      //       border: InputBorder.none,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: TextField(
                          controller: _displayNameController,
                          decoration: InputDecoration(
                            labelText: "Name",
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
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: TextField(
                          controller: _categoryController,
                          readOnly: true,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CategoryList(widget.community)));
                          },
                          decoration: InputDecoration(
                            labelText: "Category",
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
                      Column(
                        children: [
                          ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle),
                              child: Icon(Icons.public),
                            ),
                            title: const Text('Public'),
                            subtitle: const Text(
                                'Anyone can join, view and search this community'),
                            trailing: Radio(
                              value: CommunityType.public,
                              activeColor: theme.primaryColor,
                              groupValue: communityType,
                              onChanged: (CommunityType? value) {
                                setState(() {
                                  communityType = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle),
                              child: Icon(Icons.lock),
                            ),
                            title: const Text('Private'),
                            subtitle: const Text(
                                'Only members invited by the moderators can join, view and search this community'),
                            trailing: Radio(
                              value: CommunityType.private,
                              activeColor: theme.primaryColor,
                              groupValue: communityType,
                              onChanged: (CommunityType? value) {
                                setState(() {
                                  communityType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
