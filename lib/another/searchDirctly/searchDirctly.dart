// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:download_every_thing/another/classes/components/classStaticLists.dart';
import 'package:download_every_thing/another/download/listDownloader/ListDownloader.dart';
import 'package:download_every_thing/another/download/otherYoutubeDownloader.dart';
import 'package:download_every_thing/another/searchDirctly/whatsapp.dart';
import 'package:download_every_thing/another/webviewSearch/searchinList.dart';
import 'package:download_every_thing/another/webviewSearch/webViewSearch.dart';
import 'package:download_every_thing/main.dart';
import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:newpipeextractor_dart/extractors/playlist.dart';
import 'package:newpipeextractor_dart/extractors/videos.dart';
import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:overlay_progress_indicator/overlay_progress_indicator.dart';
import 'package:provider/provider.dart';
import '../classes/components/components.dart';
import '../classes/components/topBarSearch.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/TiktokData.dart';
import '../classes/models/faceBookInstagram.dart';
import '../classes/models/search.dart';
import '../download/faceBookInstgramDownload.dart';

import '../download/otherFaceInstaDownload.dart';
import '../download/playListDownloader.dart';
import '../download/providerDownload.dart';
import '../download/tikTokDownloader.dart';
import '../download/youTubeDownload.dart';
import '../classes/components/processData.dart';
import '../tabsWebVewPop/providerTabPop.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class Whatsapp {
  String name;
  String url;
  String urlImg;
  Whatsapp(this.name, this.url, this.urlImg);
}

class SearchDirctly extends StatefulWidget {
  String url;
  String typeWork;
  SearchDirctly({super.key, required this.url, required this.typeWork});
  @override
  State<SearchDirctly> createState() => _SearchDirctlyState();
}

class _SearchDirctlyState extends State<SearchDirctly>
    with WidgetsBindingObserver {
  Components _elementeWidget = Components();
  DataAPI api = DataAPI();
  ProcessData processData = ProcessData();
  VideoData? vidoData;
  YoutubeVideo? getInfoFile;
  List<StreamInfoItem>? playList;
  DownloadStartRequest? respons;
  Map jsonVideo = Map();
  List<TiktokData> tiktokData = [];
  List<Search> localSearchDirect = ClassStaticLists().localSearchDirect;
  List<Whatsapp> urlWhatsapp = [];
  String urlLocal = '';
  List itemVideos = [];
  List<FaceBookInstagram> listFacBookInstaTwitter = [];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
    _elementeWidget.verifyVersion(context);
    textController.text = widget.url;
    getAllVideos();
    getDataWhatsApp(
        'https://mediafire.omaryemen.app/file/ob4whatsapp-apk',
        'واتساب عمر الاخضر',
        "https://meta-code-ye.com/images/omar/green.webp",
        'mediafire');
    getDataWhatsApp('https://omaryemen.app/whatsapp-aero', 'واتساب ريو',
        "https://meta-code-ye.com/images/omar/row.jpg", 'appsfire');
    getDataWhatsApp('https://omaryemen.app/download', 'واتساب عمر العنابي ',
        "https://meta-code-ye.com/images/omar/brown.png", 'mediafire');
    getDataWhatsApp('https://omaryemen.app/alwardi', 'واتساب عمر الوردي',
        "https://meta-code-ye.com/images/omar/pink.webp", 'mediafire');
    getDataWhatsApp(
        'https://mediafire.omaryemen.app/file/ob5whatsapp-apk',
        'واتساب عمر الأحمر',
        "https://meta-code-ye.com/images/omar/red.png",
        'ob5whatsapp-apk');
    getDataWhatsApp('https://omaryemen.app/alazrak', 'واتساب عمر الازرق',
        "https://meta-code-ye.com/images/omar/blue.webp", 'ob3whatsapp-apk');
    getDataWhatsApp(
        'https://mediafire.omaryemen.app/file/ob6whatsapp-download-apk/',
        'واتساب الذهبي',
        "https://meta-code-ye.com/images/omar/gold.png",
        'mediafire');
  }

  var textPast = "";
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      if (state.name == "resumed") {
        String search =
            await _elementeWidget.invokeKotlinMethod("callKotlinMethod");
        if (search.isNotEmpty && widget.typeWork == 'share') {
          setState(() {
            textController.text = search;
          });

          downloadDirecty(textController.text, context);
        }
      } else {
        print("////////////////////////////////////////");
      }
    } catch (e) {
      print('error  $e');
    }
    await Clipboard.getData(Clipboard.kTextPlain).then((value) {
      setState(() {
        if (value != null) {
          textPast = value.text ?? "";
        }
      });
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool showSearchList = false;
  TextDirection? aligemnt;
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    final providerOfPop = Provider.of<ProviderTabPop>(context, listen: false);
    List keyWord = [];
    return WillPopScope(
        onWillPop: () async {
          if (showSearchList == true) {
            setState(() {
              showSearchList = false;
            });
            FocusScope.of(context).unfocus();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: _elementeWidget.gradient,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25),
                                  bottom: Radius.circular(25)),
                            ),
                            child: TextField(
                              controller: textController,
                              onTap: () {
                                setState(() {
                                  showSearchList = true;
                                });
                              },
                              onChanged: (value) async {
                                setState(() {
                                  aligemnt =
                                      Components().alignTxtRightToLeft(value);
                                });
                              },
                              onSubmitted: (value) async {
                                FocusScope.of(context).unfocus();
                                downloadDirecty(value, context);
                              },
                              onEditingComplete: () {},
                              textDirection: aligemnt,
                              keyboardType: TextInputType.url,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15),
                              // cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                isDense: true,
                                labelText: 'اكتب الرابط للتحمل او التصفح',
                                //hintText: 'التحميل المباشر ادخل عنوان URL',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 15.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                                prefixIcon: IconButton(
                                  color: Colors.black,
                                  icon: const Icon(
                                    Icons.search,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    downloadDirecty(
                                        textController.text, context);
                                  },
                                ),
                                suffixIcon: textController.text.isEmpty &&
                                        textPast.isNotEmpty
                                    ? IconButton(
                                        color: Colors.black,
                                        icon: const Icon(Icons.paste),
                                        onPressed: () {
                                          setState(() {
                                            textController.text = textPast;
                                          });
                                        },
                                      )
                                    : textController.text.isNotEmpty
                                        ? IconButton(
                                            color: Colors.black,
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                textController.clear();
                                                keyWord.clear();
                                              });
                                            },
                                          )
                                        : null,
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                      bottom: Radius.circular(25)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            _elementeWidget.pushed(
                                ListTitleDownLOader(), context);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: showSearchList == true ? 10 : 20,
                  ),
                  showSearchList == true
                      ? Column(
                          children: [
                            const TopBarSearch(),
                            textController.text.isNotEmpty
                                ? const Row(
                                    children: [
                                      Icon(Icons.auto_awesome_motion_outlined),
                                      Text('كلمات مقترحة'),
                                    ],
                                  )
                                : Container(),
                            textController.text.isEmpty
                                ? Container()
                                : SingleChildScrollView(
                                    child: FutureBuilder(
                                        future: textController.text != ""
                                            ? http.get(
                                                Uri.parse(
                                                    'http://suggestqueries.google.com/complete/search?client=firefox&q=${textController.text}'),
                                                headers: {
                                                    'user-agent':
                                                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
                                                            '(KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36',
                                                    'accept-language':
                                                        'en-US,en;q=1.0',
                                                  })
                                            : null,
                                        builder: (context,
                                            AsyncSnapshot<http.Response>
                                                suggestions) {
                                          keyWord.clear();
                                          if (suggestions.hasData) {
                                            var map = jsonDecode(
                                                suggestions.data!.body);
                                            keyWord = map[1];
                                          }
                                          return Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children: List.generate(
                                                  keyWord.length, (index) {
                                                return GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        textController.text =
                                                            keyWord[index];
                                                      });
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      downloadDirecty(
                                                          textController.text,
                                                          context);
                                                    },
                                                    child: Container(
                                                      child: Chip(
                                                          label: Text(
                                                        keyWord[index],
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )),
                                                    ));
                                              }));
                                        }),
                                  ),
                            SearchInList(
                              getUrl: (url, work) {
                                setState(() {
                                  textController.text = url;
                                });
                                if (work == "down") {
                                  downloadDirecty(textController.text, context);
                                }
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    bottom: 15, top: 7, left: 7, right: 7),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 88, 86, 86)
                                            .withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    gradient: _elementeWidget.gradient),
                                child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: List.generate(
                                        localSearchDirect.length, (index) {
                                      Search classSearch =
                                          localSearchDirect[index];
                                      return GestureDetector(
                                          onTap: () async {
                                            print(textController.text);
                                            final idtab =
                                                await providerOfPop.getIdTab();
                                            provider.elementeWidget.pushed(
                                                WebViewSearch(
                                                    url: classSearch
                                                        .search_search,
                                                    idTabs: idtab),
                                                context);
                                            print(urlLocal);

                                            // await processData.twitter2Down(
                                            //     "https://twitter.com/Brazzers/status/1704740093259374889?t=b5AAAAHy4IGyrPfBBaWfbA&s=19");
                                          },
                                          child: Container(
                                              child: Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              255, 255, 255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100.0)),
                                                      child: Image.asset(
                                                        classSearch.img,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            8.22,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            8.22,
                                                      ))),
                                              Text(
                                                "${classSearch.nameUrl.length > 10 ? classSearch.nameUrl.substring(0, 8) + '..' : classSearch.nameUrl}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          )));
                                    })),
                              ),
                            ),
                            // Container(
                            //     child: showBtnDownload == true ? CircularProgressIndicator() : null)
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration:
                                  _elementeWidget.buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(50, 50)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(0, 222, 12, 12)),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  _elementeWidget.pushed(
                                      OtherWhatsAPP(), context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    'جميع نسخ الواتساب'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Card(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 88, 86, 86)
                                            .withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    gradient: _elementeWidget.gradient),
                                width: 150,
                                child: Text(
                                  'تحميل واتساب عمر',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),

                            SingleChildScrollView(
                              child: urlWhatsapp.isEmpty
                                  ? Container(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                        left: 0,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 50, right: 50),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(300),
                                                topRight: Radius.circular(0),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(500)),
                                            gradient: _elementeWidget.gradient),
                                        child: Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            alignment: WrapAlignment.center,
                                            children: List.generate(
                                                urlWhatsapp.length, (index) {
                                              Whatsapp whatsapp =
                                                  urlWhatsapp[index];
                                              return GestureDetector(
                                                  onTap: () async {
                                                    final idtab =
                                                        await providerOfPop
                                                            .getIdTab();
                                                    provider.elementeWidget
                                                        .pushed(
                                                            WebViewSearch(
                                                                url: whatsapp
                                                                    .url,
                                                                idTabs: idtab),
                                                            context);
                                                  },
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  6),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  const Color.fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      100.0)),
                                                          child: _elementeWidget
                                                              .circulCatchImageNetwork(
                                                                  whatsapp.urlImg))));
                                            })),
                                      ),
                                    ),
                            ),
                          ],
                        )
                ],
              ),
            )));
  }

  getAllVideos() async {
    final providerOfPop = Provider.of<ProviderTabPop>(context, listen: false);

    await api.GetAllData("select * from fileModel").then((value) {
      setState(() {
        itemVideos = value;
      });
    });

    if (providerOfPop.searchTxt != null) {
      print(providerOfPop.searchTxt);
      setState(() {
        textController.text = providerOfPop.searchTxt!;
      });
      if (widget.typeWork == 'share' && providerOfPop.searchTxt!.isNotEmpty) {
        downloadDirecty(textController.text, context);
      }
      print('***************************************************************');
    }
  }

  Future<void> getDataWhatsApp(
      String url, String name, String urlImg, String contion) async {
    try {
      final model =
          await processData.getDataWhatsApp(url, name, urlImg, contion);
      if (model != null) {
        setState(() {
          urlWhatsapp.add(model);
        });
      }
    } catch (e) {}
  }

  downloadDirecty(String url, BuildContext context) async {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    Components().dialogBuildToExit(context);
    if (urlLocal != url) {
      print(
          '************************************/////////////////////////////////////////////////////////////');
      setState(() {
        respons = null;
        vidoData = null;
        getInfoFile = null;
        jsonVideo.clear();
        playList = null;
        tiktokData.clear();
        listFacBookInstaTwitter.clear();
        urlLocal = textController.text;
      });
    }
    await provider.initializeLocalStorageRoute();
    if (provider.dir != null) {
      if (url.contains("m.youtube") ||
          url.contains("youtube.com") ||
          url.contains("youtu.be")) {
        if (url.contains('playlist')) {
          if (playList != null) {
            PlayListYoutube()
                .buildBottomPlayList(context, provider, itemVideos, playList!);
            OverlayProgressIndicator.hide();
            getAllVideos();
          } else {
            await getDataOfYoutubePlayList(url);
            OverlayProgressIndicator.hide();
            PlayListYoutube()
                .buildBottomPlayList(context, provider, itemVideos, playList!);
            getAllVideos();
          }
        } else {
          if (jsonVideo.isNotEmpty) {
            print(
                'is not Empty----------------------------------------------------------------');
            print(jsonVideo);
            OverlayProgressIndicator.hide();
            OtherYoutubeDownloader()
                .buildBottomYoutubeDownload(context, provider, jsonVideo, url);
          } else {
            print(
                'is Empty----------------------------------------------------------------');
            await otherGetDataVideo(url);

            if (jsonVideo.isNotEmpty) {
              OverlayProgressIndicator.hide();
              OtherYoutubeDownloader().buildBottomYoutubeDownload(
                  context, provider, jsonVideo, url);
            } else {
              if (getInfoFile != null) {
                OverlayProgressIndicator.hide();
                YoutubeDownload().buildBottomYoutubeDownload(
                    context, provider, getInfoFile!);
                getAllVideos();
              } else {
                await getDataOfYoutube(url);
                OverlayProgressIndicator.hide();
                YoutubeDownload().buildBottomYoutubeDownload(
                    context, provider, getInfoFile!);
              }
            }
          }
        }
      } else if (url.contains('instagram.com') ||
          url.contains('fb.watch') ||
          url.contains('facebook.com')) {
        if (listFacBookInstaTwitter.isEmpty) {
          if (url.contains('instagram.com')) {
            await instgram(url);

            if (listFacBookInstaTwitter.isEmpty) {
              await getDataFileInstaFace(url);
              OverlayProgressIndicator.hide();
              FaceBookInstgramDownload().downloadFaceBookAndInstgram(
                  context, vidoData!, provider, url);
            } else {
              OverlayProgressIndicator.hide();
              OtherFaceInstaDownload().downloadFaceBookAndInstgram(
                  context, listFacBookInstaTwitter.first, provider, url);
            }
          } else if (url.contains('fb.watch') || url.contains('facebook.com')) {
            await facebook(url);

            if (listFacBookInstaTwitter.isEmpty) {
              await getDataFileInstaFace(url);
              OverlayProgressIndicator.hide();
              FaceBookInstgramDownload().downloadFaceBookAndInstgram(
                  context, vidoData!, provider, url);
            } else {
              OverlayProgressIndicator.hide();
              OtherFaceInstaDownload().downloadFaceBookAndInstgram(
                  context, listFacBookInstaTwitter.first, provider, url);
            }
          }
        } else {
          if (url.contains('instagram.com')) {
            OverlayProgressIndicator.hide();
            OtherFaceInstaDownload().downloadFaceBookAndInstgram(
                context, listFacBookInstaTwitter.first, provider, url);
          } else if (url.contains('fb.watch') || url.contains('facebook.com')) {
            OverlayProgressIndicator.hide();
            OtherFaceInstaDownload().downloadFaceBookAndInstgram(
                context, listFacBookInstaTwitter.first, provider, url);
          }
        }
      } else if (url.contains('vt.tiktok.com') || url.contains('tiktok.com')) {
        if (tiktokData.isEmpty) {
          await linksTiktok(url);
          OverlayProgressIndicator.hide();

          TikTokDownloader()
              .buildBottomTiktokDownload(context, provider, tiktokData.last);
        } else {
          OverlayProgressIndicator.hide();
          TikTokDownloader()
              .buildBottomTiktokDownload(context, provider, tiktokData.last);
        }
      } else if (url.contains('x.com') || url.contains('twitter.com')) {
        if (listFacBookInstaTwitter.isEmpty) {
          await twitter2(url);
          if (listFacBookInstaTwitter.isEmpty) {
            await twitter(url);
            OverlayProgressIndicator.hide();
            OtherFaceInstaDownload().downloadFaceBookAndInstgram(
                context, listFacBookInstaTwitter.first, provider, url);
          } else {
            OverlayProgressIndicator.hide();
            OtherFaceInstaDownload().downloadFaceBookAndInstgram(
                context, listFacBookInstaTwitter.first, provider, url);
          }
        } else {
          OverlayProgressIndicator.hide();
          OtherFaceInstaDownload().downloadFaceBookAndInstgram(
              context, listFacBookInstaTwitter.first, provider, url);
        }
      } else {
        OverlayProgressIndicator.hide();
        _elementeWidget.pushed(WebViewSearch(url: url, idTabs: ''), context);
      }
    }

    var search = provider.itemSearch.isNotEmpty
        ? provider.itemSearch
            .where((element) => element.search_search == url)
            .map((e) => e.search_search)
            .firstWhere((element) => true, orElse: () => '')
            .toString()
        : '';

    print(search);
    if (search.isEmpty) {
      final title = Uri.parse(url);
      provider.itemSearch.add(Search(
          id_search: '',
          nameUrl: title.host.toString().isEmpty ? url : title.host.toString(),
          search_search: url,
          date_search: DateTime.now().toString(),
          img: ''));
      api.addData({
        'search_search': url,
        'date_search': DateTime.now().toString(),
        'nameUrl': title.host.toString().isEmpty ? url : title.host.toString(),
      }, 'search').then((value) => print(value));
    }
  }

  Future<void> getDataFileInstaFace(String url) async {
    try {
      vidoData = await Extractor.getDirectLink(link: url);
    } catch (e) {}
  }

  Future<void> instgram(String url) async {
    try {
      listFacBookInstaTwitter = await processData.instgramFacebook(
          {'url': url, 'lang_code': 'en', 'token': ''},
          'https://fastdl.app/c/',
          'insta');
    } catch (e) {}
  }

  Future<void> facebook(String url) async {
    try {
      listFacBookInstaTwitter = await processData.instgramFacebook(
          {'URLz': url}, 'https://fdown.net/download.php', 'face');
    } catch (e) {}
  }

  Future<void> twitter2(String url) async {
    try {
      listFacBookInstaTwitter = await processData.twitter2Down(url);
      // }
    } catch (e) {
      print(e);
    }
  }

  Future<void> twitter(String url) async {
    try {
      String getId = (url).split('/').last;
      listFacBookInstaTwitter = await processData.twitterFiles(getId, url);
      // }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDataOfYoutube(String url) async {
    try {
      getInfoFile = await VideoExtractor.getStream(url);
    } catch (e) {}
  }

  Future<void> getDataOfYoutubePlayList(String url) async {
    try {
      playList = await PlaylistExtractor.getPlaylistStreams(url);
    } catch (e) {}
  }

  Future<void> otherGetDataVideo(String url) async {
    try {
      jsonVideo = await processData.oherGetDataVideo(url);
      setState(() {
        if (jsonVideo.isNotEmpty && !jsonVideo.containsKey('status')) {}
      });
    } catch (e) {}
  }

  Future<void> linksTiktok(String url) async {
    print('-------------------------------------');
    tiktokData = await processData.getDataVideoOfTikTok(url);
    if (tiktokData.isNotEmpty) {
      print(tiktokData.length);
    } else {}
    print('-------------------------------------');
  }
}
