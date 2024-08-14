import 'dart:convert';
import 'dart:io';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/classes/models/TiktokData.dart';
import 'package:download_every_thing/another/searchDirctly/searchDirctly.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:newpipeextractor_dart/extractors/videos.dart';
import 'package:newpipeextractor_dart/models/video.dart';
import 'package:newpipeextractor_dart/utils/httpClient.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../../download/providerDownload.dart';
import '../models/faceBookInstagram.dart';
import '../models/fileModel.dart';

class ProcessData {
  DateTime dateTime = DateTime.now();
  Future<YoutubeVideo> getInfoOfyoutube(String url) async {
    // final ff = await ExtractorHttpClient.getContentLength(url);
    var videoExtrac = await VideoExtractor.getStream(url);
    // final stream = videoExtrac.videoStreams;
    return videoExtrac;
  }

  Future<int?> getTotalSize(String url) async {
    final size = await ExtractorHttpClient.getContentLength(url);
    // print(size);
    return size;
  }

  // Future<int?> sizeOfWeb(String url) async {
  //   int? size;
  //   await DGHubWebScrapper.getFullLoaded(
  //     url,
  //     onDownloadStart: (p0, p1) {
  //       size = p1.contentLength;
  //       print(size);
  //       print(
  //           '*********************************************************************11111111111111111111');
  //     },
  //   );
  //   return size;
  // }

  Future<Map> oherGetDataVideo(String url) async {
    try {
      var respons = await http.post(Uri.parse('https://yt5s.io/api/ajaxSearch'),
          body: {'q': url, 'vt': 'home'});
      Map jsonVideo = json.decode(respons.body);

      if (jsonVideo.containsKey('links')) {
        return jsonVideo;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Whatsapp> getDataWhatsApp(
      String url, String name, String urlImg, String contion) async {
    // try {
    if (url.contains(contion)) {
      return Whatsapp(name, url.toString(), urlImg);
    } else {
      var respons = await http.get(Uri.parse(url));
      var link = parse(respons.body)
          .getElementsByTagName("a")
          .where((element) => element.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      print(link);
      var urlFile = link.where((element) => element!.contains(contion)).first;

      return Whatsapp(name, urlFile.toString(), urlImg);
    }
    //  } catch (e) {}
  }

  Future<List<FaceBookInstagram>> instgramFacebook(
      Map<String, dynamic> body, String url, String type) async {
    List<FaceBookInstagram> data = [];
    try {
      var respons = await http.post(Uri.parse(url), body: body);
      // Map jsonVideo = {};
      // print(body);
      // print(respons.body);
      // var html = parse(respons.body)
      //     .getElementsByClassName('search_results_lightbox_mode');
      var links = parse(respons.body)
          .getElementsByTagName('a')
          .where((element) => element.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      // print(links);
      type == 'face'
          ? links.removeWhere((element) => !element!.contains('.mp4'))
          : null;

      print(links);
      var img = type == 'face'
          ? parse(respons.body)
              .getElementsByClassName('lib-img-show')
              .where((element) => element.attributes.containsKey('src'))
              .map((e) => e.attributes['src'])
              .first
          : parse(respons.body)
              .getElementsByTagName('img')
              .where((element) => element.attributes.containsKey('src'))
              .map((e) => e.attributes['src'])
              .first;
      img = img!.contains('http')
          ? img
          : img.split('data:image/jpeg;charset=utf-8;base64,').last;
      // var f = base64Decode(img!);
      // print(f);
      data.add(FaceBookInstagram(
          id: '', name: '', img: img.toString(), url: url, linksDown: links));
      if (links.isNotEmpty) {
        return data;
      } else {
        return data;
      }
    } catch (e) {
      return data;
    }
  }

  // Future<List<FaceBookInstagram>> twitterFiles(String id) async {
  //   String url = 'https://twitter-video-download.com/en/tweet/$id';
  //   List<FaceBookInstagram> data = [];
  //   try {
  //     var htte = await http.get(
  //       Uri.parse(url),
  //     );
  //     var htmlFile = parse(htte.body)
  //         .head
  //         ?.getElementsByTagName('script')
  //         .where(
  //             (element) => element.attributes['type'] == 'application/ld+json')
  //         .first;

  //     if (htmlFile != null) {
  //       List<String> lines = htmlFile.text.split('\n');
  //       lines.removeWhere((line) => line.trim().isEmpty);
  //       lines.removeWhere((line) => line.contains('description'));
  //       lines.removeWhere((line) => line.contains('https://t.co'));
  //       var jsonAfterSpilt = lines.join('\n');
  //       print(jsonAfterSpilt);
  //       Map<String, dynamic> jsonFile = json.decode(jsonAfterSpilt);

  //       print(jsonFile['name']);
  //       List img = jsonFile['thumbnailUrl'];
  //       print(img.first);
  //       print(jsonFile['contentUrl']);
  //       data.add(FaceBookInstagram(
  //           id: id.toString(),
  //           name: jsonFile['name'],
  //           img: img.first,
  //           url: url,
  //           linksDown: [jsonFile['contentUrl']]));
  //       return data;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     return [];
  //   }
  // }
  Future<List<FaceBookInstagram>> twitterAPI(String id, String url) async {
    List<FaceBookInstagram> dataApi = [];
    try {
      var htte = await http.get(
        Uri.parse(
            'https://api.twitterpicker.com/tweet/mediav2/g?id=$id&gt=2&capmode=false'),
      );
      Map data = json.decode(htte.body);
      if (data.isNotEmpty) {
        List<dynamic> listItem = data['media']['videos'];
        print(listItem);
        var image = listItem
            .where((element) => element.toString().contains('thumbnail'))
            .map((e) => e['thumbnail'])
            .first;
        List<dynamic> linksList = listItem
            .where((element) => element.toString().contains('variants'))
            .map((e) => e['variants'])
            .first;

        List<String> links = linksList
            .where((element) => element.toString().contains('url'))
            .map((e) => e['url'].toString())
            .toList();
        print(links);
        dataApi.add(FaceBookInstagram(
            id: id, name: '', img: image, url: url, linksDown: links));
        return dataApi;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<FaceBookInstagram>> twitter2Down(String url) async {
    List<FaceBookInstagram> data = [];
    try {
      var getToken = await http.get(
        Uri.parse('https://anydownloader.com/en/'),
      );
      var token = parse(getToken.body)
          .getElementsByTagName('input')
          .where((element) => element.attributes['name'].toString() == "token")
          .map((e) => e.attributes['value'].toString())
          .first;
      print(token);

      var respons = await http.post(
          Uri.parse("https://anydownloader.com/wp-json/aio-dl/video-data/"),
          body: {'url': url, 'token': token});
      Map jsonFile = json.decode(respons.body);
      print(jsonFile);

      var title = jsonFile['title'];
      var img = jsonFile['thumbnail'];
      List getLinks = jsonFile['medias'];
      List<String> links = getLinks.map((e) => e['url'].toString()).toList();
      print(links);
      if (links.isNotEmpty) {
        data.add(FaceBookInstagram(
            id: '', name: title, img: img, url: url, linksDown: links));
        return data;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
    //
  }

  // Future<void> get(String url) async {
  //   http.Response response = await http.get(Uri.parse(url), headers: headers);
  //   updateCookie(response);
  //   print(response.body);
  //   //return json.decode(response.body);
  // }

  // Map<String, String> headers = {};
  // void updateCookie(http.Response response) {
  //   var rawCookie = response.headers;
  //   if (rawCookie != null) {
  //     print(rawCookie);
  //     // int index = rawCookie.indexOf(';');
  //     // headers['cookie'] =
  //     //     (index == -1) ? rawCookie : rawCookie.substring(0, index);
  //   }
  // }

  Future<List<FaceBookInstagram>> twitterFiles(
      String id, String urlVideo) async {
    List<FaceBookInstagram> data = [];
    try {
      var respons = await http.post(
          Uri.parse('https://twdown.net/download.php'),
          body: {'URL': urlVideo.split('?').first});
      print(urlVideo);
      var links = parse(respons.body)
          .getElementsByTagName('a')
          .where((element) =>
              element.attributes.containsKey('href') &&
              element.attributes.containsKey('download'))
          .map((e) => e.attributes['href'].toString())
          .toList();
      print(links);
      if (links.isNotEmpty) {
        var img = parse(respons.body)
            .getElementsByClassName('img-thumbnail')
            .where((element) => element.attributes.containsKey('src'))
            .map((e) => e.attributes['src'])
            .first;
        data.add(FaceBookInstagram(
            id: id, name: '', img: img!, url: urlVideo, linksDown: links));
        return data;
      } else {
        return [];
      }
      // var htmlFile = parse(htte.body)
      //     .head
      //     ?.getElementsByTagName('script')
      //     .where(
      //         (element) => element.attributes['type'] == 'application/ld+json')
      //     .first;

      // if (htmlFile != null) {
      //   List<String> lines = htmlFile.text.split('\n');
      //   lines.removeWhere((line) => line.trim().isEmpty);
      //   lines.removeWhere((line) => line.contains('description'));
      //   lines.removeWhere((line) => line.contains('https://t.co'));
      //   var jsonAfterSpilt = lines.join('\n');
      //   print(jsonAfterSpilt);
      //   Map<String, dynamic> jsonFile = json.decode(jsonAfterSpilt);

      //   print(jsonFile['name']);
      //   List img = jsonFile['thumbnailUrl'];
      //   print(img.first);
      //   print(jsonFile['contentUrl']);
      //   data.add(FaceBookInstagram(
      //       id: id.toString(),
      //       name: jsonFile['name'],
      //       img: img.first,
      //       url: urlVideo,
      //       linksDown: [jsonFile['contentUrl']]));
      //   return data;
      // } else {
      //   return [];
      // }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> otherWayInfoYoutube(FileModel fileModel) async {
    try {
      Map jsonVideo = await oherGetDataVideo(fileModel.url);
      if (jsonVideo.containsKey('links')) {
        Map file = jsonVideo['links'][fileModel.fileTitle.split('.').last];
        var ff = file.values
            .where((element) => element['q'] == fileModel.fileQuality)
            .first;
        print(ff);
        var res = await http.post(
            Uri.parse('https://dt86.videodl-server.xyz/api/json/convert'),
            body: {
              'v_id': jsonVideo['vid'],
              'ftype': ff['f'],
              'fquality': ff['q'],
              'fname': jsonVideo['title'],
              'token': jsonVideo['token'],
              'timeExpire': jsonVideo['timeExpires']
            });
        Map responser = json.decode(res.body);
        print(responser['result']);
        if (responser['status'] == 'success') {
          return responser['result'];
        } else {
          return '';
        }
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<List<TiktokData>> getDataVideoOfTikTok(String url) async {
    List<TiktokData> dataTiktok = [];
    try {
      // var responsData =
      //     await http.get(Uri.parse('https://www.tiktok.com/oembed?url=$url'));

      // Map data = json.decode(responsData.body);

      // var urlFile = parse(data['html'])
      //     .body
      //     ?.children
      //     .where((element) => element.localName == 'blockquote')
      //     .map((e) => e.attributes['cite'])
      //     .first;
      var response = await http.post(
          Uri.parse('https://savetik.co/api/ajaxSearch'),
          body: {'q': url, 'ang': 'en'});
      //get id
      var id = parse(response.body)
          .getElementsByTagName('input')
          .where((element) => element.attributes.containsKey('value'))
          .map((e) => e.attributes['value'])
          .first;
      //get image
      var img = parse(response.body)
          .getElementsByTagName('img')
          .where((element) => element.attributes.containsKey('src'))
          .map((e) => e.attributes['src'])
          .first;
      //get title
      var title =
          parse(response.body).getElementsByTagName('h3').first.innerHtml;
      //split symole
      var image = Components().removeSymolInFristLast(img!);
      var idFile = Components().removeSymolInFristLast(id!);
      //get link
      var link = parse(response.body)
          .getElementsByTagName("a")
          .where((element) => element.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      //remov if not have link
      var f = link.where((element) => !element!.contains('http')).first;
      link.remove(f.toString());

      if (link.isNotEmpty) {
        dataTiktok.add(TiktokData(
            id: idFile, name: title, img: image, url: url, linksDown: link));
        return dataTiktok;
      } else {
        return [];
      }
    } catch (e) {}
    return [];
  }

  checkOnLocal(
      {required String fileUrl,
      required String fileLocalRouteStr,
      required int size,
      required List<int> testSize,
      required double listPrograss}) async {
    debugPrint('_checkOnLocal()...');
    //localNotifier.value = '';
    File localFile = File(fileLocalRouteStr);
    String dir = path.dirname(fileLocalRouteStr);
    String basename = path.basenameWithoutExtension(fileLocalRouteStr);
    String extension = path.extension(fileLocalRouteStr);

    String localRouteToSaveFileStr = fileLocalRouteStr;
    testSize.clear();
    //sizes.clear();
    int sumSizes = 0;
    int fileOriginSize = 0;
    bool fullFile = false;
    List<int> sizeFile = [];
    //Response response = await dio.head(fileUrl);
    fileOriginSize = size;
    //int.parse(response.headers.value('content-length')!);
    String localText = 'fileOriginSize: ${filesize(fileOriginSize)}\n\n';
    print(localText);
    bool existsSync = localFile.existsSync();
    if (!existsSync) {
      localText += 'File "$basename$extension" does not exist \nin: "$dir"';
    } else {
      int fileLocalSize = localFile.lengthSync();
      sizeFile.add(fileLocalSize);
      //  testSize[index] = sizeFile;
      //sizes.add(fileLocalSize);
      localText +=
          'localFile: "$basename$extension", fileLocalSize: ${filesize(fileLocalSize)}';
      int i = 1;
      localRouteToSaveFileStr = '$dir/$basename' '_$i$extension';
      File f = File(localRouteToSaveFileStr);
      while (f.existsSync()) {
        int tSize = f.lengthSync();
        sizeFile.add(tSize);
        //  testSize[index] = sizeFile;
        //sizes.add(tSize);
        localText += '\nchunk: "$basename'
            '_$i$extension", fileLocalSize: ${filesize(tSize)}';
        i++;
        localRouteToSaveFileStr = '$dir/$basename' '_$i$extension';
        f = File(localRouteToSaveFileStr);
      }
      // sumSizes = testSize[index]!.fold(0, (p, c) => p + c);
      sumSizes = sizeFile.fold(0, (p, c) => p + c);
      localText +=
          '\n\nsize: ${filesize(sumSizes)}/${filesize(fileOriginSize)}';
      localText += '\nbytes: $sumSizes/$fileOriginSize';
      localText += '\n${(sumSizes / fileOriginSize * 100).toStringAsFixed(2)}%';
      fullFile = sumSizes == fileOriginSize;
    }

    if (existsSync) {
      debugPrint('[ALREADY DOWNLOADED - MERGING FILES]');
      var raf = await localFile.open(mode: FileMode.writeOnlyAppend);
      int i = 1;
      String filePartLocalRouteStr = '$dir/$basename' '_$i$extension';
      File f = File(filePartLocalRouteStr);
      while (f.existsSync()) {
        raf = await raf.writeFrom(await f.readAsBytes());
        await f.delete();

        i++;
        filePartLocalRouteStr = '$dir/$basename' '_$i$extension';
        f = File(filePartLocalRouteStr);
      }
      await raf.close();
    }
    double percent = sumSizes / fileOriginSize;
    // localNotifier.value = localText;
    listPrograss == fullFile
        ? 1
        : percent == 0
            ? null
            : percent;
  }

  void checkDownloadFilesIsWaite(ProviderDownload provider) {
    if (provider.getListItems != null) {
      int? index = provider.getListItems?.fileItems.indexWhere((model) =>
          model.downloading == 'enqueued' || model.downloading == 'failed');
      // print(index);
      // print(
      //     '---------------------------------------------------------------------');
      int convertIntexSearch = int.parse(index.toString());
      if (provider.checkCounteDownload!.countDownload.length < 3 &&
          convertIntexSearch > 0) {
        print(provider.getListItems!.fileItems[convertIntexSearch].fileTitle);

        final model = FileModel(
            id_file:
                provider.getListItems!.fileItems[convertIntexSearch].id_file,
            fileTitle:
                provider.getListItems!.fileItems[convertIntexSearch].fileTitle,
            filePublishDate: provider
                .getListItems!.fileItems[convertIntexSearch].filePublishDate,
            fileID: provider.getListItems!.fileItems[convertIntexSearch].fileID,
            downloading: provider
                .getListItems!.fileItems[convertIntexSearch].downloading,
            progress:
                provider.getListItems!.fileItems[convertIntexSearch].progress,
            typDown:
                provider.getListItems!.fileItems[convertIntexSearch].typDown,
            url: provider.getListItems!.fileItems[convertIntexSearch].url,
            downurl:
                provider.getListItems!.fileItems[convertIntexSearch].downurl,
            pathfile:
                provider.getListItems!.fileItems[convertIntexSearch].pathfile,
            fileQuality: provider
                .getListItems!.fileItems[convertIntexSearch].fileQuality,
            imageFile:
                provider.getListItems!.fileItems[convertIntexSearch].imageFile,
            size: provider.getListItems!.fileItems[convertIntexSearch].size,
            sizeLocal:
                provider.getListItems!.fileItems[convertIntexSearch].sizeLocal,
            txtMassege:
                provider.getListItems!.fileItems[convertIntexSearch].txtMassege,
            type: provider.getListItems!.fileItems[convertIntexSearch].type);
        provider.checkCounteDownload?.countDownload
            .add(provider.getListItems!.fileItems[convertIntexSearch].fileID);
        provider.download(model);
      }
    }
  }
}
