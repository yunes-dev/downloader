import 'dart:async';
import 'dart:typed_data';
import 'package:download_every_thing/another/classes/models/search.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../classes/components/classStaticLists.dart';
import '../classes/components/components.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/fileModel.dart';
import '../download/providerDownload.dart';
import '../tabsWebVewPop/popTabWeb.dart';
import '../tabsWebVewPop/providerTabPop.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();
  List pages = ClassStaticLists.pagesBottomBar;

  int indexPage = 0;
  DataAPI api = DataAPI();
  Components elementeWidget = Components();
  List<FileModel> fileItems = [];
  late StreamSubscription intentDataStreamSubscription;
  List<Search> itemSearch = [];
  Future<void> getSearch() async {
    itemSearch.clear();
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    await api.GetAllData("select * from search").then((value) {
      setState(() {
        value.forEach((element) {
          setState(() {
            itemSearch.add(
              Search(
                  id_search: element['id_search'].toString(),
                  nameUrl: element['nameUrl'].toString(),
                  search_search: element['search_search'],
                  date_search: element['date_search'].toString(),
                  img: ''),
            );
          });
        });
      });
    });
    setState(() {
      provider.itemSearch = itemSearch;
    });
  }

  void getItemFiles() async {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    List<FileModel> newFiles = [];
    List<String> listCountRun = [];
    await api.GetAllData("select * from fileModel").then((value) {
      value.forEach((element) {
        setState(() {
          if (element['downloading'] == 'running') {
            listCountRun.add(element['fileID']);
          }
          newFiles.add(FileModel(
              id_file: element['id_file'].toString(),
              fileTitle: element['fileTitle'],
              filePublishDate: element['filePublishDate'],
              fileID: element['fileID'],
              downloading: element['downloading'],
              url: element['url'],
              size: int.parse(element['size'].toString()),
              sizeLocal: int.parse(element['sizeLocal'].toString()),
              typDown: element['typDown'],
              downurl: element['downurl'].toString(),
              pathfile: element['pathfile'],
              fileQuality: element['fileQuality'].toString(),
              imageFile: element['imageFile'],
              txtMassege: element['txtMassege'],
              progress: double.parse(element['progress'].toString()),
              type: element['type']));
        });
      });
    });
    // notifyListeners();
    setState(() {
      fileItems = newFiles;
    });

    provider.updateItems(GetListItems(fileItems: fileItems));
    provider
        .updateCountDwonload(CheckCounteDownload(countDownload: listCountRun));
    provider.checkDownloadFilesIsWaite();
  }

  List<PopTabWeb> tabWebView = [];
  void getTabWebView() async {
    final provider = Provider.of<ProviderTabPop>(context, listen: false);
    List<PopTabWeb> newFiles = [];

    await api.GetAllData("select * from tabWeb").then((value) {
      value.forEach((element) {
        setState(() {
          newFiles.add(PopTabWeb(
            id_tab: element['id_tab'].toString(),
            name_tab: element['name_tab'],
            url_tab: element['url_tab'],
            img: Uint8List.fromList(element['img']),
          ));
        });
      });
    });
    // notifyListeners();
    setState(() {
      tabWebView = newFiles;
    });
    provider.getPlivage();
    provider.updateListWeb(PopWebLIst(listWeb: tabWebView));
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
    getSearch();
    getShareLink();
    getTabWebView();
    getItemFiles();
  }

  getShareLink() {
    final providerOfPop = Provider.of<ProviderTabPop>(context, listen: false);
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        providerOfPop.setSerachTxt(value);
        //   _sharedText = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
      print(
          '--------------------------------------------------------------------------33');
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((value) {
      setState(() {
        providerOfPop.setSerachTxt(value);
        // _sharedText = value.toString();
        print(value);
      });
      print(
          '--------------------------------------------------------------------------22');
    });
  }

  @override
  void dispose() {
    super.dispose();
    intentDataStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: bottomNavigationKey,
        index: indexPage,
        height: 60.0,
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.file_download_outlined, size: 30),
          Icon(Icons.person, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: elementeWidget.lightColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) async {
          setState(() {
            indexPage = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: pages[indexPage],
    );
  }
}
