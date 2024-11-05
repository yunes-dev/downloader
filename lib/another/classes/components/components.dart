import 'dart:convert';
import 'dart:io';
import 'package:app_version_update/app_version_update.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_progress_indicator/overlay_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../version/update.dart';
import 'package:path/path.dart' as path;

const MethodChannel platformChannel = MethodChannel('clipboarding');

class Components {
  AppBar appBar(String title, Color color, Icon icon, Function() onPress1,
      Function() onPress2, BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: icon,
        onPressed: onPress1,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(icon: Icon(Icons.person_pin), onPressed: onPress2
            // () {
            //   pushed(Profile(), context);
            // },
            ),
      ],
      centerTitle: true,
      backgroundColor: color,
    );
  }

  Future<void> pushed(Widget classt, BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => classt));
  }

  Future<void> awaitPushed(Widget classt, BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => classt));
  }

  Future<void> pushReplce(Widget classt, BuildContext context) async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => classt));
  }

  Future<void> toast(String msg) async {
    try {
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        textColor: Colors.white,
        fontSize: 16.0,
        timeInSecForIosWeb: 1,
      );
    } catch (e) {
      debugPrint('error');
    }
  }

  TextDirection alignTxtRightToLeft(String txt) {
    TextDirection? align;
    List<String> messageLines1 = txt.split('\n');
    print(messageLines1);
    for (var i = 0; i < messageLines1.length; i++) {
      String line = messageLines1[i];

      RegExp arabicRegex = RegExp(r'[\u0600-\u06FF]');
      if (arabicRegex.hasMatch(line)) {
        align = TextDirection.rtl;

        // set the text direction to RTL if line contains Arabic
      } else {
        align = TextDirection.ltr;
      }
    }
    return align!;
  }

  String hasvalidurl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regexp = new RegExp(pattern);
    if (value.length == 0) {
      return 'null';
    } else if (!regexp.hasMatch(value)) {
      return 'null';
    }
    return 'url';
  }

  Future<void> verifyVersion(BuildContext context) async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appVresion = packageInfo.version + '+' + packageInfo.buildNumber;
    // print(appVresion);

    // DateTime dateTime = DateTime.now();
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final int counter = prefs.getInt('counter') ?? 0;
    // final String time = prefs.getString('time') ?? '';
    // try {
    //   List version = await APIHosting()
    //       .getDataFRomHostByPost("$server/userActive/version/show.php", {});
    //   var getCurrectVersion = version.isNotEmpty
    //       ? version
    //           .where((element) => element['name'].toString() == appVresion)
    //           .map((e) => e['name'].toString())
    //           .firstWhere(
    //             (element) => true,
    //             orElse: () => '',
    //           )
    //       : '';
    //   if (getCurrectVersion.isEmpty) {
    //     if (counter >= 2) {
    //       print(
    //           "======================================================================");
    //       print("is larg");
    //       pushReplce(VersionCheckPage(), context);
    //     } else {
    //       if (time !=
    //           DateTime(dateTime.year, dateTime.month, dateTime.day)
    //               .toString()) {
    //         await prefs.setString(
    //             'time',
    //             DateTime(dateTime.year, dateTime.month, dateTime.day)
    //                 .toString());
    //         await prefs.setInt('counter', counter + 1);
    //         print(
    //             "======================================================================");
    //         print("ok add this day");
    //       }

    //       await AppVersionUpdate.showAlertUpdate(
    //         context: context,
    //         backgroundColor: Colors.grey[200],
    //         title: 'يتوفر أصدار جديد من التطبيق',
    //         titleTextStyle:
    //             const TextStyle(color: Colors.black, fontSize: 20.0),
    //         content: 'يجب عليك تحديث التطبيق من أجل استخدام اللمميزات الجديدة',
    //         contentTextStyle: const TextStyle(
    //           color: Colors.black,
    //           fontWeight: FontWeight.w400,
    //         ),
    //         updateButtonText: 'تحديث',
    //         cancelButtonText: 'الغاء',
    //       );
    //     }
    //   }
    // } catch (e) {
    //   print(e);
    //   print('-----------------------------------------------------------');
    // }
    DateTime dateTime = DateTime.now();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int counter = prefs.getInt('counter') ?? 0;
    final String time = prefs.getString('time') ?? '';
    try {
      await AppVersionUpdate.checkForUpdates(
        appleId: '1459706595',
        playStoreId: 'com.mc_downloader22',
        country: 'ye',
      ).then((result) async {
        if (result.canUpdate!) {
          if (counter >= 1) {
            print(
                "======================================================================");
            print("is larg");
            pushReplce(VersionCheckPage(), context);
            //items.contains(
            //DateTime(dateTime.year, dateTime.month, dateTime.day).toString())
          } else {
            if (time !=
                DateTime(dateTime.year, dateTime.month, dateTime.day)
                    .toString()) {
              await prefs.setString(
                  'time',
                  DateTime(dateTime.year, dateTime.month, dateTime.day)
                      .toString());
              await prefs.setInt('counter', counter + 1);
              print(
                  "======================================================================");
              print("ok add this day");
            }

            await AppVersionUpdate.showAlertUpdate(
              appVersionResult: result,
              context: context,
              backgroundColor: Colors.grey[200],
              title: 'يتوفر أصدار جديد من التطبيق',
              titleTextStyle:
                  const TextStyle(color: Colors.black, fontSize: 20.0),
              content:
                  'يجب عليك تحديث التطبيق من أجل استخدام اللمميزات الجديدة',
              contentTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              updateButtonText: 'تحديث',
              cancelButtonText: 'الغاء',
            );
          }
        }
      });
    } catch (e) {}
  }

  BoxDecoration buttonBoxDecoration(BuildContext context,
      [String color1 = "", String color2 = ""]) {
    Color c1 = Theme.of(context).primaryColor;
    Color c2 = Theme.of(context).canvasColor;

    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      gradient: gradient,
      color: Colors.deepPurple.shade300,
      borderRadius: BorderRadius.circular(30),
    );
  }

  bool isFile(FileSystemEntity entity) {
    return FileSystemEntity.isFileSync(entity.path);
  }

  Future<int> getPermison() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    var video = await Permission.videos.request();
    var photo = await Permission.photos.request();
    //var mang = await Permission.notification.request();
    var audio = await Permission.audio.request();
    await Permission.systemAlertWindow.request();
    await Permission.manageExternalStorage.request();
    var perm = await Permission.storage.request();
    if (deviceInfo.version.sdkInt > 32) {
      if (video.isGranted && photo.isGranted && audio.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      if (perm.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<String> getPath(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String storePath = prefs.getString('path') ?? "";
    var perm = await getPermison();
    if (perm == 1) {
      if (storePath.isEmpty || storePath == "") {
        var path = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
        print(path);
        await Directory("${path}/everyThing").create();
        var target = await Directory("${path}/everyThing/$type").create();
        return target.path;
      } else {
        return storePath;
      }
    } else {
      return '';
    }
  }

  String getLocalApplicationDocumentsFilesRoute(
      String foloder, Directory dir, String fileName) {
    String applicationDirectoryPath = dir.path;
    return path.join(applicationDirectoryPath, foloder, fileName);
  }

  getDocumentsDirectory() async {
    Components elementeWidget = Components();
    Directory dir = Directory(await elementeWidget.getPath(''));
    if (dir.path.isNotEmpty) {
      return dir;
    } else {
      return Directory('');
    }
  }

  Future<bool> checkUrlVideo(String url) async {
    // final List<String> videoExtensions = [
    //   '.mp4',
    //   '.avi',
    //   '.mkv',
    //   '.mov',
    //   '.wmv',
    //   '.flv',
    // ];
    var lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('.mp4') ||
        lowerUrl.contains('.avi') ||
        lowerUrl.contains('.mkv') ||
        lowerUrl.contains('.mov') ||
        lowerUrl.contains('.wmv') ||
        lowerUrl.contains('.flv') ||
        lowerUrl.contains('.m3u8')) {
      //  print(lowerUrl.toString().split('/').last);
      return true;
    } else {
      //print('errorr');
      return false;
    }
  }

  String removeSymol(String title) {
    RegExp symbolsAndQuotesPattern =
        RegExp(r'[^\p{L}\p{N}\s.]+', unicode: true);
    String textWithoutSymbolsAndQuotes =
        title.replaceAll(symbolsAndQuotesPattern, '');

    print(textWithoutSymbolsAndQuotes);
    return textWithoutSymbolsAndQuotes;
  }

  String removeSymolInFristLast(
    String item,
  ) {
    var splitFristSymol =
        item.contains('"') ? item.substring(2, item.length) : item;
    var splitLastSyml = splitFristSymol.contains('"')
        ? splitFristSymol.substring(0, splitFristSymol.length - 2)
        : splitFristSymol;
    return splitLastSyml;
  }

  String splitSizeFile(String size) {
    double getTotalSize = (int.parse(size) / 1024 / 1024);
    String splitSize = getTotalSize.toString().split('.').first;
    String splitSizeAfterPoint =
        (getTotalSize.toString().split('.').last).length <= 1
            ? (getTotalSize.toString().split('.').last).toString()
            : (getTotalSize.toString().split('.').last).substring(0, 2);
    String readySize = '$splitSize.$splitSizeAfterPoint';
    return readySize;
  }

  TextStyle textStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
  }

  Gradient? gradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 106, 40, 69),
        Color.fromARGB(255, 231, 24, 24),
      ],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);
  final darkColr = Color.fromARGB(255, 106, 40, 69);
  final lightColor = Color.fromARGB(255, 231, 24, 24);
  final glowBoxShadow = [
    BoxShadow(
      color: Color.fromARGB(255, 1, 33, 51).withOpacity(.4),
      blurRadius: 6.0,
      spreadRadius: 3.0,
      offset: const Offset(
        0.0,
        3.0,
      ),
    ),
  ];
  MaterialColor Mcolor = const MaterialColor(
    0xFFE71818,
    <int, Color>{
      50: Color(0xFFE71818),
      100: Color(0xFFE71818),
      200: Color(0xFFE71818),
      300: Color(0xFFE71818),
      400: Color(0xFFE71818),
      500: Color(0xFFE71818),
      600: Color(0xFFE71818),
      700: Color(0xFFE71818),
      800: Color(0xFFE71818),
      900: Color(0xFFE71818),
    },
  );
  dialogBuildToExit(BuildContext context) async {
    OverlayProgressIndicator.show(
      context: context,
      backgroundColor: Colors.black45,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              'جاري التحميل',
            ),
            GestureDetector(
                onTap: () {
                  OverlayProgressIndicator.hide();
                },
                child: Text(
                  'الغاء',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }

  Widget imageCatch(String urlImage) {
    return urlImage.contains('http')
        ? CachedNetworkImage(
            imageUrl: "${urlImage}",

            placeholder: (context, url) =>
                const CircularProgressIndicator(), // عنصر بديل أثناء تحميل الصورة
            errorWidget: (context, url, error) => Image.asset(
                'assets/images/logo.png'), // صورة بديلة في حالة حدوث خطأ
          )
        : urlImage.isEmpty
            ? Image.asset('assets/images/logo.png')
            : Image.memory(
                base64Decode(urlImage),
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/logo.png');
                },
              );
  }

  Widget circulCatchImageNetwork(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: MediaQuery.of(context).size.width / 7.70,
        height: MediaQuery.of(context).size.width / 7.70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/logo.png',
        width: 53.0,
        height: 53.0,
      ),
    );
  }

  String getTitleInstgram(String url) {
    if (url.contains('.mp4')) {
      //print('title');
      String title = (url.split('__expires=').last).split('&uri').first;
      title = title.substring(0, 70) + '.mp4';
      String title2 = removeSymol(title);
      // print(title2);
      return title2;
    } else {
      //   print('title');
      String title = getBaseUrl(url).split('/').last;
      //print(title);
      return title;
    }
  }

  bool containsNonEnglishLetters(String text) {
    // Regular expression to match Arabic letters or non-English characters
    RegExp nonEnglishCharacters = RegExp(r'[^\p{Latin}]');

    // Use the RegExp's 'hasMatch' method to check if there's a match
    return nonEnglishCharacters.hasMatch(text);
  }

  String getBaseUrl(pUrl) {
    //print(pUrl);
    final parse = Uri.parse(pUrl);
    final uri = parse.query != '' ? parse.replace(query: '') : parse;
    String url = uri.toString();

    if (url.endsWith('?')) url = url.replaceAll('?', '');
    return url;
  }

  Future<String> shareFiles(String files) async {
    final result = await Share.shareXFiles(
      [XFile(files)],
    );
    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
      return 'share done';
    } else {
      return 'share error';
    }
  }

  Future<String> invokeKotlinMethod(String channelName) async {
    return await platformChannel.invokeMethod(channelName);
  }
}
