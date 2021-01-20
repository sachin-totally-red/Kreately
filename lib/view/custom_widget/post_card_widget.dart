import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nibbin_app/bloc/bookmark_bloc.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/amplitude_repository.dart';
import 'package:nibbin_app/resource/bookmark_repository.dart';
import 'package:nibbin_app/resource/sharing.dart';
import 'package:nibbin_app/resource/track_data_repository.dart';
import 'package:nibbin_app/view/custom_widget/report_news.dart';
import 'package:nibbin_app/view/full_news_page.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'package:nibbin_app/view/login_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

//TODO: Prepare below list of element for tracking user behaviour
//1. Tracked NewsID
//2. List of Elapsed time while reading the news
//3. Sum of elapsed time while reading the news
//4. List of Start & End Time while reading the news
//5. Total Count of tapping on "View Full Article"
//6. Start time of tapping on "View Full Article" and End Time of closing View Full News Web View

class PostCard extends StatefulWidget {
  PostCard(
      {@required this.homePage,
      @required this.post,
      this.homePageState,
      this.homePageScaffoldKey,
      this.deviceToken,
      this.homePageWidget});

  final HomePage homePage;
  final Post post;
  final HomePageState homePageState;
  final GlobalKey<ScaffoldState> homePageScaffoldKey;
  final String deviceToken;
  final bool homePageWidget;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // Stopwatch _stopwatch = new Stopwatch();
  // TrackDataRepository _trackDataRepository = TrackDataRepository();
  // AmplitudeRepository _amplitudeRepository = AmplitudeRepository();
  String currentCardID = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      /*child: VisibilityDetector(
        key: Key(widget.post.id.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (currentCardID == widget.post.id.toString()) {
            if (info.visibleFraction > 0.6) {
              Duration elapsedTime = _stopwatch.elapsed;
              print(elapsedTime.toString() + " widget ID ${widget.post.id}");
              */ /*if (_stopwatch.elapsed > Duration(seconds: 8)) {
                print("News read kar li bhai user ne ${widget.post.title}");
              }*/ /*
            } else {
              _stopwatch.stop();
              _trackDataRepository.stopTracking(widget.post.id);
              currentCardID = "";
              AmplitudeRepository _amplitudeRepository = AmplitudeRepository();
              //Send data to Amplitude
              // _amplitudeRepository.trackNewsCardReadSession(widget.post.id,
              //     widget.deviceToken, widget.post.newsCategories);
            }
          } else {
            if (info.visibleFraction > 0.6) {
              currentCardID = widget.post.id.toString();
              _stopwatch.start();
              _trackDataRepository.startTracking(widget.post.id);
              print(
                  "Visibility started of widget ID ${widget.post.id} and image source ${widget.post.imageSourceName} ");
            }
          }
        },*/
      child: Container(
        /*child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),*/
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
                    height: widget.homePage.screenSize.height * 177 / 640,
                    width: double.infinity,
                    decoration: new BoxDecoration(
                      color: Colors.black87,
                      image: new DecorationImage(
                          image: NetworkImage(widget.post.imageSrc),
                          fit: BoxFit.fill),
                    ),
                    child: Stack(
                      children: [
                        if (Constants.appName != "Kaavya")
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                            child: new Container(
                              //you can change opacity with color here(I used black) for background.
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        Container(
                          decoration: new BoxDecoration(),
                          height: widget.homePage.screenSize.height * 177 / 640,
                          width: double.infinity,
                          child: Image.network(
                            widget.post.imageSrc,
                            height: double.infinity,
                            width: double.infinity,
                            fit: (Constants.appName != "Kaavya")
                                ? BoxFit.contain
                                : BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                            frameBuilder: (BuildContext context, Widget child,
                                int frame, bool wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                child: child,
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.post.imageSourceName != null)
                  Container(
                    height: widget.homePage.screenSize.height * 177 / 640,
                    padding: EdgeInsets.only(right: 23, bottom: 11),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget.post.imageSourceName,
                        style: TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontSize: ScreenUtil()
                                .setSp(10, allowFontScalingSelf: true),
                            letterSpacing: 0.12,
                            height: 1.4),
                      ),
                    ),
                  ),
                if (widget.post.bookmarked && (Constants.appName != "Kaavya"))
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Color(int.parse(
                                    AppVariants.completeMap[Constants.appName]
                                        ["bookmarkedCardShadowColor"]))
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppVariants.completeMap[Constants.appName]
                            ["bookmarkedCardCornerImagePath"],
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          widget.post.headline,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              (widget.post.newsCategories != null &&
                                      (widget.post.newsCategories.indexWhere(
                                              (element) =>
                                                  element.name == "English") ==
                                          0))
                                  ? 16
                                  : 18,
                              allowFontScalingSelf: true,
                            ),
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            letterSpacing: 0.5,
                            color: Constants.appName == "Kaavya"
                                ? Color(0xFF111111)
                                : Color(0xFF111111),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 7,
                        ),
                        SizedBox(
                          height:
                              ((widget.post.shortDesc).contains("</")) ? 6 : 14,
                        ),
                      ],
                    ),
                  ),
                  Html(
                    data: """${widget.post.shortDesc}""",
                    style: {
                      "html": Style(
                        fontSize: FontSize(
                          ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        ),
                        color: Constants.appName == "Kaavya"
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
                          ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        ),
                        color: Constants.appName == "Kaavya"
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
                          ScreenUtil().setSp(14, allowFontScalingSelf: true),
                        ),
                        color: Constants.appName == "Kaavya"
                            ? Color(0xFF4C4E51)
                            : Color(0xFF1A101F),
                        alignment: Alignment.topLeft,
                        textAlign: TextAlign.left,
                        lineHeight: 2,
                        // lineHeight: 1.5,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height:
                              ((widget.post.shortDesc).contains("</")) ? 5 : 13,
                        ),
                        Text(
                          DateFormat.yMMMMd()
                              .format(DateTime.parse(widget.post.storyDate))
                              .toString(),
                          style: TextStyle(
                              color: Color(0xFFBDBDBD),
                              fontSize: ScreenUtil()
                                  .setSp(10, allowFontScalingSelf: true),
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
                          "${widget.post.title}",
                          style: TextStyle(
                              color: Color(0xFF1A101F),
                              fontSize: ScreenUtil()
                                  .setSp(12, allowFontScalingSelf: true),
                              letterSpacing: 0.14,
                              height: 1.4),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        if ((widget.post.longDesc != null &&
                                widget.post.longDesc.isNotEmpty) ||
                            (widget.post.link != null &&
                                widget.post.link.isNotEmpty))
                          InkWell(
                            onTap: () async {
                              /*_trackDataRepository
                              .startTrackingFullViewArticle(widget.post.id);*/
                              try {
                                // Stopwatch _stopwatchNew = Stopwatch();
                                // _stopwatchNew.start();
                                if (widget.post.longDesc != null &&
                                    widget.post.longDesc.isNotEmpty) {
                                  await openFullNewsPage(
                                      context,
                                      FullNewsPage(
                                        postCard: widget,
                                      ));
                                  // await Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => FullNewsPage(
                                  //       postCard: widget,
                                  //     ),
                                  //   ),
                                  // );
                                } else {
                                  /*var viewFullNews = */ await openWebView(
                                      context, widget.post.link);
                                }
                                /*_trackDataRepository
                              .stopTrackingFullViewArticle(widget.post.id);*/

                                // _stopwatchNew.stop();
                                // _amplitudeRepository.viewFullArticleEvent(
                                //     widget.post.id,
                                //     _stopwatchNew.elapsed.inSeconds,
                                //     widget.post.newsCategories);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 4.0, bottom: 4.0, top: 4.0),
                              child: Text(
                                AppVariants.completeMap[Constants.appName]
                                    ["viewFullArticleText"],
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(12, allowFontScalingSelf: true),
                                    color: Color(int.parse(AppVariants
                                            .completeMap[Constants.appName]
                                        ["viewFullArticleColor"])),
                                    letterSpacing: 0.14,
                                    height: 1.4),
                              ),
                            ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                //Reporting functionality
                                reportModalBottomSheet(context, widget.post.id,
                                    widget.homePageScaffoldKey,
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
                                      fontSize: ScreenUtil().setSp(10,
                                          allowFontScalingSelf: true),
                                      height: 1.3,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                SharingRepository.shareNewsEvent(
                                    widget.post, context);
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
                                      fontSize: ScreenUtil().setSp(10,
                                          allowFontScalingSelf: true),
                                      height: 1.3,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String alreadyLoggedIn =
                                    await getStringValuesSF("googleID") ??
                                        await getStringValuesSF(
                                            "UserIDFirebaseAppleIdLogin");

                                if (alreadyLoggedIn == null ||
                                    alreadyLoggedIn.isEmpty) {
                                  var response = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                        pageScaffoldKey:
                                            widget.homePageScaffoldKey,
                                      ),
                                    ),
                                  );
                                  widget.homePageState.bloc.fetchAllPosts();
                                } else {
                                  if (!widget.post.bookmarked) {
                                    BookmarkRepository _bookmarkRepository =
                                        BookmarkRepository();
                                    await _bookmarkRepository
                                        .saveBookmark(widget.post);
                                    setState(() {
                                      widget.post.bookmarked = true;
                                    });

                                    widget.homePageScaffoldKey.currentState
                                        .showSnackBar(Constants
                                            .showSuccessfulAddBookmarked());
                                    //In case of shared news, refreshing home page feeds
                                    if (widget.homePageWidget == null)
                                      homePageState.bloc
                                          .fetchAllPosts(bookmarkRemoved: true);
                                  } else {
                                    //Remove saved bookmark
                                    final bookmarkBloc = BookmarkBloc();
                                    int result = await bookmarkBloc
                                        .deleteSelectedBookmark(
                                            id: widget.post.id);

                                    homePageState.bloc
                                        .fetchAllPosts(bookmarkRemoved: true);
                                    setState(() {
                                      widget.post.bookmarked = false;
                                    });
                                    widget.homePageScaffoldKey.currentState
                                        .showSnackBar(Constants
                                            .showSuccessfulRemoveBookmarked());
                                  }
                                }
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    widget.post.bookmarked
                                        ? AppVariants
                                                .completeMap[Constants.appName]
                                            ["bookmarkedNewsBookmarkIcon"]
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
                                      fontSize: ScreenUtil().setSp(10,
                                          allowFontScalingSelf: true),
                                      height: 1.3,
                                      color: Color(0xFFBDBDBD),
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
      // ),
      /*),*/
    );
  }
}
