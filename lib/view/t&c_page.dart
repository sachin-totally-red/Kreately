import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditionPage extends StatefulWidget {
  @override
  _TermsConditionPageState createState() => _TermsConditionPageState();
}

class _TermsConditionPageState extends State<TermsConditionPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse(
          AppVariants.completeMap[Constants.appName]["statusBarColor"])),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Constants.appName == "Kaavya"
              ? Colors.transparent
              : Color(int.parse(AppVariants.completeMap[Constants.appName]
                  ["t&cPageBackgroundColor"])),
          appBar: AppBar(
            backgroundColor: Color(int.parse(AppVariants
                .completeMap[Constants.appName]["t&cPageAppBarColor"])),
            centerTitle: false,
            elevation: 0,
            title: Text(
              "Terms & Conditions",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: (Constants.appName == "Kaavya")
                      ? Color(0xFF1A101F)
                      : Colors.white),
            ),
            leading: IconButton(
              icon: ImageIcon(
                AssetImage(
                  "assets/images/back_arrow.png",
                ),
                size: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                color: Constants.appName == "Kaavya"
                    ? Color(0xFF1A101F)
                    : Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Card(
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage(
                      AppVariants.completeMap[Constants.appName]
                          ["searchPageBackgroundImage"],
                    ),
                    fit: BoxFit.fill),
              ),
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(16),
              child: Stack(
                children: [
                  WebView(
                    initialUrl: Constants.termsConditionUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Stack(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
