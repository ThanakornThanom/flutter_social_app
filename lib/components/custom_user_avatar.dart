import 'package:flutter/widgets.dart';

getAvatarImage(String? url) {
  if (url != null) {
    return NetworkImage(url);
  } else {
    return AssetImage("assets/images/user_placeholder.png");
  }
}
