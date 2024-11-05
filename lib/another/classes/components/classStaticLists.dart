import 'package:download_every_thing/another/classes/models/aboutUsModel.dart';
import 'package:download_every_thing/another/setting/settingWidget.dart';
import 'package:flutter/material.dart';
import '../../download/listDownloader/ListDownloader.dart';
import '../../homeScreen/bodyHomsScreen.dart';
import '../models/search.dart';
import '../models/widgetList.dart';

class ClassStaticLists {
  static List pagesBottomBar = [
    BodyHomsScreen(),
    const ListTitleDownLOader(),
    const SettingWidget(),
  ];
  static List<AboutUsModel> listSetting = [
    AboutUsModel('1', 'اعدادات العامة', '', Icons.settings),
    AboutUsModel('2', 'اعدادات التصفح', '', Icons.open_in_browser_outlined),
    AboutUsModel('3', 'اتصل بنا', '', Icons.contact_support)
  ];
  List<WidgetListTabBar> topBarListBodyHomeScreen = [
    WidgetListTabBar(
        name: 'Popular',
        widget: Container(
          child: Text('index1'),
        ),
        url: '',
        img: "assets/images/youtube.png"),
    WidgetListTabBar(
        name: 'Most Visited',
        widget: Container(
          child: Text('index2'),
        ),
        url: '',
        img: "assets/images/youtube.png"),
    WidgetListTabBar(
        name: 'Recent',
        widget: Container(child: Text('index3')),
        url: '',
        img: "assets/images/youtube.png"),
    WidgetListTabBar(
        name: 'Explore',
        widget: Container(child: Text('index4')),
        url: '',
        img: "assets/images/youtube.png"),
  ];
  List<Search> localSearch = [
    Search(
        id_search: '1',
        nameUrl: 'Google',
        search_search: 'https://www.google.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/google.png"),
    // Search(
    //     id_search: '2',
    //     nameUrl: 'Youtube',
    //     search_search: 'https://youtube.com/',
    //     date_search: DateTime.now().toString(),
    //     img: "assets/images/youtube.png"),
    Search(
        id_search: '3',
        nameUrl: 'Tiktok',
        search_search: 'https://www.tiktok.com/en/',
        date_search: DateTime.now().toString(),
        img: "assets/images/tiktok.png"),
    Search(
        id_search: '4',
        nameUrl: 'Instgram',
        search_search: 'https://www.instagram.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/instagram.png"),
  ];
  List<Search> localSearchDirect = [
    Search(
        id_search: '1',
        nameUrl: 'Google',
        search_search: 'https://www.google.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/google.png"),
    Search(
        id_search: '2',
        nameUrl: 'Duck Duck Go',
        search_search: 'https://duckduckgo.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/duck.png"),
    Search(
        id_search: '3',
        nameUrl: 'FaceBook',
        search_search: 'https://www.facebook.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/facebook.png"),
    Search(
        id_search: '4',
        nameUrl: 'Bing',
        search_search: 'https://www.bing.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/bing.png"),
    Search(
        id_search: '5',
        nameUrl: 'Linkedin',
        search_search: 'https://linkedin.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/linkedin.png"),
    Search(
        id_search: '6',
        nameUrl: 'Twitter',
        search_search: 'https://twitter.com/?lang=ar',
        date_search: DateTime.now().toString(),
        img: "assets/images/twitter.png"),
    Search(
        id_search: '7',
        nameUrl: 'Tiktok',
        search_search: 'https://www.tiktok.com/en/',
        date_search: DateTime.now().toString(),
        img: "assets/images/tiktok.png"),
    Search(
        id_search: '8',
        nameUrl: 'Instagram',
        search_search: 'https://www.instagram.com/',
        date_search: DateTime.now().toString(),
        img: "assets/images/instagram.png"),
  ];

  // List<Search> localSearchDirect = [
  //   Search(
  //       id_search: '1',
  //       nameUrl: 'Google',
  //       search_search: 'https://www.google.com/',
  //       date_search: DateTime.now().toString(),
  //       iconData: Bootstrap.google),
  //   Search(
  //       id_search: '2',
  //       nameUrl: 'Yahoo',
  //       search_search: 'https://youtube.com/',
  //       date_search: DateTime.now().toString(),
  //       iconData: IonIcons.logo_yahoo),
  //   Search(
  //       id_search: '3',
  //       nameUrl: 'Baidu',
  //       search_search: 'https://www.facebook.com/',
  //       date_search: DateTime.now().toString(),
  //       iconData: Bootstrap.search_heart_fill),
  //   Search(
  //       id_search: '4',
  //       nameUrl: 'Bing',
  //       search_search: 'https://www.bing.com/',
  //       date_search: DateTime.now().toString(),
  //       iconData: IonIcons.search_circle),
  //   Search(
  //       id_search: '5',
  //       nameUrl: 'Duck Duck Go',
  //       search_search: 'https://duckduckgo.com/',
  //       date_search: DateTime.now().toString(),
  //       iconData: IonIcons.search_sharp),
  //   Search(
  //       id_search: '6',
  //       nameUrl: 'Yandex',
  //       search_search: 'https://twitter.com/?lang=ar',
  //       date_search: DateTime.now().toString(),
  //       iconData: BoxIcons.bxs_search_alt_2),
  //   Search(
  //       id_search: '7',
  //       nameUrl: 'Tiktok',
  //       search_search: 'https://www.tiktok.com/en/',
  //       date_search: DateTime.now().toString(),
  //       iconData: Bootstrap.tiktok),
  //   Search(
  //       id_search: '8',
  //       nameUrl: 'Instagram',
  //       search_search: 'https://www.instagram.com/',
  //       date_search: DateTime.now().toString(),
  //       iconData: Bootstrap.instagram),
  // ];

  // list of Ad URL filters to be used to block ads loading.
  final adUrlFilters = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
    ".*.google-analytics.com/.*",
    ".*.adservice.google.*/.*",
    ".*.adbrite.com/.*",
    ".*.exponential.com/.*",
    ".*.quantserve.com/.*",
    ".*.scorecardresearch.com/.*",
    ".*.zedo.com/.*",
    ".*.adsafeprotected.com/.*",
    ".*.teads.tv/.*",
    ".*.outbrain.com/.*"
  ];
  static List<AboutUsModel> listAbuotUs = [
    //listOfItem("1", "موقعنا", "https://meta-code-ye.com", Icons.web),
    AboutUsModel(
        "1",
        "Privacy Policy",
        "https://meta-code-ye.com/website/policyDownloader.html",
        Icons.privacy_tip),
    AboutUsModel(
        "2",
        "فيسبوك",
        "https://www.facebook.com/profile.php?id=100088896754749",
        Icons.facebook),
    AboutUsModel(
        "3",
        "أنستجرام",
        "https://instagram.com/metacode_ye?igshid=YmMyMTA2M2Y=",
        Icons.camera_alt_outlined),
    AboutUsModel("4", "البريد الألكتروني", "mailto:metacod@meta-code-ye.com",
        Icons.email),
    AboutUsModel(
        "5", "تيليجرام", "https://t.me/Metacodeye_bot", Icons.telegram),
    AboutUsModel(
        "6",
        "يوتيوب",
        "https://www.youtube.com/channel/UC3cxBKPuMZOmy2GZ9IIXKYQ",
        Icons.ondemand_video_rounded),
    AboutUsModel(
        "7",
        "تطبيق المساعد الذكي",
        "https://play.google.com/store/apps/details?id=com.meta_chat_gpt",
        Icons.chat_outlined),
    // AboutUsModel("8", "موقع التطبيق",
    //     "https://meta-code-ye.com/website/mobster/html/index.html", Icons.web)
  ];
}
