import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String link;

  WebViewPage({@required this.link});

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool isLoading = true;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: (MediaQuery.of(context).viewInsets.bottom >= 40.0
                ? MediaQuery.of(context).viewInsets.bottom - 40.0
                : MediaQuery.of(context).viewInsets.bottom)),
        /*child: SlideTransition(
          position: _offsetAnimation,*/
        child: Material(
          shadowColor: Color(0xFF1A101F),
          color: Color(0xFF1A101F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              webViewHeader(context),
              Flexible(
                child: Stack(
                  children: [
                    PageView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        WebView(
                          gestureRecognizers: [
                            Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer()
                                ..onUpdate = (_) {},
                            )
                          ].toSet(),
                          initialUrl: widget.link,
                          javascriptMode: JavascriptMode.unrestricted,
                          onPageFinished: (finish) {
                            /*Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                isLoading = false;
                              });
                            });*/
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                      ],
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(),
                  ],
                ),
              )
            ],
          ),
        ),
        /*),*/
      ),
    );
  }

  Container webViewHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        color: Constants.appName == "Kaavya"
            ? Color(0xFFFFFFFF)
            : Color(int.parse(
                AppVariants.completeMap[Constants.appName]["appBarColor"])),
//        gradient: LinearGradient(
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            colors: [Color(0xFF1A101F), Colors.white]),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 6,
            ),
            child: SizedBox(
              height: 2,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 180,
                ),
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              AppVariants.completeMap[Constants.appName]["appLogoWhite"],
              width: MediaQuery.of(context).size.width *
                  (double.parse(AppVariants.completeMap[Constants.appName]
                      ["appBarLogoWidthOnWebView"])) /
                  360,
              height: MediaQuery.of(context).size.height *
                  (double.parse(AppVariants.completeMap[Constants.appName]
                      ["appBarLogoHeightOnWebView"])) /
                  640,
            ), /*Text(
              'Nibbin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),*/
          ),
          if (Constants.appName == "Kaavya")
            Container(
              margin: EdgeInsets.only(
                top: 6,
              ),
              height: 1,
              width: MediaQuery.of(context).size.width * 0.92,
              color: Color(0xFFD8D8D8),
            ),
        ],
      ),
    );
  }
}
