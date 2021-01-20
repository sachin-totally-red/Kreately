import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/bloc/bookmark_bloc.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/resource/sharing.dart';
import 'package:nibbin_app/view/custom_widget/post_card_widget.dart';
import 'package:nibbin_app/view/custom_widget/report_news.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/login_page.dart';
import 'package:nibbin_app/view/push_notification/notification_news.dart';
import 'package:flutter_screenutil/screenutil.dart';

class FullNewsPage extends StatefulWidget {
  final NotificationNewsPage notificationNewsPage;
  final PostCard postCard;

  FullNewsPage({this.notificationNewsPage, this.postCard});

  @override
  FullNewsPageState createState() => FullNewsPageState();
}

class FullNewsPageState extends State<FullNewsPage>
    with TickerProviderStateMixin {
  final _singleStoryPageScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: (MediaQuery.of(context).viewInsets.bottom >= 40.0
                ? MediaQuery.of(context).viewInsets.bottom - 40.0
                : MediaQuery.of(context).viewInsets.bottom)),
        child: Material(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          color: Colors.green,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              webViewHeader(context),
              Flexible(
                child: Stack(
                  children: [
                    if (widget.notificationNewsPage != null)
                      Container(
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: AssetImage(
                                AppVariants.completeMap[Constants.appName]
                                    ["homePageBackgroundImage"],
                              ),
                              fit: BoxFit.fill),
                        ),
                        color: Color(int.parse(AppVariants
                            .completeMap[Constants.appName]["statusBarColor"])),
                        child: SafeArea(
                          bottom: false,
                          child: Scaffold(
                            key: _singleStoryPageScaffoldKey,
                            backgroundColor: Constants.appName == "Kaavya"
                                ? Colors.transparent
                                : Color(int.parse(
                                    AppVariants.completeMap[Constants.appName]
                                        ["homePageBackgroundColor"])),
                            appBar: AppBar(
                              elevation: 0,
                              centerTitle: true,
                              backgroundColor: Color(int.parse(
                                  AppVariants.completeMap[Constants.appName]
                                      ["appBarColor"])),
                              leading: IconButton(
                                icon: ImageIcon(
                                  AssetImage(
                                    "assets/images/back_arrow.png",
                                  ),
                                  size: ScreenUtil()
                                      .setSp(14, allowFontScalingSelf: true),
                                  color: Constants.appName == "Kaavya"
                                      ? Color(0xFF1A101F)
                                      : Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              title: Image.asset(
                                AppVariants.completeMap[Constants.appName]
                                    ["appBarImagePath"],
                                width: MediaQuery.of(context).size.width *
                                    (double.parse(AppVariants
                                            .completeMap[Constants.appName]
                                        ["appBarLogoWidth"])) /
                                    360,
                                height: MediaQuery.of(context).size.height *
                                    (double.parse(AppVariants
                                            .completeMap[Constants.appName]
                                        ["appBarLogoHeight"])) /
                                    640,
                              ),
                            ),
                            floatingActionButtonLocation:
                                FloatingActionButtonLocation.centerFloat,
                            floatingActionButton: (widget.notificationNewsPage
                                        .bookmarksPageState ==
                                    null)
                                ? Container(
                                    height: ScreenUtil()
                                        .setSp(35, allowFontScalingSelf: true),
                                    width: ScreenUtil()
                                        .setSp(108, allowFontScalingSelf: true),
                                    child: FloatingActionButton.extended(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(150.0))),
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      label: Text(
                                        "News Feed",
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(14,
                                              allowFontScalingSelf: true),
                                          color: Color(0xFF1A101F),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.16,
                                        ),
                                      ),
                                      foregroundColor: Colors.black87,
                                    ),
                                  )
                                : null,
                            body: SingleChildScrollView(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Constants.appName == "Kaavya"
                                      ? Colors.transparent
                                      : Color(0xFF1A101F),
                                  image: new DecorationImage(
                                      image: AssetImage(
                                        AppVariants
                                                .completeMap[Constants.appName]
                                            ["bookmarkPageBackgroundImage"],
                                      ),
                                      fit: BoxFit.fill),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(bottom: 60),
                                  child: Column(
                                    children: [
                                      Card(
                                        margin: EdgeInsets.only(bottom: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                  child:
                                                      (widget.notificationNewsPage
                                                                  .news.type ==
                                                              "news")
                                                          ? Image.network(
                                                              widget
                                                                      .notificationNewsPage
                                                                      .news
                                                                      .imageSrc ??
                                                                  "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                                                              height: screenSize
                                                                      .height *
                                                                  177 /
                                                                  640,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                              frameBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      int frame,
                                                                      bool
                                                                          wasSynchronouslyLoaded) {
                                                                if (wasSynchronouslyLoaded) {
                                                                  return child;
                                                                }
                                                                return AnimatedOpacity(
                                                                  child: child,
                                                                  opacity:
                                                                      frame ==
                                                                              null
                                                                          ? 0
                                                                          : 1,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  curve: Curves
                                                                      .easeOut,
                                                                );
                                                              },
                                                            )
                                                          : Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      minHeight:
                                                                          200),
                                                              child:
                                                                  Image.network(
                                                                //TODO: Update this hardcoded image
                                                                widget
                                                                        .notificationNewsPage
                                                                        .news
                                                                        .imageSrc ??
                                                                    "https://i.picsum.photos/id/42/200/300.jpg?hmac=RFAv_ervDAXQ4uM8dhocFa6_hkOkoBLeRR35gF8OHgs",
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                                frameBuilder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    int frame,
                                                                    bool
                                                                        wasSynchronouslyLoaded) {
                                                                  if (wasSynchronouslyLoaded) {
                                                                    return child;
                                                                  }
                                                                  return AnimatedOpacity(
                                                                    child:
                                                                        child,
                                                                    opacity:
                                                                        frame ==
                                                                                null
                                                                            ? 0
                                                                            : 1,
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                    curve: Curves
                                                                        .easeOut,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                ),
                                                if (widget.notificationNewsPage
                                                        .news.type ==
                                                    "news")
                                                  Container(
                                                    height: screenSize.height *
                                                        177 /
                                                        640,
                                                    padding: EdgeInsets.only(
                                                        right: 23, bottom: 11),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                        widget
                                                                .notificationNewsPage
                                                                .news
                                                                .imageSourceName ??
                                                            "",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFBDBDBD),
                                                            fontSize: ScreenUtil()
                                                                .setSp(10,
                                                                    allowFontScalingSelf:
                                                                        true),
                                                            letterSpacing: 0.12,
                                                            height: 1.4),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 17,
                                                left: 17,
                                                right: 16,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    Text(
                                                      widget
                                                          .notificationNewsPage
                                                          .news
                                                          .headline,
                                                      style: TextStyle(
                                                        fontSize: (widget
                                                                    .notificationNewsPage
                                                                    .news
                                                                    .newsCategories
                                                                    .indexWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        "English") ==
                                                                0)
                                                            ? 16
                                                            : 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 1.4,
                                                        letterSpacing: 0.5,
                                                        color:
                                                            Color(0xFF111111),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 7,
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    SizedBox(
                                                      height: 14,
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    Html(
                                                      data:
                                                          """${widget.notificationNewsPage.news.longDesc}""",
                                                      style: {
                                                        "html": Style(
                                                          fontSize: FontSize(
                                                            ScreenUtil().setSp(
                                                                14,
                                                                allowFontScalingSelf:
                                                                    true),
                                                          ),
                                                          color: Constants
                                                                      .appName ==
                                                                  "Kaavya"
                                                              ? Color(
                                                                  0xFF4C4E51)
                                                              : Color(
                                                                  0xFF1A101F),
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 9,
                                                            right: 9,
                                                          ),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          textAlign:
                                                              TextAlign.left,
                                                          // fontFamily: Constants.appName == "Kaavya"
                                                          //     ? "IBM-Plex-Serif"
                                                          //     : "Roboto"
                                                        ),
                                                        "p": Style(
                                                          fontSize: FontSize(
                                                            ScreenUtil().setSp(
                                                                14,
                                                                allowFontScalingSelf:
                                                                    true),
                                                          ),
                                                          color: Constants
                                                                      .appName ==
                                                                  "Kaavya"
                                                              ? Color(
                                                                  0xFF4C4E51)
                                                              : Color(
                                                                  0xFF1A101F),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          textAlign:
                                                              TextAlign.left,
                                                          lineHeight: 1.2,
                                                          // fontFamily: Constants.appName == "Kaavya"
                                                          //     ? "IBM Plex Serif"
                                                          //     : "Roboto"
                                                        ),
                                                        "div": Style(
                                                          fontSize: FontSize(
                                                            ScreenUtil().setSp(
                                                                14,
                                                                allowFontScalingSelf:
                                                                    true),
                                                          ),
                                                          color: Constants
                                                                      .appName ==
                                                                  "Kaavya"
                                                              ? Color(
                                                                  0xFF4C4E51)
                                                              : Color(
                                                                  0xFF1A101F),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          textAlign:
                                                              TextAlign.left,
                                                          lineHeight: 2,
                                                          // fontFamily: Constants.appName == "Kaavya"
                                                          //     ? "IBM Plex Serif"
                                                          //     : "Roboto"
                                                        ),
                                                      },
                                                    ),
                                                  // Text(
                                                  //   widget.news.shortDesc,
                                                  //   style: TextStyle(
                                                  //     fontSize: ScreenUtil()
                                                  //         .setSp(12, allowFontScalingSelf: true),
                                                  //     letterSpacing: 0.14,
                                                  //     wordSpacing: 1.2,
                                                  //     height: 1.4,
                                                  //     color: Color(0xFF1A101F),
                                                  //   ),
                                                  // ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    SizedBox(
                                                      height: 13,
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    Text(
                                                      DateFormat.yMMMMd()
                                                          .format(DateTime
                                                              .parse(widget
                                                                  .notificationNewsPage
                                                                  .news
                                                                  .storyDate))
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFFBDBDBD),
                                                          fontSize: ScreenUtil()
                                                              .setSp(10,
                                                                  allowFontScalingSelf:
                                                                      true),
                                                          letterSpacing: 0.12,
                                                          height: 1.4),
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    Container(
                                                      color: Color(0xFFBDBDBD),
                                                      height: 0.5,
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    Text(
                                                      "${widget.notificationNewsPage.news.title}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF1A101F),
                                                          fontSize: ScreenUtil()
                                                              .setSp(12,
                                                                  allowFontScalingSelf:
                                                                      true),
                                                          letterSpacing: 0.14,
                                                          height: 1.4),
                                                    ),
                                                  if (widget
                                                          .notificationNewsPage
                                                          .news
                                                          .type ==
                                                      "news")
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                  Container(
                                                    color: Color(0xFFBDBDBD),
                                                    height: 0.5,
                                                  ),
                                                  SizedBox(
                                                    height: 19,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          //Reporting functionality
                                                          reportModalBottomSheet(
                                                              context,
                                                              widget
                                                                  .notificationNewsPage
                                                                  .news
                                                                  .id,
                                                              _singleStoryPageScaffoldKey);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/flag_icon.png',
                                                              height: 14.67,
                                                              width: 11,
                                                            ),
                                                            SizedBox(
                                                              height: 6.33,
                                                            ),
                                                            Text(
                                                              "Report",
                                                              style: TextStyle(
                                                                fontSize: ScreenUtil()
                                                                    .setSp(10,
                                                                        allowFontScalingSelf:
                                                                            true),
                                                                height: 1.3,
                                                                color: Color(
                                                                    0xFFBDBDBD),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          SharingRepository
                                                              .shareNewsEvent(
                                                                  widget
                                                                      .notificationNewsPage
                                                                      .news,
                                                                  context);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/share_icon.png',
                                                              height: 13,
                                                              width: 13,
                                                            ),
                                                            SizedBox(
                                                              height: 6.33,
                                                            ),
                                                            Text(
                                                              "Share",
                                                              style: TextStyle(
                                                                fontSize: ScreenUtil()
                                                                    .setSp(10,
                                                                        allowFontScalingSelf:
                                                                            true),
                                                                height: 1.3,
                                                                color: Color(
                                                                    0xFFBDBDBD),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          String
                                                              alreadyLoggedIn =
                                                              await getStringValuesSF(
                                                                      "googleID") ??
                                                                  await getStringValuesSF(
                                                                      "UserIDFirebaseAppleIdLogin");

                                                          if (alreadyLoggedIn ==
                                                                  null ||
                                                              alreadyLoggedIn
                                                                  .isEmpty) {
                                                            var response =
                                                                await Navigator
                                                                    .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginPage(
                                                                  pageScaffoldKey:
                                                                      _singleStoryPageScaffoldKey,
                                                                ),
                                                              ),
                                                            );
                                                            widget
                                                                .notificationNewsPage
                                                                .homePageState
                                                                .bloc
                                                                .fetchAllPosts();
                                                          } else {
                                                            if (!widget
                                                                .notificationNewsPage
                                                                .news
                                                                .bookmarked) {
                                                              BookmarkRepository
                                                                  _bookmarkRepository =
                                                                  BookmarkRepository();
                                                              await _bookmarkRepository
                                                                  .saveBookmark(
                                                                      widget
                                                                          .notificationNewsPage
                                                                          .news);
                                                              setState(() {
                                                                widget
                                                                    .notificationNewsPage
                                                                    .news
                                                                    .bookmarked = true;
                                                              });
                                                              widget
                                                                  .notificationNewsPage
                                                                  .homePageState
                                                                  .bloc
                                                                  .fetchAllPosts(
                                                                      bookmarkRemoved:
                                                                          true);
                                                              _singleStoryPageScaffoldKey
                                                                  .currentState
                                                                  .showSnackBar(
                                                                      Constants
                                                                          .showSuccessfulAddBookmarked());
                                                            } else {
                                                              //Remove saved bookmark
                                                              final bookmarkBloc =
                                                                  BookmarkBloc();
                                                              int result = await bookmarkBloc
                                                                  .deleteSelectedBookmark(
                                                                      id: widget
                                                                          .notificationNewsPage
                                                                          .news
                                                                          .id);
                                                              widget
                                                                  .notificationNewsPage
                                                                  .homePageState
                                                                  .bloc
                                                                  .fetchAllPosts(
                                                                      bookmarkRemoved:
                                                                          true);
                                                              setState(() {
                                                                widget
                                                                    .notificationNewsPage
                                                                    .news
                                                                    .bookmarked = false;
                                                              });
                                                              _singleStoryPageScaffoldKey
                                                                  .currentState
                                                                  .showSnackBar(
                                                                      Constants
                                                                          .showSuccessfulRemoveBookmarked());
                                                            }
                                                          }
                                                          widget
                                                              .notificationNewsPage
                                                              .bookmarksPageState
                                                              .bookmarkBloc
                                                              .fetchAllSavedBookmarks();
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              widget
                                                                      .notificationNewsPage
                                                                      .news
                                                                      .bookmarked
                                                                  ? "assets/images/bookmarked_story.png"
                                                                  : 'assets/images/ribbon_icon.png',
                                                              height: 14.67,
                                                              width: 11,
                                                            ),
                                                            SizedBox(
                                                              height: 6.33,
                                                            ),
                                                            Text(
                                                              "Bookmark",
                                                              style: TextStyle(
                                                                fontSize: ScreenUtil()
                                                                    .setSp(10,
                                                                        allowFontScalingSelf:
                                                                            true),
                                                                height: 1.3,
                                                                color: Color(
                                                                    0xFFBDBDBD),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 9,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Scaffold(
                        body: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16, left: 15, right: 15, top: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                    width: 0.5,
                                    color: Color(0xFF959595),
                                    style: (Constants.appName == "Kaavya")
                                        ? BorderStyle.solid
                                        : BorderStyle.none),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        child: Container(
                                          height: widget.postCard.homePage
                                                  .screenSize.height *
                                              177 /
                                              640,
                                          width: double.infinity,
                                          decoration: new BoxDecoration(
                                            color: Colors.black87,
                                            image: new DecorationImage(
                                                image: NetworkImage(widget
                                                    .postCard.post.imageSrc),
                                                fit: BoxFit.fill),
                                          ),
                                          child: Stack(
                                            children: [
                                              if (Constants.appName != "Kaavya")
                                                BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 3.0, sigmaY: 3.0),
                                                  child: new Container(
                                                    //you can change opacity with color here(I used black) for background.
                                                    decoration:
                                                        new BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5)),
                                                  ),
                                                ),
                                              Container(
                                                decoration: new BoxDecoration(),
                                                height: widget.postCard.homePage
                                                        .screenSize.height *
                                                    177 /
                                                    640,
                                                width: double.infinity,
                                                child: Image.network(
                                                  widget.postCard.post.imageSrc,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  fit: (Constants.appName !=
                                                          "Kaavya")
                                                      ? BoxFit.contain
                                                      : BoxFit.fill,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                  frameBuilder: (BuildContext
                                                          context,
                                                      Widget child,
                                                      int frame,
                                                      bool
                                                          wasSynchronouslyLoaded) {
                                                    if (wasSynchronouslyLoaded) {
                                                      return child;
                                                    }
                                                    return AnimatedOpacity(
                                                      child: child,
                                                      opacity:
                                                          frame == null ? 0 : 1,
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      curve: Curves.easeOut,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (widget
                                              .postCard.post.imageSourceName !=
                                          null)
                                        Container(
                                          height: widget.postCard.homePage
                                                  .screenSize.height *
                                              177 /
                                              640,
                                          padding: EdgeInsets.only(
                                              right: 23, bottom: 11),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              widget.postCard.post
                                                  .imageSourceName,
                                              style: TextStyle(
                                                  color: Color(0xFFBDBDBD),
                                                  fontSize: ScreenUtil().setSp(
                                                      10,
                                                      allowFontScalingSelf:
                                                          true),
                                                  letterSpacing: 0.12,
                                                  height: 1.4),
                                            ),
                                          ),
                                        ),
                                      if (widget.postCard.post.bookmarked &&
                                          (Constants.appName != "Kaavya"))
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(int.parse(AppVariants
                                                                  .completeMap[
                                                              Constants.appName]
                                                          [
                                                          "bookmarkedCardShadowColor"]))
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 15,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Image.asset(
                                              AppVariants.completeMap[
                                                      Constants.appName][
                                                  "bookmarkedCardCornerImagePath"],
                                              height: 24,
                                              width: 24,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 17,
                                            left: 17,
                                            right: 16,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.postCard.post.headline,
                                                style: TextStyle(
                                                  fontSize: (widget
                                                              .postCard
                                                              .post
                                                              .newsCategories
                                                              .indexWhere(
                                                                  (element) =>
                                                                      element
                                                                          .name ==
                                                                      "English") ==
                                                          0)
                                                      ? 16
                                                      : 18,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.4,
                                                  letterSpacing: 0.5,
                                                  color: Color(0xFF111111),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 7,
                                              ),
                                              SizedBox(
                                                height: ((widget.postCard.post
                                                            .longDesc)
                                                        .contains("</"))
                                                    ? 6
                                                    : 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Html(
                                          data:
                                              """${widget.postCard.post.longDesc}""",
                                          style: {
                                            "html": Style(
                                              fontSize: FontSize(
                                                ScreenUtil().setSp(14,
                                                    allowFontScalingSelf: true),
                                              ),
                                              color:
                                                  Constants.appName == "Kaavya"
                                                      ? Color(0xFF4C4E51)
                                                      : Color(0xFF1A101F),
                                              padding: EdgeInsets.only(
                                                left: 9,
                                                right: 9,
                                              ),
                                              alignment: Alignment.topLeft,
                                              textAlign: TextAlign.left,
                                              // fontFamily: Constants.appName == "Kaavya"
                                              //     ? "IBM-Plex-Serif"
                                              //     : "Roboto"
                                            ),
                                            "p": Style(
                                              fontSize: FontSize(
                                                ScreenUtil().setSp(14,
                                                    allowFontScalingSelf: true),
                                              ),
                                              color:
                                                  Constants.appName == "Kaavya"
                                                      ? Color(0xFF4C4E51)
                                                      : Color(0xFF1A101F),
                                              alignment: Alignment.topLeft,
                                              textAlign: TextAlign.left,
                                              lineHeight: 1.2,
                                              // fontFamily: Constants.appName == "Kaavya"
                                              //     ? "IBM Plex Serif"
                                              //     : "Roboto"
                                            ),
                                            "div": Style(
                                              fontSize: FontSize(
                                                ScreenUtil().setSp(14,
                                                    allowFontScalingSelf: true),
                                              ),
                                              color:
                                                  Constants.appName == "Kaavya"
                                                      ? Color(0xFF4C4E51)
                                                      : Color(0xFF1A101F),
                                              alignment: Alignment.topLeft,
                                              textAlign: TextAlign.left,
                                              lineHeight: 2,
                                              // fontFamily: Constants.appName == "Kaavya"
                                              //     ? "IBM Plex Serif"
                                              //     : "Roboto"
                                            ),
                                          },
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 17,
                                            right: 16,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: ((widget.postCard.post
                                                            .longDesc)
                                                        .contains("</"))
                                                    ? 5
                                                    : 13,
                                              ),
                                              Text(
                                                DateFormat.yMMMMd()
                                                    .format(DateTime.parse(
                                                        widget.postCard.post
                                                            .storyDate))
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xFFBDBDBD),
                                                    fontSize: ScreenUtil().setSp(
                                                        10,
                                                        allowFontScalingSelf:
                                                            true),
                                                    letterSpacing: 0.12,
                                                    height: 1.4),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                color: Color(0xFFBDBDBD),
                                                height: 0.5,
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "${widget.postCard.post.title}",
                                                style: TextStyle(
                                                    color: Color(0xFF1A101F),
                                                    fontSize: ScreenUtil().setSp(
                                                        12,
                                                        allowFontScalingSelf:
                                                            true),
                                                    letterSpacing: 0.14,
                                                    height: 1.4),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Container(
                                                color: Color(0xFFBDBDBD),
                                                height: 0.5,
                                              ),
                                              SizedBox(
                                                height: 19,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      //Reporting functionality
                                                      reportModalBottomSheet(
                                                          context,
                                                          widget
                                                              .postCard.post.id,
                                                          widget.postCard
                                                              .homePageScaffoldKey,
                                                          homePageWidget: true);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/flag_icon.png',
                                                          height: 14.67,
                                                          width: 11,
                                                        ),
                                                        SizedBox(
                                                          height: 6.33,
                                                        ),
                                                        Text(
                                                          "Report",
                                                          style: TextStyle(
                                                            fontSize: ScreenUtil()
                                                                .setSp(10,
                                                                    allowFontScalingSelf:
                                                                        true),
                                                            height: 1.3,
                                                            color: Color(
                                                                0xFFBDBDBD),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      SharingRepository
                                                          .shareNewsEvent(
                                                              widget.postCard
                                                                  .post,
                                                              context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/share_icon.png',
                                                          height: 13,
                                                          width: 13,
                                                        ),
                                                        SizedBox(
                                                          height: 6.33,
                                                        ),
                                                        Text(
                                                          "Share",
                                                          style: TextStyle(
                                                            fontSize: ScreenUtil()
                                                                .setSp(10,
                                                                    allowFontScalingSelf:
                                                                        true),
                                                            height: 1.3,
                                                            color: Color(
                                                                0xFFBDBDBD),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      String alreadyLoggedIn =
                                                          await getStringValuesSF(
                                                                  "googleID") ??
                                                              await getStringValuesSF(
                                                                  "UserIDFirebaseAppleIdLogin");

                                                      if (alreadyLoggedIn ==
                                                              null ||
                                                          alreadyLoggedIn
                                                              .isEmpty) {
                                                        var response =
                                                            await Navigator
                                                                .push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    LoginPage(
                                                              pageScaffoldKey:
                                                                  widget
                                                                      .postCard
                                                                      .homePageScaffoldKey,
                                                            ),
                                                          ),
                                                        );
                                                        widget.postCard
                                                            .homePageState.bloc
                                                            .fetchAllPosts();
                                                      } else {
                                                        if (!widget.postCard
                                                            .post.bookmarked) {
                                                          BookmarkRepository
                                                              _bookmarkRepository =
                                                              BookmarkRepository();
                                                          await _bookmarkRepository
                                                              .saveBookmark(
                                                                  widget
                                                                      .postCard
                                                                      .post);
                                                          setState(() {
                                                            widget.postCard.post
                                                                    .bookmarked =
                                                                true;
                                                          });

                                                          widget
                                                              .postCard
                                                              .homePageScaffoldKey
                                                              .currentState
                                                              .showSnackBar(
                                                                  Constants
                                                                      .showSuccessfulAddBookmarked());
                                                          //In case of shared news, refreshing home page feeds
                                                          if (widget.postCard
                                                                  .homePageWidget ==
                                                              null)
                                                            homePageState.bloc
                                                                .fetchAllPosts(
                                                                    bookmarkRemoved:
                                                                        true);
                                                        } else {
                                                          //Remove saved bookmark
                                                          final bookmarkBloc =
                                                              BookmarkBloc();
                                                          int result =
                                                              await bookmarkBloc
                                                                  .deleteSelectedBookmark(
                                                                      id: widget
                                                                          .postCard
                                                                          .post
                                                                          .id);

                                                          homePageState.bloc
                                                              .fetchAllPosts(
                                                                  bookmarkRemoved:
                                                                      true);
                                                          setState(() {
                                                            widget.postCard.post
                                                                    .bookmarked =
                                                                false;
                                                          });
                                                          widget
                                                              .postCard
                                                              .homePageScaffoldKey
                                                              .currentState
                                                              .showSnackBar(
                                                                  Constants
                                                                      .showSuccessfulRemoveBookmarked());
                                                        }
                                                      }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Image.asset(
                                                          widget.postCard.post
                                                                  .bookmarked
                                                              ? AppVariants
                                                                          .completeMap[
                                                                      Constants
                                                                          .appName]
                                                                  [
                                                                  "bookmarkedNewsBookmarkIcon"]
                                                              : 'assets/images/ribbon_icon.png',
                                                          height: 14.67,
                                                          width: 11,
                                                        ),
                                                        SizedBox(
                                                          height: 6.33,
                                                        ),
                                                        Text(
                                                          "Bookmark",
                                                          style: TextStyle(
                                                            fontSize: ScreenUtil()
                                                                .setSp(10,
                                                                    allowFontScalingSelf:
                                                                        true),
                                                            height: 1.3,
                                                            color: Color(
                                                                0xFFBDBDBD),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 9,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
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
            : Color(
                int.parse(
                    AppVariants.completeMap[Constants.appName]["appBarColor"]),
              ),
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

Future openFullNewsPage(BuildContext context, Widget pageWidget) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (BuildContext bc) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: pageWidget,
      );
    },
  );
}
