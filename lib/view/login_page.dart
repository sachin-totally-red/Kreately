import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/resource/login_repository.dart';
import 'package:nibbin_app/view/apple_sign_in.dart';
import 'package:nibbin_app/view/custom_widget/progress_indicator.dart';
import 'package:nibbin_app/view/custom_widget/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  final Size screenSize;
  final GlobalKey<ScaffoldState> pageScaffoldKey;

  LoginPage({@required this.screenSize, this.pageScaffoldKey});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showLoader = false;

  @override
  void initState() {
    Constants.rateMyApp.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse(
          AppVariants.completeMap[Constants.appName]["statusBarColor"])),
      child: SafeArea(
        bottom: false,
        child: CustomProgressIndicator(
          inAsyncCall: _showLoader,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              leading: Container(),
              backgroundColor: Color(int.parse(AppVariants
                  .completeMap[Constants.appName]["loginPageAppBarColor"])),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    AppVariants.completeMap[Constants.appName]
                        ["reportingCloseButton"],
                    height: 19.81,
                    width: 19.81,
                  ),
                ),
                SizedBox(
                  width: 18,
                ),
              ],
            ),
            body: Container(
              color: Color(int.parse(AppVariants.completeMap[Constants.appName]
                  ["loginPageBackgroundColor"])),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                        AppVariants.completeMap[Constants.appName]
                            ["loginPageBackgroundColor"])),
                    image: new DecorationImage(
                        image: AssetImage(
                          AppVariants.completeMap[Constants.appName]
                              ["searchPageBackgroundImage"],
                        ),
                        fit: BoxFit.fill),
                  ),
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Image.asset(
                          AppVariants.completeMap[Constants.appName]
                              ["loginPageAppLogoPath"],
                          height: MediaQuery.of(context).size.height * 77 / 640,
                          width: MediaQuery.of(context).size.width * 209 / 360,
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Image.asset(
                          AppVariants.completeMap[Constants.appName]
                              ["loginPageImagePath"],
                          width: MediaQuery.of(context).size.width *
                              (double.parse(
                                  AppVariants.completeMap[Constants.appName]
                                      ["loginPageImageWidth"])) /
                              360,
                          height: MediaQuery.of(context).size.height *
                              (double.parse(
                                  AppVariants.completeMap[Constants.appName]
                                      ["loginPageImageHeight"])) /
                              640,
                        ),
                        SizedBox(
                          height: 38,
                        ),
                        Text(
                          "Connect your account to Bookmark stories.",
                          style: TextStyle(
                              color: Color(int.parse(
                                  AppVariants.completeMap[Constants.appName]
                                      ["loginPageTextColor"])),
                              fontSize: 14,
                              letterSpacing: 0.14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "(Or you’d see Emily’s bookmarks too.)",
                          style: TextStyle(
                              color: Color(int.parse(
                                  AppVariants.completeMap[Constants.appName]
                                      ["loginPageTextColor"])),
                              fontSize: 14,
                              letterSpacing: 0.14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 38,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 76 / 360),
                          child: Column(
                            children: [
                              SignInButton(
                                imagePath: 'assets/images/google_icon.png',
                                buttonText: "Continue with Google",
                                borderColor: Color(int.parse(
                                    AppVariants.completeMap[Constants.appName]
                                        ["loginPageSignInButtonBorderColor"])),
                                borderRadius:
                                    ((Constants.appName == "Kaavya") ? 4 : 25),
                                onPressed: () async {
                                  setState(() {
                                    _showLoader = true;
                                  });
                                  bool result = await LoginRepository.signIn(
                                      context: context,
                                      screenSize: widget.screenSize,
                                      scaffoldKey: _scaffoldKey);
                                  setState(() {
                                    _showLoader = false;
                                  });
                                  if (result) {
                                    Navigator.pop(context);
                                    if (widget.pageScaffoldKey != null)
                                      widget.pageScaffoldKey.currentState
                                          .showSnackBar(
                                              Constants.showSuccessfulLogin());
                                  }
                                },
                              ),
                              if (Platform.isIOS)
                                SizedBox(
                                  height: 12,
                                ),
                              if (Platform.isIOS)
                                SignInButton(
                                  imagePath: 'assets/images/apple_logo.png',
                                  buttonText: "Continue with Apple",
                                  borderColor: Color(int.parse(AppVariants
                                          .completeMap[Constants.appName]
                                      ["loginPageSignInButtonBorderColor"])),
                                  borderRadius: ((Constants.appName == "Kaavya")
                                      ? 4
                                      : 25),
                                  onPressed: () async {
                                    setState(() {
                                      _showLoader = true;
                                    });

                                    bool response = await appleSignIn(
                                        context: context,
                                        scaffoldKey: _scaffoldKey);
                                    setState(() {
                                      _showLoader = false;
                                    });
                                    if (response == null) {
                                      Navigator.pop(context);
                                      widget.pageScaffoldKey.currentState
                                          .showSnackBar(
                                              Constants.showCustomSnackBar(
                                                  errorText:
                                                      "Your device doesn't support this feature."));
                                      return;
                                    }
                                    if (response) {
                                      Navigator.pop(context);
                                      widget.pageScaffoldKey.currentState
                                          .showSnackBar(
                                              Constants.showSuccessfulLogin());
                                    }
                                  },
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
