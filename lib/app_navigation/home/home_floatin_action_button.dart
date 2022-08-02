import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/story/add_story.dart';
import 'package:verbose_share_world/post/upload.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/provider/ViewModel/amity_viewmodel.dart';

class CustomHomeFloatingActionButton extends StatefulWidget {
  @override
  _CustomHomeFloatingActionButtonState createState() =>
      _CustomHomeFloatingActionButtonState();
}

class _CustomHomeFloatingActionButtonState
    extends State<CustomHomeFloatingActionButton> {
  late bool _isSheetOpen;

  @override
  void initState() {
    super.initState();
    _isSheetOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        setState(() {
          Provider.of<AmityVM>(context, listen: false).getUserByID("autest");
          _isSheetOpen = !_isSheetOpen;
        });
        if (_isSheetOpen) {
          showBottomSheet(
            context: context,
            builder: (context) => Container(
              height: 70,
              color: theme.primaryColor,
              child: Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadScreen()));
                    },
                    child: Icon(Icons.camera_alt),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoryAddScreen()));
                    },
                    child: FaIcon(
                      FontAwesomeIcons.video,
                      size: 20,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadScreen()));
                    },
                    child: Icon(Icons.image),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.text_format),
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      },
      backgroundColor:
          _isSheetOpen ? ApplicationColors.white : theme.primaryColor,
      child: _isSheetOpen
          ? Icon(
              Icons.close,
              size: 30,
              color: theme.primaryColor,
            )
          : Icon(
              Icons.add,
              size: 30,
              color: ApplicationColors.white,
            ),
    );
  }
}
