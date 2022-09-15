// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:optimized_cached_image/optimized_cached_image.dart';

// getAvatarImage(String? url, {double? radius, String? fileId}) {
//   if (url != null) {
//     var imageOPS = OptimizedCacheImage(
//       imageBuilder: (context, imageProvider) => Container(
//         child: CircleAvatar(
//             radius: radius,
//             backgroundColor: Colors.transparent,
//             backgroundImage: (imageProvider)),
//       ),
//       imageUrl: url,
//       fit: BoxFit.fill,
//       placeholder: (context, url) => CircleAvatar(
//           radius: radius,
//           backgroundColor: Colors.transparent,
//           backgroundImage: AssetImage("assets/images/user_placeholder.png")),
//       errorWidget: (context, url, error) => Icon(Icons.error),
//     );
//     return imageOPS;
//   } else if (fileId != null) {
//     var imageOPS = OptimizedCacheImage(
//       imageBuilder: (context, imageProvider) => CircleAvatar(
//           backgroundColor: Colors.transparent,
//           backgroundImage: (imageProvider)),
//       imageUrl:
//           "https://api.${dotenv.env["REGION"]}.amity.co/api/v3/files/${fileId}/download?size=full",
//       fit: BoxFit.fill,
//       placeholder: (context, url) => CircleAvatar(
//           radius: radius,
//           backgroundColor: Colors.transparent,
//           backgroundImage: AssetImage("assets/images/user_placeholder.png")),
//       errorWidget: (context, url, error) => Icon(Icons.error),
//     );
//     return imageOPS;
//   } else {
//     return CircleAvatar(
//         radius: radius,
//         backgroundColor: Colors.transparent,
//         backgroundImage: AssetImage("assets/images/user_placeholder.png"));
//   }
// }

// getImageProvider(String? url) {
//   if (url != null) {
//     return NetworkImage(url);
//   } else {
//     return AssetImage("assets/images/user_placeholder.png");
//   }
// }
