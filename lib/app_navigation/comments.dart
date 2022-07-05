import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class Comments {
  String image;
  String name;

  Comments(this.image, this.name);
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    List<Comments> _comments = [
      Comments('assets/images/Layer707.png', 'Emili Williamson'),
      Comments('assets/images/Layer709.png', 'Harshu Makkar'),
      Comments('assets/images/Layer948.png', 'Mrs. White'),
      Comments('assets/images/Layer884.png', 'Marie Black'),
      Comments('assets/images/Layer915.png', 'Emili Williamson'),
      Comments('assets/images/Layer946.png', 'Emili Williamson'),
      Comments('assets/images/Layer948.png', 'Emili Williamson'),
      Comments('assets/images/Layer949.png', 'Emili Williamson'),
      Comments('assets/images/Layer950.png', 'Emili Williamson'),
    ];
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height - mediaQuery.padding.top;
    return Scaffold(
      body: FadedSlideAnimation(
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: (bHeight - 60) * 0.4,
                        child: Image.asset(
                          'assets/images/Layer709.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.chevron_left),
                      ),
                    ],
                  ),
                  FadedSlideAnimation(
                    child: Container(
                      height: (bHeight - 60) * 0.6,
                      color: Color.fromRGBO(27, 77, 42, 1),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                              'assets/images/Layer884.png'),
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
                                                S.of(context).emiliWilliamson,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                S.of(context).today1000Am,
                                                style: theme
                                                    .textTheme.bodyText1!
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 11),
                                                overflow: TextOverflow.ellipsis,
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
                                          style: theme.textTheme.bodyText1!
                                              .copyWith(
                                                  color: Colors.grey,
                                                  letterSpacing: 1),
                                        ),
                                        SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 9),
                                    child: Text(
                                      'Finding myself !!',
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
                            child: ListView.builder(
                              itemCount: _comments.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(_comments[index].image),
                                    ),
                                    title: RichText(
                                      text: TextSpan(
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(fontSize: 17),
                                        children: [
                                          TextSpan(
                                            text: _comments[index].name,
                                            style: theme.textTheme.headline6!
                                                .copyWith(fontSize: 14),
                                          ),
                                          TextSpan(
                                              text: '   ' +
                                                  S.of(context).today1000Am,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text(
                                      S.of(context).wowLooksStunning,
                                      style:
                                          theme.textTheme.subtitle2!.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: Icon(Icons.favorite_border),
                                  ),
                                );
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
                            AssetImage('assets/images/Layer1677.png'),
                      ),
                      title: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: S.of(context).writeYourComment,
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                      ),
                      trailing: Icon(Icons.send, color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
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
