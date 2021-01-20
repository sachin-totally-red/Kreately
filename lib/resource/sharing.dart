import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/model/post.dart';
import 'package:nibbin_app/resource/amplitude_repository.dart';
import 'package:share/share.dart';

class SharingRepository {
  static void shareNewsEvent(Post news, BuildContext context) async {
    try {
      // AmplitudeRepository _amplitudeRepository = AmplitudeRepository();

      final document =
          parse("""${news.shortDesc.replaceAll("</p>", " </p>")}""");
      final String parsedString =
          parse(document.body.text).documentElement.text;

      print(parsedString);

      var parameters = DynamicLinkParameters(
          uriPrefix: (Constants.appName == "Kaavya")
              ? 'https://kaavya.page.link'
              : 'https://nibbin.page.link',
          link: Uri.parse(/*'https://nibb.in'*/
              'https://test/welcome?newsID=${news.id.toString()}'),
          androidParameters: AndroidParameters(
            packageName: (Constants.appName == "Kaavya")
                ? "in.bluone.app.kaavya"
                : "in.bluone.app.nibbin",
          ),
          iosParameters: IosParameters(
            bundleId: (Constants.appName == "Kaavya")
                ? "in.bluone.app.kaavya"
                : "in.bluone.app.nibbin",
            appStoreId:
                (Constants.appName == "Kaavya") ? '1546112335' : '1532244186',
          ),
          /*googleAnalyticsParameters: GoogleAnalyticsParameters(
                                  campaign: 'nibb.in',
                                  medium: 'social',
                                  source: 'orkut',
                                ),
                                itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
                                  providerToken: '123456',
                                  campaignToken: 'nibb.in',
                                ),*/
          socialMetaTagParameters: SocialMetaTagParameters(
              title: news.headline,
              description: parsedString,
              imageUrl: Uri.parse(news.imageSrc ??
                  "https://i.picsum.photos/id/352/500/500.jpg?hmac=-E0Zo7evjUyTTEVC4YJW-pUDmGC2dMDxBvGZjWR7yv4")));
      var dynamicUrl = await parameters.buildUrl();
      final ShortDynamicLink shortenedLink =
          await DynamicLinkParameters.shortenUrl(
        dynamicUrl,
        DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      );

      var shortUrl = shortenedLink.shortUrl;
      print(shortUrl);
      await SharingRepository.shareOnTap(context,
          content:
              "Read this ${(Constants.appName == "Kaavya") ? "" : "news brief"} on ${Constants.appName} $shortUrl");
      // _amplitudeRepository.trackNewsSharingEvent(news.id, news.newsCategories);
      /*_trackDataRepository
                                .trackNewsSharingRecord(widget.post.id);*/
    } catch (e) {
      print(e.toString());
    }
  }

  static Future shareOnTap(BuildContext context, {String content}) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(content,
        subject: "Nibbin",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
