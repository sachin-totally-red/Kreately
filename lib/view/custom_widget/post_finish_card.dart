import 'package:flutter/material.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/view/home_page.dart';

class NoPostLeftCard extends StatefulWidget {
  NoPostLeftCard({
    @required this.widget,
  });

  final HomePage widget;

  @override
  NoPostLeftCardState createState() => NoPostLeftCardState();
}

class NoPostLeftCardState extends State<NoPostLeftCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: (Constants.appName == "Kaavya")
          ? Colors.transparent
          : Color(0xFF1A101F),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 40, top: 20),
      child: Container(
        child: Column(
          children: <Widget>[
            Image.asset(
              AppVariants.completeMap[Constants.appName]
                  ["newsCaughtUpCardImagePath"],
              height: 211,
              width: 131,
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              "Hey! You're all caught up for today!",
              style: TextStyle(
                  color: (Constants.appName == "Kaavya")
                      ? Color(0xFF111111)
                      : Color(0xFFFFFFFF),
                  letterSpacing: 0.14,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Scroll down to look at older stories",
              style: TextStyle(
                color: (Constants.appName == "Kaavya")
                    ? Color(0xFF969696)
                    : Color(0xFFFFFFFF),
                letterSpacing: 0.12,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
