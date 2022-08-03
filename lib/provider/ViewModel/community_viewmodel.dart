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

  void initAmityMyCommunityList() async {
    log("initAmityMyCommunityList");
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
