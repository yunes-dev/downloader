import 'package:download_every_thing/another/classes/components/classStaticLists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CompnonentsWeb {
  final List<ContentBlocker> contentBlockers = [];
  var contentBlockerEnabled = true;
  String? userAgent;
  ContextMenu contextMenu(InAppWebViewController? webViewController) {
    return ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = contextMenuItemClicked.androidId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });
  }

  PullToRefreshController? pillToRefresh(
      PullToRefreshController? pullToRefreshController,
      InAppWebViewController? webViewController) {
    return pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? PullToRefreshController(
            options: PullToRefreshOptions(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.macOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController.getUrl()));
              }
            },
          )
        : PullToRefreshController();
  }

  InAppWebViewGroupOptions groupOptions() {
    return InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: true,
            useShouldInterceptAjaxRequest: true,
            javaScriptCanOpenWindowsAutomatically: true,
            useOnLoadResource: true,
            verticalScrollBarEnabled: true,
            useShouldInterceptFetchRequest: true,
            javaScriptEnabled: true,
            allowFileAccessFromFileURLs: true,
            preferredContentMode: UserPreferredContentMode.MOBILE,
            supportZoom: false,
            contentBlockers: contentBlockers,
            allowUniversalAccessFromFileURLs: true,
            useOnDownloadStart: true,
            clearCache: true,
            cacheEnabled: true),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          overScrollMode: AndroidOverScrollMode.OVER_SCROLL_IF_CONTENT_SCROLLS,
          //safeBrowsingEnabled: true,
          allowContentAccess: true,
          displayZoomControls: true,
          supportMultipleWindows: true,
          databaseEnabled: true,
          loadWithOverviewMode: true,
          cacheMode: AndroidCacheMode.LOAD_DEFAULT,
          useShouldInterceptRequest: true,
          allowFileAccess: true,
          networkAvailable: true,
        ));
  }

  void blockAdsWeb() {
    for (final adUrlFilter in ClassStaticLists().adUrlFilters) {
      contentBlockers.add(ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          )));
    }

    // apply the "display: none" style to some HTML elements
    contentBlockers.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
            type: ContentBlockerActionType.CSS_DISPLAY_NONE,
            selector: ".banner, .banners, .ads, .ad, .advert")));
  }

  Future<String?> handleClick(
      int item, InAppWebViewController appWebViewController) async {
    final defaultUserAgent = await InAppWebViewController.getDefaultUserAgent();
    if (kDebugMode) {
      print("Default User Agent: $defaultUserAgent");
    }

    String? newUserAgent;

    switch (item) {
      case 0:
        newUserAgent = defaultUserAgent;
        break;
      case 1:
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            // Remove "wv" from the Android WebView default user agent
            // https://developer.chrome.com/docs/multidevice/user-agent/#webview-on-android
            newUserAgent = defaultUserAgent.replaceFirst("; wv)", ")");
            break;
          case TargetPlatform.iOS:
            // Add Safari/604.1 at the end of the iOS WKWebView default user agent
            newUserAgent = "$defaultUserAgent Safari/604.1";
            break;
          default:
            newUserAgent = null;
        }
        break;
      case 2:
        // random desktop user agent
        newUserAgent =
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36';
        break;
    }
    print(userAgent);
    await appWebViewController.setOptions(
        options: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(userAgent: newUserAgent ?? '')));
    return newUserAgent;
    // if (kDebugMode) {
    //   print("New User Agent: $newUserAgent");
    // }

    // await goHome();
  }

  List<String> contentTypes = [
    'text/plain',
    'text/html; charset=ISO-8859-1',
    'text/html',
    'text/html; charset=UTF-8',
    'text/html; charset=utf-8',
    'text/html; charset="utf-8"',
    'text/css',
    'application/json',
    'application/xml',
    'multipart/form-data',
    'application/x-www-form-urlencoded',
    'application/octet-stream',
    'multipart/byteranges',
    'application/javascript',
    'text/csv'
  ];
  String HtmlError = """<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>error</title>
</head>
<body dir="rtl">
<br>
<br>
<br>
<br>
<center>
	  <h1 class="error-title">
    عذرا! <br> خطاء في الاتصال بالانترنت :(
  </h1>
  <h2 class="error-subtitle">
 يرجى التأكد من صحة اتصالك بالانترنت وأعادة المحاولة
  </h2>
</center>
</body>
</html>""";
}
