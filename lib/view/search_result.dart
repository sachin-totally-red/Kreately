import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/common/app_variants.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/view/custom_widget/graphics_card.dart';
import 'package:nibbin_app/view/custom_widget/post_card_widget.dart';
import 'package:nibbin_app/view/home_page.dart';
import 'search_content/search_news.dart';

class SearchResultPage extends StatelessWidget {
  final SearchedWidget searchedWidget;
  final HomePage homePage;
  final HomePageState homePageState;
  final Post news;

  SearchResultPage({
    this.searchedWidget,
    this.homePage,
    this.homePageState,
    this.news,
  });

  final _searchPageScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(int.parse(
          AppVariants.completeMap[Constants.appName]["statusBarColor"])),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _searchPageScaffoldKey,
          backgroundColor: Constants.appName == "Kaavya"
              ? Colors.transparent
              : Color(0xFF1A101F),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(int.parse(
                AppVariants.completeMap[Constants.appName]["appBarColor"])),
            centerTitle: true,
            title: Image.asset(
              AppVariants.completeMap[Constants.appName]["appBarImagePath"],
              width: MediaQuery.of(context).size.width *
                  (double.parse(AppVariants.completeMap[Constants.appName]
                      ["appBarLogoWidth"])) /
                  360,
              height: MediaQuery.of(context).size.height *
                  (double.parse(AppVariants.completeMap[Constants.appName]
                      ["appBarLogoHeight"])) /
                  640,
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
              color: Constants.appName == "Kaavya"
                  ? Colors.transparent
                  : Color(0xFF1A101F),
              image: new DecorationImage(
                  image: AssetImage(
                    AppVariants.completeMap[Constants.appName]
                        ["bookmarkPageBackgroundImage"],
                  ),
                  fit: BoxFit.fill),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if ((news == null) &&
                      (searchedWidget.searchedNews.type == "news"))
                    PostCard(
                      homePage: homePage ??
                          searchedWidget.searchNewsPage.widget.homePage,
                      post: news ?? searchedWidget.searchedNews,
                      homePageScaffoldKey: _searchPageScaffoldKey,
                      homePageState: homePageState ??
                          searchedWidget.searchNewsPage.widget.homePageState,
                    )
                  else if ((news == null) &&
                      (searchedWidget.searchedNews.type == "graphics"))
                    GraphicsCard(
                      homePage: homePage ??
                          searchedWidget.searchNewsPage.widget.homePage,
                      post: news ?? searchedWidget.searchedNews,
                      homePageScaffoldKey: _searchPageScaffoldKey,
                      homePageState: homePageState ??
                          searchedWidget.searchNewsPage.widget.homePageState,
                    )
                  else if (news.type == "news")
                    PostCard(
                      homePage: homePage ??
                          searchedWidget.searchNewsPage.widget.homePage,
                      post: news ?? searchedWidget.searchedNews,
                      homePageScaffoldKey: _searchPageScaffoldKey,
                      homePageState: homePageState ??
                          searchedWidget.searchNewsPage.widget.homePageState,
                    )
                  else
                    GraphicsCard(
                      homePage: homePage ??
                          searchedWidget.searchNewsPage.widget.homePage,
                      post: news ?? searchedWidget.searchedNews,
                      homePageScaffoldKey: _searchPageScaffoldKey,
                      homePageState: homePageState ??
                          searchedWidget.searchNewsPage.widget.homePageState,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
