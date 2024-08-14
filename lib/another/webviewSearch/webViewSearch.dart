// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:download_every_thing/another/download/otherYoutubeDownloader.dart';
import 'package:download_every_thing/another/tabsWebVewPop/providerTabPop.dart';
import 'package:download_every_thing/another/tabsWebVewPop/tabsPopList.dart';
import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:newpipeextractor_dart/extractors/playlist.dart';
import 'package:newpipeextractor_dart/extractors/videos.dart';
import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classes/components/components.dart';
import '../classes/components/listTabBar.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/TiktokData.dart';
import '../classes/models/widgetList.dart';
import '../download/directLink.dart';
import 'package:html/parser.dart' show parse;
import '../download/faceBookInstgramDownload.dart';
import '../download/listDownloader/ListDownloader.dart';
import '../download/playListDownloader.dart';
import '../download/providerDownload.dart';
import '../download/testLinksVideos.dart';
import '../download/tikTokDownloader.dart';
import '../download/youTubeDownload.dart';
import 'package:http/http.dart' as http;
import '../classes/components/processData.dart';
import 'compnonentsWeb.dart';

class WebViewSearch extends StatefulWidget {
  String url;
  String idTabs;
  WebViewSearch({super.key, required this.url, required this.idTabs});
  @override
  State<WebViewSearch> createState() => _WebViewSearchState();
}

class _WebViewSearchState extends State<WebViewSearch> {
  final GlobalKey keyYoutube = GlobalKey();
  final GlobalKey keyFacebook = GlobalKey();
  final GlobalKey keyAnother = GlobalKey();
  final GlobalKey keyTiktok = GlobalKey();
  final GlobalKey keyGoogle = GlobalKey();
  final GlobalKey keyInstgram = GlobalKey();
  PullToRefreshController? pullToRefreshController;
  Components _elementeWidget = Components();
  DataAPI _api = DataAPI();
  ProcessData processData = ProcessData();
  late ContextMenu contextMenu;
  InAppWebViewController? webViewController;
  final GlobalKey<ScaffoldState> _scafffoldKey = GlobalKey<ScaffoldState>();
  VideoData? vidoData;
  YoutubeVideo? getInfoFile;
  List<StreamInfoItem>? playList;
  DownloadStartRequest? respons;
  Map jsonVideo = Map();
  List<TiktokData> tiktokData = [];
  String localLink = '';
  int indexWidget = 0;
  double prograss = 0;
  bool isStopOrRelod = false;
  bool showBtnDownload = false;
  bool isMobailDesktop = false;
  DateTime dateTime = DateTime.now();
  String urlLink = "";
  int current = 0;
  bool isDownloadFromWeb = false;
  List<WidgetListTabBar> tabsAppBar = [];
  CompnonentsWeb comWeb = CompnonentsWeb();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInfoFile(widget.url);
    idTab = widget.idTabs;
    contextMenu = comWeb.contextMenu(webViewController);
    pullToRefreshController =
        comWeb.pillToRefresh(pullToRefreshController, webViewController);

    tabsAppBar = [
      WidgetListTabBar(
          name: 'Google',
          widget: webview(
              'https://www.google.com/search?q=${widget.url}', keyGoogle),
          url: 'https://www.google.com/search?q=${widget.url}',
          img: "assets/images/google.png"),
      WidgetListTabBar(
          name: 'Youtube',
          widget: webview(
              'https://www.youtube.com/results?search_query=${widget.url}',
              keyYoutube),
          url: 'https://www.youtube.com/results?search_query=${widget.url}',
          img: "assets/images/youtube.png"),
      WidgetListTabBar(
          name: 'DuckDuck',
          widget:
              webview('https://duckduckgo.com/?q=${widget.url}', keyFacebook),
          url: 'https://duckduckgo.com/?q=${widget.url}',
          img: "assets/images/duck.png"),
      WidgetListTabBar(
          name: 'Bing',
          widget: webview(
              'https://www.bing.com/search?q=${widget.url}', keyInstgram),
          url: 'https://www.bing.com/search?q=${widget.url}',
          img: "assets/images/bing.png"),
      WidgetListTabBar(
          name: 'TikTok',
          widget: webview('https://www.tiktok.com/en/', keyTiktok),
          url: 'https://www.tiktok.com/',
          img: "assets/images/tiktok.png"),
      WidgetListTabBar(
          name: 'Instgram',
          widget: webview('https://www.instagram.com/reels/', keyInstgram),
          url: 'https://www.instagram.com/reels/',
          img: "assets/images/instagram.png"),
    ];

    getAllVideos();
  }

  InAppWebViewController? webViewPopupController;
  List itemVideos = [];
  getAllVideos() async {
    _api.GetAllData("select * from fileModel").then((value) {
      setState(() {
        itemVideos = value;
      });
    });
  }

  String idTab = '';
  chechOfTabsIsFound(String idTab1) async {
    final provider = Provider.of<ProviderTabPop>(context, listen: false);
    final tab = provider.obListWeb?.listWeb
        .where((element) => element.id_tab == idTab1)
        .map((e) => e.id_tab)
        .firstWhere((element) => true, orElse: () => '');
    if (tab!.isEmpty) {
      var screen = await provider.updateScreenshot(webViewController);
      provider.addTabWeb(
        urlLink,
        titlePage,
        screen!,
      );
      await provider.upDateAllList();
      final mod = provider.obListWeb?.listWeb.last;
      setState(() {
        idTab = mod!.id_tab.toString();
      });
      provider.setNewIdTab(idTab);
      idTab = await provider.getIdTab();
      // return '';
    } else {
      setState(() {
        idTab = tab.toString();
      });
      provider.setNewIdTab(idTab);
      idTab = await provider.getIdTab();
      // return tab!;
    }
    if (provider.adsWebShow == false) {
      comWeb.blockAdsWeb();
    }
  }

  String titlePage = '';
  Timer? timeDown;
  int timeChangIcon = 0;
  clu() {
    timeDown = Timer.periodic(Duration(seconds: 1), (timer) {
      print(timeChangIcon);
      setState(() {
        timeChangIcon += 1;
      });
    });
  }

  @override
  void dispose() {
    timeDown?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    final providerOfPop = Provider.of<ProviderTabPop>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scafffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              //padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(gradient: _elementeWidget.gradient),
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      color: isDownloadFromWeb == false
                          ? Colors.white
                          : timeChangIcon % 2 == 0
                              ? Colors.white
                              : const Color.fromARGB(255, 137, 16, 7),
                      onPressed: () async {
                        _elementeWidget.pushed(ListTitleDownLOader(), context);
                      },
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 25,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                              bottom: Radius.circular(10)),
                        ),
                        child: Text(
                          urlLink.length > 40
                              ? urlLink.substring(0, 40)
                              : urlLink,
                          style: TextStyle(fontSize: 12),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        if (isStopOrRelod == true) {
                          await webViewController?.loadUrl(
                              urlRequest: URLRequest(url: Uri.parse(urlLink)));
                        } else {
                          setState(() {
                            webViewController?.stopLoading();
                          });
                        }
                      },
                      icon: Icon(isStopOrRelod == false
                          ? Icons.close
                          : Icons.replay_rounded),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                  // padding: EdgeInsets.all(10),
                  child: widget.url.contains('http://') ||
                          widget.url.contains('https://')
                      ? Column(
                          children: [
                            Container(
                              child: LinearProgressIndicator(
                                color: Colors.red,
                                value: prograss,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            webview(urlLink, keyAnother),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              width: size.width,
                              //  height: size.height,
                              child: Container(
                                //margin: const EdgeInsets.only(top: 15),
                                width: size.width,
                                height: size.height * 0.04,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: SizedBox(
                                        width: size.width,
                                        height: size.height * 0.039,
                                        child: ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: tabsAppBar.length,
                                            itemBuilder: (context, index) {
                                              final tabsList =
                                                  tabsAppBar[index];
                                              return ListTabBar(
                                                  tabBar: tabsList,
                                                  onPress: () {
                                                    setState(() {
                                                      urlLink = tabsList.url;
                                                      current = index;
                                                    });
                                                  },
                                                  index: index,
                                                  current: current);
                                            }),
                                      ),
                                    ),
                                    // AnmatedTabBar(
                                    //     size: size,
                                    //     current: current,
                                    //     tabs: tabs[current].name),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: LinearProgressIndicator(
                                color: Colors.red,
                                value: prograss,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            tabsAppBar[current].widget,
                          ],
                        )),
            ),
          ],
        ),
      ),
      floatingActionButton: showBtnDownload == false
          ? Container()
          : Container(
              padding: EdgeInsets.only(right: 50, bottom: 100),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: _elementeWidget.lightColor,
                highlightElevation: 100.0,
                hoverElevation: 50.0,
                onPressed: () async {
                  await provider.initializeLocalStorageRoute();

                  if (provider.dir != null) {
                    if (urlLink.contains("m.youtube") ||
                        urlLink.contains("youtube.com") ||
                        urlLink.contains("youtu.be")) {
                      if (urlLink.contains('playlist')) {
                        if (playList != null) {
                          PlayListYoutube().buildBottomPlayList(
                              context, provider, itemVideos, playList!);
                          getAllVideos();
                        } else {
                          await getDataOfYoutubePlayList(urlLink);
                          PlayListYoutube().buildBottomPlayList(
                              context, provider, itemVideos, playList!);
                          getAllVideos();
                        }
                      } else {
                        if (jsonVideo.isNotEmpty) {
                          print(
                              'is not Empty----------------------------------------------------------------');
                          print(jsonVideo);
                          OtherYoutubeDownloader().buildBottomYoutubeDownload(
                              context, provider, jsonVideo, urlLink);
                        } else {
                          print(
                              'is Empty----------------------------------------------------------------');
                          await otherGetDataVideo(urlLink);
                          if (jsonVideo.isNotEmpty) {
                            OtherYoutubeDownloader().buildBottomYoutubeDownload(
                                context, provider, jsonVideo, urlLink);
                          } else {
                            if (getInfoFile != null) {
                              YoutubeDownload().buildBottomYoutubeDownload(
                                  context, provider, getInfoFile!);
                              getAllVideos();
                            } else {
                              await getDataOfYoutube(urlLink);
                              YoutubeDownload().buildBottomYoutubeDownload(
                                  context, provider, getInfoFile!);
                            }
                          }
                        }
                      }
                    } else if (urlLink.contains('instagram.com') ||
                        urlLink.contains('fb.watch') ||
                        urlLink.contains('facebook.com')) {
                      if (vidoData != null && vidoData?.links != null) {
                        _elementeWidget.toast('is not null');
                        // print('is not null');
                        // print(vidoData?.links);
                        FaceBookInstgramDownload().downloadFaceBookAndInstgram(
                            context, vidoData!, provider, urlLink);
                        getAllVideos();
                      } else {
                        // print('is  null');
                        _elementeWidget.toast('is  null');
                        await getDataFileInstaFace(urlLink);
                        FaceBookInstgramDownload().downloadFaceBookAndInstgram(
                            context, vidoData!, provider, urlLink);
                        getAllVideos();
                        //   print(vidoData);
                      }
                    } else if (localLink.contains('vt.tiktok.com') ||
                        localLink.contains('tiktok.com')) {
                      if (tiktokData.isNotEmpty) {
                        TikTokDownloader().buildBottomTiktokDownload(
                            context, provider, tiktokData.last);
                      } else {
                        await linksTiktok(localLink);

                        TikTokDownloader().buildBottomTiktokDownload(
                            context, provider, tiktokData.last);
                      }
                    } else {
                      // if (testUrl.isNotEmpty) {
                      //   TestLinksVideos().buildBottomTestDownload(
                      //       context, provider, testUrl);
                      //   // testUrl.clear();
                      //   // setState(() {
                      //   //   showBtnDownload = false;
                      //   // });
                      //   // setState(() {
                      //   //   showBtnDownload = true;
                      //   // });
                      //   // DirectLink().dialogBuildDown(
                      //   //     context, localLink, respons!, provider);
                      // }
                      // if (respons != null) {
                      //   DirectLink().dialogBuildDown(context, localLink,
                      //       urlLink, respons!, provider);
                      // } else {
                      //   await getDirectLink(urlLink);
                      //   DirectLink().dialogBuildDown(context, localLink,
                      //       urlLink, respons!, provider);
                      // }
                    }
                  }
                },
                child: const Icon(
                  Icons.download,
                  size: 40,
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: _elementeWidget.lightColor,
        unselectedItemColor: _elementeWidget.lightColor,
        unselectedLabelStyle: TextStyle(fontSize: 2),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 2),
        onTap: (value) async {
          if (value == 0) {
            // var dd = await webViewController?.getHtml();
            // //webViewController?.loadData(data: dd!);
            // // print(dd);
            // var ff = parse(dd).getElementsByTagName('iframe');
            // ff.forEach((element) {
            //   print(element.outerHtml);
            // });
            // print(ff);
            if (isMobailDesktop == false) {
              await comWeb.handleClick(0, webViewController!);
              await webViewController?.loadUrl(
                  urlRequest: URLRequest(url: Uri.parse(urlLink)));
              setState(() {
                isMobailDesktop = true;
              });
            } else {
              await comWeb.handleClick(2, webViewController!);
              await webViewController?.loadUrl(
                  urlRequest: URLRequest(url: Uri.parse(urlLink)));
              setState(() {
                isMobailDesktop = false;
              });
            }
          } else if (value == 2) {
            if (await webViewController!.canGoBack()) {
              webViewController?.goBack();
            }
          } else if (value == 3) {
            if (await webViewController!.canGoForward()) {
              webViewController?.goForward();
            }
          } else if (value == 1) {
            await _elementeWidget.awaitPushed(const TabsPopList(), context);
            var id = await providerOfPop.getIdTab();
            if (idTab != id) {
              setState(() {
                idTab = id;
              });
              var u = providerOfPop.obListWeb?.listWeb
                  .where((element) => element.id_tab == id)
                  .map((e) => e.url_tab)
                  .first;
              webViewController?.loadUrl(
                  urlRequest: URLRequest(url: Uri.parse(u.toString())));
            }
          }
        },
        items: <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.home),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: Icon(isMobailDesktop == false
                ? Icons.phone_iphone_sharp
                : Icons.desktop_mac_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 35,
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 2.0, color: _elementeWidget.lightColor),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0)),
              constraints: const BoxConstraints(minWidth: 25.0),
              child: Center(
                  child: Text(
                providerOfPop.listTestWeb!.listWeb.length.toString(),
                style: TextStyle(
                    color: _elementeWidget.lightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              )),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: '',
          ),
        ],
      ),
      // bottomSheet: Text('aaaaaaaaaaaaa'),
    );
  }

  List testUrl = [];
  Widget webview(String url1, GlobalKey key) {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    final providerOfTab = Provider.of<ProviderTabPop>(context, listen: false);
    return Expanded(
      child: InAppWebView(
        contextMenu: contextMenu,
        key: key,
        initialUrlRequest: URLRequest(
          url: Uri.parse(url1),
        ),
        initialOptions: comWeb.groupOptions(),

        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (controller) async {
          webViewController = controller;
        },

        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          );
        },
        onCreateWindow: (controller, createWindowAction) async {
          if (providerOfTab.pubTab == false) {
            var screen =
                await providerOfTab.updateScreenshot(webViewController);
            providerOfTab.addTabWeb(createWindowAction.request.url.toString(),
                titlePage, Uint8List.fromList([]));
            providerOfTab.upDateAllList();
            // await comWeb.handleClick(2, webViewController!);
            // await webViewController?.loadUrl(
            //     urlRequest: URLRequest(url: Uri.parse(urlLink)));
            var snackBar = SnackBar(content: Text('تم فتح نافذه جديدة'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            var snackBar = SnackBar(content: Text('تم منع النوافذ المنبثقة'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
          setState(() {
            webViewController = controller;
          });
          // print('Intercepted AJAX request: ${ajaxRequest.responseURL}');
          // print(
          //     "***********************************************************************************shouldInterceptAjaxRequest");
          // // return ajaxRequest;
        },
        androidOnRenderProcessResponsive: (controller, url) async {
          print(url.toString());
          print(
              "***********************************************************************************shouldInterceptAjaxRequest");
        },
        shouldInterceptFetchRequest: (controller, fetchRequest) async {
          setState(() {
            webViewController = controller;
          });
          // print(fetchRequest.body);
          // print(
          //     "***********************************************************************************shouldInterceptFetchRequest");
          return fetchRequest;
        },
        onLoadResource: (controller, resource) {
          setState(() {
            webViewController = controller;
          });
          // if (resource.initiatorType == "video" ||
          //     resource.url.toString().contains("video")) {
          //   print(resource.url);
          //   print(resource.initiatorType);
          //   setState(() {
          //     testUrl.add(resource.url.toString());
          //   });
          //   print(
          //       '-----------------------------------------------onLoadResource');
          // }
        },
        androidShouldInterceptRequest: (controller, request) async {
          setState(() {
            webViewController = controller;
          });
//           var gg = _elementeWidget.hasvalidurl(request.url.toString());
//           if (gg == 'url') {
//             if (await _elementeWidget.checkUrlVideo(request.url.toString()) ==
//                 true) {
//               print(request.url);
//               //print(request.headers);
//               //print(request.isForMainFrame);
//               // print(request.toMap());
//               print(
//                   "***********************************************************************************androidShouldInterceptRequest");

//               print(request.url.toString().split('/').last);
//               setState(() {
//                 testUrl.add(request.url.toString());
//                 showBtnDownload = true;
//               });

//               print(
//                   '____________________________________________________________________________');
//             } else {
// //               await webViewController?.evaluateJavascript(source: """
//    var links =document
//           .getElementsByTagName('video')
//           .where((element) => element.attributes.containsKey('src'))
//           .map((e) => e.attributes['src'])
//           .toList();
//           console.log(links);
// """).then((value) {
//                 print(value);
//                 print(
//                     '-----------------------------------------------valueeeeeeeeeeeeee');
//               });
         //   }
       //   }
          // return WebResourceResponse();
        },

        //  return request;

        onAjaxReadyStateChange: (controller, ajaxRequest) async {
          setState(() {
            webViewController = controller;
          });

          return AjaxRequestAction.PROCEED;
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          setState(() {
            webViewController = controller;
          });

          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT, // or DENY
          );
        },

        onLoadStart: (controller, url) async {
          setState(() {
            webViewController = controller;

            //  this.url = url.toString();
            //    urlController.text = this.url;
          });
          if (url.toString().contains('http://') ||
              url.toString().contains('https://')) {
            //loadInfoFile(url.toString());
            chechOfTabsIsFound(idTab);
            setState(() {
              urlLink = url.toString();
              localLink = url.toString();
            });
            // print(url);
            // print('-----------------------------------------------onLoadStart');
          }
        },
        onTitleChanged: (controller, title) {
          setState(() {
            titlePage = title.toString();
          });
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url!;

          if (![
            "http",
            "https",
            "file",
            "chrome",
            "data",
            "javascript",
            "about"
          ].contains(uri.scheme)) {
            if (await canLaunchUrl(uri)) {
              // Launch the App
              await launchUrl(
                uri,
              );
              // and cancel the request
              return NavigationActionPolicy.CANCEL;
            }
          }

          return NavigationActionPolicy.ALLOW;
        },
        // onDownloadStart: (controller, url) async {
        //   print(
        //       '-----------------------------------------------onDownloadStart');
        //},

        onLoadStop: (controller, url) async {
          var screen = await providerOfTab.updateScreenshot(webViewController);
          providerOfTab.updateTabWeb(titlePage, urlLink, idTab, screen!);
          setState(() {
            webViewController = controller;
            isStopOrRelod = true;
          });
          pullToRefreshController?.endRefreshing();
          if (url.toString().contains('http://') ||
              url.toString().contains('https://')) {
            setState(() {
              urlLink = url.toString();
            });
          }
          // //  chechOfTabsIsFound(idTab);
          // print(url);
          // print('-----------------------------------------------onLoadStop');

//           var dd = await controller.evaluateJavascript(source: """
//    var links =document
//           .getElementsByTagName('video')
//           .where((element) => element.attributes.containsKey('src'))
//           .map((e) => e.attributes['src'])
//           .toList();
//           print(links);
// """);
//           print(dd);
//           print(
//               '-----------------------------------------------dddddddddddddd');
        },

        onDownloadStartRequest: (controller, downloadStartRequest) async {
          // print(downloadStartRequest.contentDisposition);
          // print(downloadStartRequest.mimeType);
          // print(downloadStartRequest.url);
          // print(downloadStartRequest.contentLength);

          await provider.initializeLocalStorageRoute();

          setState(() {
            isDownloadFromWeb = true;
            respons = downloadStartRequest;
          });
          clu();
          if (respons != null) {
            // setState(() {
            //   showBtnDownload = true;
            // });
            DirectLink()
                .dialogBuildDown(context, localLink, respons!, provider);
          }
          // print(
          //     '-----------------------------------------------onDownloadStartRequest');
        },
        onProgressChanged: (controller, progres) {
          if (progres == 100) {
            pullToRefreshController?.endRefreshing();
            //   print(progres);
            setState(() {
              isStopOrRelod = true;
            });
          } else {
            setState(() {
              isStopOrRelod = false;
            });
          }
          pullToRefreshController?.endRefreshing();
          setState(() => prograss = progres / 100);
        },

        onUpdateVisitedHistory: (controller, url, isReload) async {
          setState(() {
            showBtnDownload = false;
            isStopOrRelod = isReload!;
            webViewController = controller;
            //urlController.text = this.url;
          });

          if (url.toString().contains('http')) {
            loadInfoFile(url.toString());
            setState(() {
              urlLink = url.toString();
            });
          }
        },
        onAjaxProgress: (controller, ajaxRequest) async {
          // print(ajaxRequest.action);
          // print(ajaxRequest.data);
          // print(ajaxRequest.headers);
          // print(ajaxRequest.method);
          // print(ajaxRequest.password);
          // print(ajaxRequest.response);
          // print(ajaxRequest.responseHeaders);
          // print(ajaxRequest.responseText);
          // print(ajaxRequest.responseType);
          // print(ajaxRequest.responseURL);
          // print(ajaxRequest.responseXML);
          // print(ajaxRequest.url);
          // print(ajaxRequest.user);
          return AjaxRequestAction.PROCEED;
        },

        onLoadResourceCustomScheme: (controller, url) async {
          setState(() {
            webViewController = controller;
          });
        },
        onReceivedHttpAuthRequest: (controller, challenge) async {
          setState(() {
            webViewController = controller;
          });
        },
        onReceivedClientCertRequest: (controller, challenge) async {
          setState(() {
            webViewController = controller;
          });
        },

        onConsoleMessage: (controller, consoleMessage) async {
          setState(() {
            webViewController = controller;
          });
        },
        onLoadError: (controller, url, code, message) async {
          setState(() {
            webViewController = controller;
            webViewController?.loadData(data: comWeb.HtmlError);
            isStopOrRelod = true;
          });
        },
      ),
    );
  }

  loadInfoFile(String url) async {
    // print(
    //     '************************************************************************************************** Start');
    // vidoData = null;
    getInfoFile = null;
    playList = null;
    jsonVideo.clear();
    tiktokData.cast();
    if (url.contains("m.youtube") ||
        url.contains("youtube.com") ||
        url.contains("youtu.be")) {
      setState(() {
        urlLink = url;
      });
      if (url.contains('playlist')) {
        await getDataOfYoutubePlayList(url);
      } else {
        await otherGetDataVideo(url);
        await getDataOfYoutube(url);
      }
    } else if (url.contains('instagram.com') ||
        url.contains('fb.watch') ||
        url.contains('facebook.com')) {
      // print(
      //     '**************************************************************************************************');
      // print('load from facebook');
      // print(
      //     '**************************************************************************************************');
      setState(() {
        urlLink = url;
      });
      await getDataFileInstaFace(url);
    } else if (url.contains('http://') || url.contains('https://')) {
      // getDirectLink(url);
      setState(() {
        urlLink = url;
      });
    } else if (url.contains('vt.tiktok.com') || url.contains('tiktok.com')) {
      await linksTiktok(url);
      setState(() {
        urlLink = url;
      });
    } else {
      setState(() {
        urlLink = 'https://www.google.com/search?q=${url}';
      });
    }
  }

  Future<void> getDataFileInstaFace(String url) async {
    try {
      vidoData = await Extractor.getDirectLink(link: url);
      if (vidoData != null) {
        setState(() {
          showBtnDownload = true;
        });
      }
    } catch (e) {}
  }

  Future<void> getDataOfYoutube(String url) async {
    try {
      getInfoFile = await VideoExtractor.getStream(url);
      if (getInfoFile != null) {
        setState(() {
          showBtnDownload = true;
        });
      }
    } catch (e) {}
  }

  Future<void> getDataOfYoutubePlayList(String url) async {
    try {
      playList = await PlaylistExtractor.getPlaylistStreams(url);
      if (playList != null) {
        setState(() {
          showBtnDownload = true;
        });
      }
    } catch (e) {}
  }

  Future<void> otherGetDataVideo(String url) async {
    try {
      jsonVideo = await processData.oherGetDataVideo(url);
      if (jsonVideo.isNotEmpty) {
        setState(() {
          showBtnDownload = true;
        });
      }

      jsonVideo.forEach((key, value) async {
        if (key == 'links') {
          Map mp4 = jsonVideo['links']['mp4'];
          mp4.forEach((key, value) {
            print(
                'MP4-------------------------------------------------------------------');
            print(jsonVideo['vid']);
            print(jsonVideo['title']);
            print(value['f']);
            print(value['q']);
            print(value['size']);
            print(jsonVideo['token']);
            print(jsonVideo['timeExpires']);
            // print(value);
          });
          Map mp3 = jsonVideo['links']['mp3'];
          mp3.forEach((key, value) {
            print(
                'MP3**************************************************************************');
            print(jsonVideo['vid']);
            print(jsonVideo['title']);
            print(value['f']);
            print(value['q']);
            print(value['size']);
            print(jsonVideo['token']);
            print(jsonVideo['timeExpires']);
            // print(value);
          });
        }
      });
    } catch (e) {}
  }

  Future<void> linksTiktok(String url) async {
    print('-------------------------------------');
    tiktokData = await processData.getDataVideoOfTikTok(url);

    if (tiktokData.isNotEmpty) {
      setState(() {
        showBtnDownload = true;
      });
    } else {}
    print('-------------------------------------');
  }
}
