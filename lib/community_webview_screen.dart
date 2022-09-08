import 'package:flutter/cupertino.dart';
import 'package:webviewx/webviewx.dart';

class AmityCommunityWebPage extends StatefulWidget {
  @override
  AmityCommunityWebPageState createState() => AmityCommunityWebPageState();
}

class AmityCommunityWebPageState extends State<AmityCommunityWebPage> {
  late WebViewXController webviewController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WebViewX(
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        initialContent: "https://community.amity.co",
        initialSourceType: SourceType.url,
        onWebViewCreated: (controller) => webviewController = controller);
  }
}
