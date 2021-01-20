import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/bloc/bookmark_bloc.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/database_helpers.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/view/custom_widget/bookmark_widget.dart';
import 'package:nibbin_app/view/custom_widget/graphics_card.dart';
import 'package:nibbin_app/view/custom_widget/progress_indicator.dart';
import 'package:nibbin_app/view/home_page.dart';

import 'custom_widget/bookmarked_graphic_card.dart';

class BookmarksPage extends StatefulWidget {
  final HomePageState homePageState;

  BookmarksPage({this.homePageState});

  @override
  BookmarksPageState createState() => BookmarksPageState();
}

class BookmarksPageState extends State<BookmarksPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BookmarksPageState bookmarksPageState;
  final bookmarkBloc = BookmarkBloc();
  bool showLoader = false;

  TabController _tabController;
  List<SavedBookmarks> _savedBookmarksList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    bookmarkBloc.fetchAllSavedBookmarks();
    /*bookmarkBloc.fetchAllSavedGraphicsBookmarks(
        bookmarksPageState: bookmarksPageState);*/
  }

  @override
  void dispose() {
    bookmarkBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bookmarksPageState = this;
    return Container(
      decoration: BoxDecoration(
        color: Color(int.parse(
            AppVariants.completeMap[Constants.appName]["statusBarColor"])),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomProgressIndicator(
          inAsyncCall: showLoader,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Constants.appName == "Kaavya"
                ? Colors.transparent
                : Color(int.parse(AppVariants.completeMap[Constants.appName]
                    ["bookmarkPageBackgroundColor"])),
            appBar: AppBar(
              centerTitle: false,
              elevation: 0,
              backgroundColor: Color(int.parse(AppVariants
                  .completeMap[Constants.appName]["bookmarkPageAppBarColor"])),
              title: Text(
                "Bookmarks",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Constants.appName == "Kaavya"
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
            body: Container(
              decoration: BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage(
                      AppVariants.completeMap[Constants.appName]
                          ["bookmarkPageBackgroundImage"],
                    ),
                    fit: BoxFit.fill),
              ),
              child: StreamBuilder(
                stream: bookmarkBloc.allBookmarks,
                builder:
                    (context, AsyncSnapshot<List<SavedBookmarks>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index) {
                            int currentIndex = snapshot.data.length - index - 1;
                            if (snapshot.data[currentIndex].type == "news") {
                              return BookmarkWidget(
                                  bookmark: snapshot.data[currentIndex],
                                  bookmarksPageState: bookmarksPageState,
                                  homePageState: widget.homePageState);
                            } else {
                              return BookmarkedGraphicsCard(
                                  bookmark: snapshot
                                      .data[snapshot.data.length - index - 1],
                                  bookmarksPageState: bookmarksPageState,
                                  /*bookmark:
                      snapshot.data[snapshot.data.length - index - 1],
                      bookmarksPageState: bookmarksPageState,*/
                                  post: snapshot.data[currentIndex /*index*/
                                      ],
                                  homePageState: widget.homePageState);
                            }
                          });
                    } else
                      return noSavedBookmarkWidget(context);
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: Column(
                            children: [
                              Image(
                                image: AssetImage(
                                    "assets/images/maintenance_error_icon.png"),
                              ),
                              Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(14, allowFontScalingSelf: true),
                                    color: Constants.appName == "Kaavya"
                                        ? Colors.black87
                                        : Color(0xFFFFFFFF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

noSavedBookmarkWidget(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        image: new DecorationImage(
            image: AssetImage(
              AppVariants.completeMap[Constants.appName]
                  ["bookmarkPageBackgroundImage"],
            ),
            fit: BoxFit.fill),
        color: Colors.white),
    child: Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 145 / 640,
        left: MediaQuery.of(context).size.width * 33 / 360,
      ),
      child: Container(
        child: Column(
          children: [
            Image.asset(
              AppVariants.completeMap[Constants.appName]
                  ["noBookmarkSavedImagePath"],
              height: MediaQuery.of(context).size.height *
                  (double.parse(AppVariants.completeMap[Constants.appName]
                      ["noBookmarkSavedImageHeight"])) /
                  640,
              width: MediaQuery.of(context).size.width *
                  (double.parse(AppVariants.completeMap[Constants.appName]
                      ["noBookmarkSavedImageWidth"])) /
                  360,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Oh no! you don't have any bookmarks saved yet",
              style: TextStyle(
                color: Color(int.parse(AppVariants
                    .completeMap[Constants.appName]["bookmarkPageTextColor"])),
                fontSize: 14,
                letterSpacing: 0.14,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
