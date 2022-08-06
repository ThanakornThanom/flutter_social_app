import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

enum CommunityListType { my, recommend, trending }

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
        .then((List<AmityCommunity> trendingCommunites) =>
            {_amityTrendingCommunities = trendingCommunites, notifyListeners()})
        .onError((error, stackTrace) => {
              //handle error
            });
  }

  void initAmityRecommendCommunityList() async {
    log("initAmityRecommendCommunityList");
    if (_amityRecommendCommunities.isNotEmpty) {
      _amityRecommendCommunities.clear();
      notifyListeners();
    }

    AmitySocialClient.newCommunityRepository()
        .getRecommendedCommunities()
        .then((List<AmityCommunity> recommendCommunites) => {
              _amityRecommendCommunities = recommendCommunites,
              notifyListeners()
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }

  void joinCommunity(String communityId, CommunityListType type) async {
    AmitySocialClient.newCommunityRepository()
        .joinCommunity(communityId)
        .then((value) {
      refreshCommunity(type);
      notifyListeners();
    }).onError((error, stackTrace) {});
  }

  void leaveCommunity(String communityId, CommunityListType type) async {
    AmitySocialClient.newCommunityRepository()
        .leaveCommunity(communityId)
        .then((value) {
      refreshCommunity(type);
      notifyListeners();
    }).onError((error, stackTrace) {
      //handle error
    });
  }

  void refreshCommunity(CommunityListType type) {
    print("refresh community");
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
        .getPagingData()
        .then((value) {
      _amityMyCommunities = value.data;
      notifyListeners();
    });
  }
}
