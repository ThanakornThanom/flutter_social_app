import 'package:flutter/material.dart';

import 'package:linkwell/linkwell.dart';

class NeedUpdateScreen extends StatefulWidget {
  final url;
  const NeedUpdateScreen({Key? key, this.url}) : super(key: key);

  @override
  State<NeedUpdateScreen> createState() => _NeedUpdateScreenState();
}

class _NeedUpdateScreenState extends State<NeedUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Newer version application is now avaliable at"),
            SizedBox(
              height: 10,
            ),
            Container(
                width: 300,
                child: LinkWell(
                  widget.url,
                  textAlign: TextAlign.center,
                ))
          ],
        ))
      ]),
    );
  }
}
