import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/resource/app_rating.dart';
import 'package:nibbin_app/resource/login_repository.dart';
import 'package:nibbin_app/resource/notification_repository.dart';
import 'package:nibbin_app/resource/sharing.dart';
import 'package:nibbin_app/view/bookmarks.dart';
import 'package:nibbin_app/view/category_selection_page.dart';
import 'package:nibbin_app/view/custom_widget/drawer_option.dart';
import 'package:nibbin_app/view/custom_widget/sign_in_button.dart';
import 'package:nibbin_app/view/login_page.dart';
import 'package:nibbin_app/view/privacy_page.dart';
import 'package:nibbin_app/view/t&c_page.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer(
      {@required this.widget,
      @required this.homePageScaffoldKey,
      @required this.homePageState});

  final HomePage widget;
  final GlobalKey<ScaffoldState> homePageScaffoldKey;
  final HomePageState homePageState;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showLoader = false;
  bool userAlreadyLoggedIn = false;
  bool pushNotificationOn = true;

  @override
  void initState() {
    checkUserLoggedIn().then((value) async {
      String response = await getStringValuesSF("pushNotification");

      this.setState(() {
        userAlreadyLoggedIn = value;
        showLoader = true;
        if (response == null)
          addStringToSF("pushNotification", "YES");
        else if (response == "NO") pushNotificationOn = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return showLoader
        ? Container(
            width: widget.widget.screenSize.width * 296 / 360,
            child: Drawer(
              child: ListView(
                physics: (widget.widget.screenSize.height > 660.0)
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Container(
                    width: widget.widget.screenSize.width,
                    height: widget.widget.screenSize.height * 112 / 640,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/nibbin_logo.png',
                          height: MediaQuery.of(context).size.height * 77 / 640,
                          width: MediaQuery.of(context).size.width * 209 / 360,
                        ),
                      ],
                    ),
                  ),
                  DrawerOption(
                    screenSize: widget.widget.screenSize,
                    imagePath: 'assets/images/notifications_icon.png',
                    optionName: 'Push Notification',
                    trailingWidget: CupertinoSwitch(
                        value: pushNotificationOn,
                        onChanged: (value) async {
                          setState(() {
                            pushNotificationOn = value;
                          });
                          NotificationRepository _notificationRepository =
                              NotificationRepository();
                          await _notificationRepository
                              .updateFirebaseNotificationStatus(
                                  (value ? "YES" : "NO"));
                          await _notificationRepository
                              .updateApiNotificationStatus((value));
                        }),
                    onTap: () {},
                    imageHeight: 14.6,
                    imageWidth: 14.6,
                    space: 8.94,
                  ),
                  DrawerOption(
                    screenSize: widget.widget.screenSize,
                    imagePath: 'assets/images/ribbon_icon.png',
                    optionName: 'Bookmarks',
                    trailingWidget: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Image.asset(
                        'assets/images/arrow_right_icon.png',
                        height: widget.widget.screenSize.height * 8.71 / 640,
                        width: widget.widget.screenSize.width * 4.9 / 360,
                      ),
                    ),
                    onTap: () async {
                      String alreadyLoggedIn =
                          await getStringValuesSF("googleID");

                      if (alreadyLoggedIn != null)
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookmarksPage(
                                homePageState: widget.homePageState),
                          ),
                        );
                      else
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                    },
                    imageHeight: 14.67,
                    imageWidth: 11,
                    space: 10.5,
                  ),
                  DrawerOption(
                    screenSize: widget.widget.screenSize,
                    imagePath: 'assets/images/settings_icon.png',
                    optionName: 'Customise your interests',
                    trailingWidget: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Image.asset(
                        'assets/images/arrow_right_icon.png',
                        height: widget.widget.screenSize.height * 8.71 / 640,
                        width: widget.widget.screenSize.width * 4.9 / 360,
                      ),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorySelectionPage(
                              appBarTitle: "Customise your Interests",
                              userAlreadyLoggedIn: userAlreadyLoggedIn),
                        ),
                      );
                    },
                    imageHeight: 13.14,
                    imageWidth: 14.6,
                    space: 8.94,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 6, bottom: 12),
                    color: Color(0xFFBDBDBD),
                    child: SizedBox(
                      height: 0.5,
                    ),
                  ),
                  DrawerOption(
                    screenSize: widget.widget.screenSize,
                    imagePath: 'assets/images/share_icon.png',
                    optionName: 'Share this app',
                    onTap: () async {
                      SharingRepository.shareOnTap(context,
                          content: Platform.isAndroid
                              ? Constants.playStoreUrl
                              : Constants.appStoreUrl);
                    },
                    imageHeight: 12,
                    imageWidth: 12,
                    space: 10,
                  ),
                  DrawerOption(
                    screenSize: widget.widget.screenSize,
                    imagePath: Platform.isAndroid
                        ? "assets/images/play_store_icon.png"
                        : 'assets/images/app_store_icon.png',
                    optionName:
                        'Rate this app on ${Platform.isAndroid ? "Play" : "App"} Store',
                    onTap: () {
                      AppRatingRepository.rateApp(Constants.rateMyApp, context,
                          ignoreNativeAppRating: false);
                    },
                    imageHeight: 14.6,
                    imageWidth: 12.41,
                    space: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 6, bottom: 12),
                    color: Color(0xFFBDBDBD),
                    child: SizedBox(
                      height: 0.5,
                    ),
                  ),
                  DrawerOption(
                    screenSize: widget.widget.screenSize,
                    imagePath: 'assets/images/t&c_icon.png',
                    optionName: 'Terms & Conditions',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsConditionPage(),
                        ),
                      );
                    },
                    imageHeight: 18,
                    imageWidth: 18,
                    space: 4.5,
                  ),
                  DrawerOption(
                    screenSize: widget.widget.screenSize,
                    imagePath: 'assets/images/lock_icon.png',
                    optionName: 'Privacy',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyPage(),
                        ),
                      );
                    },
                    imageHeight: 14.37,
                    imageWidth: 12.5,
                    space: 9.99,
                  ),
                  userAlreadyLoggedIn
                      ? DrawerOption(
                          screenSize: widget.widget.screenSize,
                          imagePath: 'assets/images/exit_left_icon.png',
                          optionName: 'Logout',
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();

                            setState(() {
                              userAlreadyLoggedIn = false;
                            });
                            widget.homePageState.bloc.fetchAllPosts();
                            /*await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SplashScreen(),
                              ),
                            );*/
                          },
                          imageHeight: 14.6,
                          imageWidth: 14.6,
                          space: 8.94,
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              top: 18,
                              right:
                                  MediaQuery.of(context).size.width * 51 / 360,
                              left:
                                  MediaQuery.of(context).size.width * 51 / 360),
                          child: SignInButton(
                            imagePath: 'assets/images/google_icon.png',
                            buttonText: "Login using Google",
                            borderColor: Color(0xFF1A101F),
                            onPressed: () async {
                              bool response = await LoginRepository.signIn(
                                  context: context,
                                  screenSize: widget.widget.screenSize,
                                  scaffoldKey: widget.homePageScaffoldKey);
                              if (response) {
                                setState(() {
                                  userAlreadyLoggedIn = true;
                                });
                                widget.homePageState.bloc.fetchAllPosts();
                              }
                            },
                          ),
                        )
                ],
              ),
            ),
          )
        : Container();
  }
}

Future checkUserLoggedIn() async {
  String alreadyLoggedIn = await getStringValuesSF("googleID");
  if (alreadyLoggedIn != null && alreadyLoggedIn.isNotEmpty)
    return true;
  else
    return false;
}