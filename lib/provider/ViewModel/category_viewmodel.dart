import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class CategoryVM extends ChangeNotifier {
  var _categories = <AmityCommunityCategory>[];

  List<AmityCommunityCategory> getCategories() {
    return _categories;
  }

  void initCategoryList() async {
    log("initAmityTrendingCommunityList");

    if (_categories.isNotEmpty) {
      _categories.clear();
      notifyListeners();
    }

    AmitySocialClient.newCommunityRepository()
        .getCategories()
        .sortBy(AmityCommunityCategorySortOption.NAME)
        .includeDeleted(false)
        .getPagingData()
        .then((communityCategories) => {
              _categories = communityCategories.data,
              notifyListeners()
            });
    // .onError((error, stackTrace) {
    //   handle error
    // });
  }

  void selectCategory() async {}
}
