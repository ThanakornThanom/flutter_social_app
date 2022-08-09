import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_navigation/comments.dart';
import 'package:verbose_share_world/app_navigation/home/community_feed.dart';
import 'package:verbose_share_world/app_navigation/home/post_content_widget.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';

import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';

import '../../generated/l10n.dart';
import '../../provider/ViewModel/category_viewmodel.dart';
import '../../provider/ViewModel/community_viewmodel.dart';

class CategoryList extends StatefulWidget {
  AmityCommunity community;

  CategoryList(this.community);
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  AmityCommunity community = AmityCommunity();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    community = widget.community;
    Provider.of<CategoryVM>(context, listen: false).initCategoryList();
  }

  int getLength() {
    int length =
        Provider.of<CategoryVM>(context, listen: false).getCategories().length;
    return length;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        AppBar().preferredSize.height;

    final theme = Theme.of(context);
    return Consumer<CategoryVM>(builder: (context, vm, _) {
      return Column(
        children: [
          Expanded(
            child: Container(
              height: bHeight,
              color: ApplicationColors.lightGrey,
              child: FadedSlideAnimation(
                child: getLength() < 1
                    ? Center(
                        child: CircularProgressIndicator(
                            color: theme.primaryColor),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: getLength(),
                        itemBuilder: (context, index) {
                          return CategoryWidget(
                            category:
                                Provider.of<CategoryVM>(context, listen: false)
                                    .getCategories()[index],
                            theme: theme,
                            community: community,
                            index: index,
                          );
                        },
                      ),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class CategoryWidget extends StatelessWidget {
  CategoryWidget(
      {Key? key,
      required this.category,
      required this.theme,
      required this.community,
      required this.index})
      : super(key: key);

  final AmityCommunityCategory category;
  final ThemeData theme;
  final AmityCommunity community;
  final int index;
  List<String> selectedCategoryIds = [];

  void buildSelectedCategoryIds(BuildContext context) {
    List<String> categoryIds = [];

    for (var category
        in Provider.of<CategoryVM>(context, listen: false).getCategories()) {
      categoryIds.add(category.categoryId!);
    }
    print(
        "check category ids ${categoryIds} === ${community.categoryIds != null}");
    if (community.categoryIds != null) {
      print("checking community category ids ${community.categoryIds}");
      for (var id in community.categoryIds!) {
        if (categoryIds.contains(id)) {
          print("category id has a match ${id}");
          selectedCategoryIds.add(id);
        }
      }
    }
  }

  bool checkIfSelected(String id) {
    print("selected category id ${selectedCategoryIds}");
    print("checking current id ${id}");
    return selectedCategoryIds.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    buildSelectedCategoryIds(context);
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => CommunityScreen(
        //           community: community,
        //         )));
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: FadeAnimation(
              child: (category.avatar?.fileUrl != null)
                  ? CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: (NetworkImage(category.avatar!.fileUrl)))
                  : CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/user_placeholder.png")),
            ),
            title: Text(
              category.name ?? "Category",
              style: theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: checkIfSelected(
                    Provider.of<CategoryVM>(context, listen: false)
                        .getCategories()[index]
                        .categoryId!)
                ? Icon(
                    Icons.check_rounded,
                    color: theme.primaryColor,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
