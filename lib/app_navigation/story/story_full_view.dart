import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class StoryFollowingFullView extends StatelessWidget {
  final List<String> images;

  StoryFollowingFullView(this.images);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        child: PageView.builder(
            itemCount: images.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Image.asset(images[index], fit: BoxFit.cover),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: ApplicationColors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              S.of(context).onepointtwok,
                              style: theme.textTheme.bodyText1!
                                  .copyWith(color: ApplicationColors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: ApplicationColors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '287',
                              style: theme.textTheme.bodyText1!
                                  .copyWith(color: ApplicationColors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: ApplicationColors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              S.of(context).eightpointtwok,
                              style: theme.textTheme.bodyText1!
                                  .copyWith(color: ApplicationColors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.chevron_left,
                            size: 24,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          S.of(context).swipeUpToSeeNext,
                          style: theme.textTheme.bodyText1!.copyWith(
                              color: ApplicationColors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.black26
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 20,
                    start: 0,
                    end: 0,
                    // margin: EdgeInsets.only(top: mediaQuery.padding.top),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => UserProfileScreen()));
                        },
                        child: FadedScaleAnimation(
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/profile_pics/Layer1804.png'),
                          ),
                        ),
                      ),
                      title: Text(
                        'James Taylor',
                        style: theme.textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: Text(
                        S.of(context).today1000Am,
                        style: theme.textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
