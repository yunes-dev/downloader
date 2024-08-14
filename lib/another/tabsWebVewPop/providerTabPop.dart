import 'dart:typed_data';

import 'package:download_every_thing/another/tabsWebVewPop/popTabWeb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/databaseAndAPI/dataApi.dart';

class PopWebLIst {
  List<PopTabWeb> listWeb;
  PopWebLIst({required this.listWeb});
}

class ProviderTabPop extends ChangeNotifier {
  PopWebLIst? obListWeb;
  PopWebLIst? get listTestWeb => obListWeb;
  DataAPI _api = DataAPI();
  String? idTab;
  String? searchTxt;
  bool? pubTab;
  bool? adsWebShow;
  Future<void> setPlivage(bool pub, bool ads) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    pubTab = pub;
    adsWebShow = ads;
    await prefs.setBool('pubTab', pub);
    await prefs.setBool('adsWeb', ads);
    notifyListeners();
  }

  void getPlivage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    pubTab = await prefs.getBool('pubTab') ?? false;
    adsWebShow = await prefs.getBool('adsWeb') ?? false;
    notifyListeners();
  }

  void updateListWeb(PopWebLIst testWebLIst) {
    obListWeb = testWebLIst;
    notifyListeners();
  }

  Future<Uint8List?> updateScreenshot(
      InAppWebViewController? webViewController) async {
    var screenshot = await webViewController
        ?.takeScreenshot(
            screenshotConfiguration: ScreenshotConfiguration(
                compressFormat: CompressFormat.JPEG, quality: 20))
        .timeout(
          const Duration(milliseconds: 1500),
          onTimeout: () => null,
        );
    return screenshot;
  }

  Future<void> upDateAllList() async {
    List<PopTabWeb> item = [];
    await _api.GetAllData("select * from tabWeb").then((value) {
      value.forEach((element) {
        item.add(PopTabWeb(
          id_tab: element['id_tab'].toString(),
          name_tab: element['name_tab'],
          url_tab: element['url_tab'],
          img: Uint8List.fromList(element['img']),
        ));
      });
    });
    obListWeb?.listWeb = item;
    notifyListeners();
    // updateListWeb(obListWeb!);
  }

  Future<void> addTabWeb(String urlLink, String namePage, Uint8List img) async {
    if (urlLink.isNotEmpty || namePage.isNotEmpty) {
      obListWeb?.listWeb.add(PopTabWeb(
        id_tab: '',
        name_tab: namePage,
        url_tab: urlLink, //'https://www.youtube.com/'
        img: img,
      ));
      await _api.addData(
          {'name_tab': namePage, 'url_tab': urlLink, 'img': img}, 'tabWeb');
    }
    notifyListeners();
  }

  Future<void> setNewIdTab(String idTab) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('idTab', idTab);
    notifyListeners();
  }

  Future<String> getIdTab() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idTab = await prefs.getString('idTab');
    notifyListeners();
    return idTab.toString();
  }

  void updateTabWeb(
      String name_tab, String url_tab, String id_tab, Uint8List img) async {
    await _api.UpdateData({
      'name_tab': name_tab,
      'url_tab': url_tab,
      'id_tab': id_tab,
      'img': img
    }, 'tabWeb', 'id_tab');
    upDateAllList();
  }

  Future<void> closeTabWeb(String id) async {
    obListWeb?.listWeb.removeWhere((element) => element.id_tab == id);
    notifyListeners();
    await _api.DeleteData('tabWeb', 'id_tab', id);
  }

  Future<void> closeAllTabWeb() async {
    obListWeb?.listWeb.clear();
    notifyListeners();
    await _api.DeleteAllData('tabWeb');
  }

  setSerachTxt(String? search) {
    searchTxt = search;
    //   print(searchTxt);
    // print('*****************************************************************');
    notifyListeners();
  }
}
