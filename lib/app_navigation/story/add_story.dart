import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class StoryAddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        child: Container(
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/Layer1045.png', fit: BoxFit.fitHeight),
              Positioned(
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.chevron_left,
                        size: 20,
                      ),
                    ),
                    Text(
                      S.of(context).swipeUpForGallery,
                      style: theme.textTheme.bodyText1!
                          .copyWith(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 60,
                child: Row(
                  children: [
                    Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: theme.primaryIconTheme.size,
                    ),
                    SizedBox(width: 40),
                    RawMaterialButton(
                      onPressed: () {},
                      fillColor: theme.primaryColor,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(15),
                      child: FaIcon(
                        FontAwesomeIcons.video,
                        size: 25,
                      ),
                    ),
                    SizedBox(width: 40),
                    Icon(
                      Icons.flash_off,
                      color: Colors.white,
                      size: theme.primaryIconTheme.size,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0, 0.25, 0.75, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black26,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black26
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 30,
                child: GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    Navigator.pop(context);
                  },
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
