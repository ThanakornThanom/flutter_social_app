import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/app_navigation/story/story_full_view.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class StoryFollowingTabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _images = [
      'assets/images/Layer1774.png',
      'assets/images/Layer1801.png',
      'assets/images/Layer1801_1.png',
      'assets/images/Layer1045.png',
      'assets/images/Layer1774.png',
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: FadedSlideAnimation(
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 1 / 1.77,
          ),
          itemCount: 5,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StoryFollowingFullView(_images)));
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _images[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => UserProfileScreen()));
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/profile_pics/Layer1804.png',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: ApplicationColors.iconSize18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          S.of(context).onepointtwok,
                          style: TextStyle(
                              color: ApplicationColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
