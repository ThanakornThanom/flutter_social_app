import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

getAvatarImage(String? url, {double? radius}) {
  if (url != null) {
    var imageOPS = OptimizedCacheImage(
      imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: (imageProvider)),
      imageUrl: url,
      fit: BoxFit.fill,
      placeholder: (context, url) => CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage("assets/images/user_placeholder.png")),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
    return imageOPS;
  } else {
    return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/images/user_placeholder.png"));
  }
}

getImageProvider(String? url) {
  if (url != null) {
    return NetworkImage(url);
  } else {
    return AssetImage("assets/images/user_placeholder.png");
  }
}
