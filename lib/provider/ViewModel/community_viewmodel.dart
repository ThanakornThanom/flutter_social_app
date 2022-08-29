import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

import '../../components/alert_dialog.dart';

enum CommunityListType { my, recommend, trending }

enum CommunityFeedMenuOption { edit, members }

enum CommunityType { public, private }

class CommunityVM extends ChangeNotifier {
  var _amityTrendingCommunities = <AmityCommunity>[];
  var _amityRecommendCommunities = <AmityCommunity>[];
  var _amityMyCommunities = <AmityCommunity>[];

  late PagingController<AmityCommunity> _controller;

  List<AmityCommunity> getAmityTrendingCommunities() {
    return _amityTrendingCommunities;
  }

  List<AmityCommunity> getAmityRecommendCommunities() {
    return _amityRecommendCommunities;
  }

  List<AmityCommunity> getAmityMyCommunities() {
    return _amityMyCommunities;
  }

  void initAmityTrendingCommunityList() async {
    log("initAmityTrendingCommunityList");

    if (_amityTrendingCommunities.isNotEmpty) {
      _amityTrendingCommunities.clear();
      notifyListeners();
    }

    AmitySocialClient.newCommunityRepository()
        .getTrendingCommunities()
        .then((List<AmityCommunity> trendingCommunites) {
      _amityTrendingCommunities = trendingCommunites;
      notifyListeners();
    }).onError((error, stackTrace) async {
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  Future<void> updateCommunity(
      String communityId,
      AmityImage? avatar,
      String displayName,
      String description,
      List<String> categoryIds,
      bool isPublic) async {
    if (avatar != null) {
      AmitySocialClient.newCommunityRepository()
          .updateCommunity(communityId)
          .avatar(avatar)
          .displayName(displayName)
          .description(description)
          .categoryIds(categoryIds)
          .isPublic(isPublic)
          .update()
          .then((value) => notifyListeners())
          .onError((error, stackTrace) async {
        await AmityDialog()
            .showAlertErrorDialog(title: "Error!", message: error.toString());
      });
    } else {
      AmitySocialClient.newCommunityRepository()
          .updateCommunity(communityId)
          .displayName(displayName)
          .description(description)
          .categoryIds(categoryIds)
          .isPublic(isPublic)
          .update()
          .then((value) => notifyListeners())
          .onError((error, stackTrace) async {
        await AmityDialog()
            .showAlertErrorDialog(title: "Error!", message: error.toString());
      });
    }
  }

  void initAmityRecommendCommunityList() async {
    log("initAmityRecommendCommunityList");
    if (_amityRecommendCommunities.isNotEmpty) {
      _amityRecommendCommunities.clear();
      notifyListeners();
    }

    AmitySocialClient.newCommunityRepository()
        .getRecommendedCommunities()
        .then((List<AmityCommunity> recommendCommunites) async {
      _amityRecommendCommunities = recommendCommunites;
      notifyListeners();
    }).onError((error, stackTrace) async {
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  void joinCommunity(String communityId, {CommunityListType? type}) async {
    AmitySocialClient.newCommunityRepository()
        .joinCommunity(communityId)
        .then((value) {
      if (type != null) {
        refreshCommunity(type);
      }

      notifyListeners();
    }).onError((error, stackTrace) async {
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  void leaveCommunity(String communityId, {CommunityListType? type}) async {
    AmitySocialClient.newCommunityRepository()
        .leaveCommunity(communityId)
        .then((value) {
      if (type != null) {
        refreshCommunity(type);
      }
      notifyListeners();
    }).onError((error, stackTrace) async {
      await AmityDialog()
          .showAlertErrorDialog(title: "Error!", message: error.toString());
    });
  }

  void refreshCommunity(CommunityListType type) {
    switch (type) {
      case CommunityListType.my:
        initAmityMyCommunityList();
        break;
      case CommunityListType.recommend:
        initAmityRecommendCommunityList();
        break;
      case CommunityListType.trending:
        initAmityTrendingCommunityList();
        break;
      default:
        break;
    }
  }

  void initAmityMyCommunityList() async {
    log("initAmityMyCommunityList");
    if (_amityMyCommunities.isNotEmpty) {
      _amityMyCommunities.clear();
      notifyListeners();
    }

    AmitySocialClient.newCommunityRepository()
        .getCommunities()
        .filter(AmityCommunityFilter.MEMBER)
        .sortBy(AmityCommunitySortOption.LAST_CREATED)
        .includeDeleted(false)
        .getPagingData(limit: 100)
        .then((value) {
      _amityMyCommunities = value.data;
      notifyListeners();
    });
  }
}
