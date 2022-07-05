import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_navigation/app_navigation.dart';

class PageRoutes {
  static const String appNavigation = 'app_navigation';

  Map<String, WidgetBuilder> routes() {
    return {
      appNavigation: (context) => AppNavigation(),
    };
  }
}
