import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/post/post/text_post.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
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
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left),
      ),
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppbar.preferredSize.height;
    return Scaffold(
      appBar: myAppbar,
      body: FadedSlideAnimation(
        child: Container(
          height: bheight,
          color: ApplicationColors.white,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/Layer1677.png'),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: mediaQuery.size.width - 150,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Say Something about this photo',
                      ),
                      // style: theme.textTheme.bodyText1.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Expanded(
                flex: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadedScaleAnimation(
                      child: Image.asset('assets/images/Layer884.png')),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TextPostScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
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
    );
  }
}
