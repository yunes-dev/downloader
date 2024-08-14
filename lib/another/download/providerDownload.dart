import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import '../classes/components/components.dart';
import '../classes/components/processData.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/fileModel.dart';
import '../classes/models/search.dart';
import '../notification/notification_utils.dart';

class GetListItems {
  List<FileModel> fileItems;
  GetListItems({required this.fileItems});
}

class CheckCounteDownload {
  List<String> countDownload;
  CheckCounteDownload({required this.countDownload});
}

class ProviderDownload extends ChangeNotifier {
  GetListItems? getListItems;
  GetListItems? get listItems => getListItems;

//to update list item
  void updateItems(GetListItems newItems) {
    getListItems = newItems;

    cancelToken = List<CancelToken>.generate(
      getListItems!.fileItems.length,
      (_) => CancelToken(),
    );

    notifyListeners(); // إشعار الاستماعين بتغيير الحالة;
  }

  CheckCounteDownload? checkCounteDownload;
  CheckCounteDownload? get listCount => checkCounteDownload;
  //to update count
  void updateCountDwonload(CheckCounteDownload newList) {
    checkCounteDownload = newList;
    notifyListeners(); // إشعار الاستماعين بتغيير الحالة
  }

  String fileLocalRouteStr = '';

  Directory? dir;
  List<CancelToken> cancelToken = [];

  ProcessData processData = ProcessData();
  DataAPI api = DataAPI();
  List<Search> itemSearch = [];
  List<String> selected = [];
  Components elementeWidget = Components();

  initializeLocalStorageRoute() async {
    dir = await elementeWidget.getDocumentsDirectory();
    print('*******************************************');
    notifyListeners();
  }

  void addSelect(String task) {
    selected.add(task);
    notifyListeners();
  }

  Future<void> deleteSelect(String task) async {
    selected.remove(task);
    notifyListeners();
  }

  void deleteAllSelect() {
    selected.clear();
    notifyListeners();
  }

  Future<void> deleteData(
      String task, String nameTable, String nameId, String type) async {
    if (type == 'select') {
      api.DeleteData(nameTable, nameId, task);
    } else if (type == 'listfiles') {
      getListItems?.fileItems.removeWhere((element) => element.fileID == task);
      await api.DeleteData(nameTable, nameId, task);
    }
    notifyListeners();
  }

  // void deleteItem(VidoesModle task) {
  //   items.remove(task);
  // }

  void checkDownloadFilesIsWaite() {
    if (getListItems != null) {
      int? index = getListItems?.fileItems
          .indexWhere((model) => model.downloading == 'enqueued');
      if (index != null && index > -1) {
        final fileModel = getListItems?.fileItems[index];
        if (checkCounteDownload!.countDownload.length < 3) {
          print(fileModel!.fileTitle);
          checkCounteDownload?.countDownload.add(fileModel.fileID);
          if (fileModel.url.contains("m.youtube") ||
              fileModel.url.contains("youtube.com") ||
              fileModel.url.contains("youtu.be")) {
            download(fileModel);
          } else {
            getItemFileWithProgress(model: fileModel);
          }
        }
      }
    }
  }

  deleteLocal() {
    dir!.deleteSync(recursive: true);
    notifyListeners();
  }

  Future<int> getIndex(FileModel fileModel) async {
    if (getListItems != null) {
      int? index = getListItems?.fileItems
          .indexWhere((model) => model.fileID == fileModel.fileID);
      return index ?? 0;
    } else {
      return 0;
    }
  }

  updateModelInList(Map<String, dynamic> dataMap, String typeUpdate) async {
    String fileID = dataMap['fileID'];
    String downurl = dataMap['downurl'];
    String txtMassege = dataMap['txtMassege'];
    String downloading = dataMap['downloading'];
    String pathfile = dataMap['pathfile'];
    String progress = dataMap['progress'].toString();
    int sizeLocal = dataMap['sizeLocal'];
    int size = dataMap['size'];
    if (getListItems != null) {
      int? index =
          getListItems?.fileItems.indexWhere((model) => model.fileID == fileID);
      getListItems?.fileItems[index!] = FileModel(
          id_file: getListItems!.fileItems[index].id_file.isEmpty
              ? ''
              : getListItems!.fileItems[index].id_file,
          fileTitle: getListItems!.fileItems[index].fileTitle,
          size: size,
          filePublishDate: getListItems!.fileItems[index].filePublishDate,
          fileID: fileID,
          sizeLocal: sizeLocal,
          downloading: downloading,
          progress: progress.isNotEmpty ? double.parse(progress) : 0.0,
          typDown: getListItems!.fileItems[index].typDown,
          url: getListItems!.fileItems[index].url,
          downurl: downurl,
          pathfile: pathfile,
          fileQuality: getListItems!.fileItems[index].fileQuality,
          imageFile: getListItems!.fileItems[index].imageFile,
          type: getListItems!.fileItems[index].type,
          txtMassege: txtMassege);
      if (typeUpdate == 'update') {
        if (downloading == 'running') {
          // Future.delayed(
          //   Duration(seconds: 2),
          //   () async {
          //     await NotificationUtils().showProgressNotification(
          //         taskId: size,
          //         title: getListItems!.fileItems[index!].fileTitle,
          //         progress: double.parse(progress) * 100);
          //   },
          // );
        } else if (downloading == 'paused' || downloading == 'failed') {
          NotificationUtils.cancelNotification(size);
          NotificationUtils().showStatetNotification(
              taskId: size,
              title: getListItems!.fileItems[index!].fileTitle,
              progress: double.parse(progress) * 100,
              body: 'توقف التحميل');
          await api.UpdateData({
            'fileID': fileID,
            'downloading': downloading,
            'downurl': downurl,
            'pathfile': pathfile,
            'size': size,
            'sizeLocal': sizeLocal,
            'txtMassege': txtMassege,
            'progress': progress,
          }, "fileModel", 'fileID');
        } else if (downloading == 'complete') {
          NotificationUtils.cancelNotification(size);
          NotificationUtils().showStatetNotification(
              taskId: size,
              title: getListItems!.fileItems[index!].fileTitle,
              progress: double.parse(progress) * 100,
              body: "اكتمل التحميل");
          await api.UpdateData({
            'fileID': fileID,
            'downloading': downloading,
            'downurl': downurl,
            'pathfile': pathfile,
            'size': size,
            'sizeLocal': sizeLocal,
            'txtMassege': txtMassege,
            'progress': progress,
          }, "fileModel", 'fileID');
        }
      }
      notifyListeners();
    }
  }

//cancel download file
  cancel(FileModel modle) async {
    int index = await getIndex(modle);
    cancelToken[index].cancel();
    Map<String, dynamic> dataMap = {
      'fileID': getListItems!.fileItems[index].fileID,
      'downurl': getListItems!.fileItems[index].downurl,
      'downloading': 'paused',
      'txtMassege': 'توقف التحميل',
      'size': getListItems!.fileItems[index].size,
      'pathfile': getListItems!.fileItems[index].pathfile,
      'sizeLocal': getListItems!.fileItems[index].sizeLocal,
      'progress': getListItems!.fileItems[index].progress,
    };
    updateModelInList(dataMap, 'update');
    checkCounteDownload?.countDownload.remove(modle.fileID);
    checkDownloadFilesIsWaite();
    print(
        'remove ${modle.fileID} equque------------------------------------------------');
    //notifyListeners();
    processData.checkOnLocal(
        fileUrl: getListItems!.fileItems[index].downurl,
        fileLocalRouteStr: getListItems!.fileItems[index].pathfile,
        size: getListItems!.fileItems[index].size,
        listPrograss: modle.progress,
        testSize: [modle.size]);
    notifyListeners();
  }

  void download(FileModel modle) async {
    try {
      //get info file by YOUTUBEExcuter
      final getInfoVideo = await processData.getInfoOfyoutube(modle.url);
      if (modle.type != 'audio') {
        //get url download by other webSite
        modle.fileTitle = elementeWidget.removeSymol(modle.fileTitle);
        var urlDownloadFromSiteOtherYoutube =
            await processData.otherWayInfoYoutube(modle);
        print(urlDownloadFromSiteOtherYoutube);
        //check is excuter or from website
        fileLocalRouteStr =
            elementeWidget.getLocalApplicationDocumentsFilesRoute(
                "videos", dir!, modle.fileTitle);

        if (urlDownloadFromSiteOtherYoutube.isEmpty ||
            modle.typDown == 'tool') {
          var stream = modle.fileQuality.isNotEmpty
              ? getInfoVideo.videoStreams
                  ?.where((element) => element.resolution == modle.fileQuality)
                  .firstWhere(
                    (element) => true,
                    orElse: () => getInfoVideo.videoWithHighestQuality!,
                  )
              : getInfoVideo.videoWithHighestQuality;
          int? size = await processData.getTotalSize(stream!.url.toString());

          modle.size = size!;
          modle.downurl = stream.url.toString();
          modle.pathfile = fileLocalRouteStr;
          // notifyListeners();
          getItemFileWithProgress(model: modle);
        } else {
          // int? size = await processData
          //     .getTotalSize(urlDownloadFromSiteOtherYoutube.toString());
          modle.downurl = urlDownloadFromSiteOtherYoutube;
          modle.pathfile = fileLocalRouteStr;

          //notifyListeners();
          getItemFileWithProgress(model: modle);
        }
      } else {
        var stream = modle.fileQuality.isNotEmpty
            ? getInfoVideo.audioOnlyStreams
                ?.where((element) =>
                    element.formatName.toString() == modle.fileQuality)
                .firstWhere(
                  (element) => true,
                  orElse: () => getInfoVideo.audioWithBestAacQuality!,
                )
            : getInfoVideo.audioWithBestAacQuality;

        fileLocalRouteStr =
            elementeWidget.getLocalApplicationDocumentsFilesRoute(
                "music", dir!, modle.fileTitle);
        int? size = await processData.getTotalSize(stream!.url.toString());
        // print(stream!.url);
        modle.size = size!;
        modle.downurl = stream.url.toString();
        modle.pathfile = fileLocalRouteStr;
        notifyListeners();
        getItemFileWithProgress(model: modle);
      }
    } catch (e) {
      print('filed to download ---------------------------------');
      cancel(modle);
    }
  }

  downloadFromFaceInsta(FileModel modle) async {
    modle.fileTitle = elementeWidget.removeSymol(modle.fileTitle);
    fileLocalRouteStr = elementeWidget.getLocalApplicationDocumentsFilesRoute(
        "videos", dir!, modle.fileTitle);
    int? size = await processData.getTotalSize(modle.downurl);
    modle.size = size!;
    modle.pathfile = fileLocalRouteStr;
    notifyListeners();
    getItemFileWithProgress(model: modle);
  }

  downloadDirectLinks(FileModel modle) async {
    modle.fileTitle = elementeWidget.removeSymol(modle.fileTitle);
    fileLocalRouteStr = elementeWidget.getLocalApplicationDocumentsFilesRoute(
        modle.type, dir!, modle.fileTitle);
    modle.pathfile = fileLocalRouteStr;
    notifyListeners();
    getItemFileWithProgress(model: modle);
  }

  downloadFromTiktok(FileModel modle) async {
    modle.fileTitle = elementeWidget.removeSymol(modle.fileTitle);
    fileLocalRouteStr = elementeWidget.getLocalApplicationDocumentsFilesRoute(
        "videos", dir!, modle.fileTitle);
    modle.pathfile = fileLocalRouteStr;
    notifyListeners();
    getItemFileWithProgress(model: modle);
  }

  Future<void> getItemFileWithProgress({required FileModel model}) async {
    debugPrint('getItemFileWithProgress()...');
    int index = await getIndex(model);
    File localFile = File(fileLocalRouteStr);
    String dir = path.dirname(fileLocalRouteStr);
    String basename = path.basenameWithoutExtension(fileLocalRouteStr);
    String extension = path.extension(fileLocalRouteStr);
    model.progress = 0.00000;
    //checkCounteDownload?.countDownload.add(model.fileID);
    String localRouteToSaveFileStr = fileLocalRouteStr;
    int fileOriginSize = model.size;
    List<int> sizeFile = [];
    Options? options;

    bool existsSync = localFile.existsSync();
    if (existsSync) {
      int fileLocalSize = localFile.lengthSync();
      sizeFile = [fileLocalSize];

      int i = 1;
      localRouteToSaveFileStr = '$dir/$basename' '_$i$extension';
      File f = File(localRouteToSaveFileStr);
      while (f.existsSync()) {
        sizeFile.add(f.lengthSync());

        i++;
        localRouteToSaveFileStr = '$dir/$basename' '_$i$extension';
        f = File(localRouteToSaveFileStr);
      }
      int sumSizes = sizeFile.fold(0, (p, c) => p + c);

      if (sumSizes < fileOriginSize) {
        options = Options(
          receiveDataWhenStatusError: true,
          headers: {
            'Range': 'bytes=$sumSizes-',
            HttpHeaders.acceptEncodingHeader: '*',
          },
          contentType: Headers.formUrlEncodedContentType,
        );
      } else {
        model.progress = 1;

        debugPrint(
            'percentNotifier [ALREADY DOWNLOADED]: ${(model.progress * 100).toStringAsFixed(2)}');

        if (sizeFile.length == 1) {
          debugPrint('percentNotifier [ALREADY DOWNLOADED - ONE FILE]');
          processData.checkOnLocal(
              fileUrl: model.downurl,
              fileLocalRouteStr: fileLocalRouteStr,
              size: model.size,
              listPrograss: model.progress,
              testSize: sizeFile);
          Map<String, dynamic> dataMap = {
            'fileID': model.fileID,
            'downurl': model.downurl,
            'txtMassege': 'اكتمل التحميل',
            'downloading': 'complete',
            'pathfile': model.pathfile,
            'size': model.size,
            'sizeLocal': model.sizeLocal,
            'progress': '1.0',
          };
          updateModelInList(dataMap, 'update');
        }
        checkCounteDownload?.countDownload.remove(model.fileID);
        print(
            'remove ${model.fileID} equque------------------------------------------------');
        checkDownloadFilesIsWaite();
        notifyListeners();
        // } else {
        //   updateModelInList({

        //   checkDownloadFilesIsWaite();
        // }
      }
    }

    if ((model.progress) < 1) {
      if (cancelToken[index].isCancelled) {
        cancelToken[index] = CancelToken();
      }

      try {
        Dio dio = Dio();
        dio.httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () {
            // Don't trust any certificate just because their root cert is trusted.
            final HttpClient client = HttpClient();
            // You can test the intermediate / root cert here. We just ignore it.
            client.badCertificateCallback = (cert, host, port) => true;
            return client;
          },
          validateCertificate: (cert, host, port) => true,
        );
        await dio.downloadUri(Uri.parse(model.downurl), localRouteToSaveFileStr,
            options: options,
            cancelToken: cancelToken[index],
            deleteOnError: false,
            onReceiveProgress: (int received, int total) async {
          checkDownloadFilesIsWaite();
          if (!cancelToken[index].isCancelled) {
            int sum = sizeFile.fold(0, (p, c) => p + c);
            received += sum;
            int tot = total + sum;
            model.progress = received / tot;
            model.sizeLocal = ((received)).toInt();
            model.size = tot;
            updateModelInList({
              'fileID': model.fileID,
              'downloading': 'running',
              'downurl': model.downurl,
              'pathfile': model.pathfile,
              'size': model.size,
              'sizeLocal': model.sizeLocal,
              'txtMassege': 'جاري التحميل',
              'progress': (model.progress).toString(),
            }, 'update');
          }
        });
        // print(dio.requestOptions.listFormat);
        // print(dio.data);
        // print(dio.extra);
        // print(dio.headers);
        // print(dio.redirects);
        // print(dio.statusMessage);
        // print(dio.requestOptions.data);

        //  checkDownloadFilesIsWaite();
        Map<String, dynamic> dataMap = {
          'fileID': model.fileID,
          'downurl': model.downurl,
          'txtMassege': 'اكتمل التحميل',
          'downloading': 'complete',
          'pathfile': model.pathfile,
          'size': model.size,
          'sizeLocal': model.sizeLocal,
          'progress': '1.0',
        };
        updateModelInList(dataMap, 'update');
        checkCounteDownload?.countDownload.remove(model.fileID);
        print(
            'remove ${model.fileID} equque------------------------------------------------');
        checkDownloadFilesIsWaite();
        notifyListeners();
      } catch (e) {
        debugPrint('..dio.download()...ERROR: "${e.toString()}"');
        String downloading = getListItems?.fileItems[index].downloading ?? "";
        print(downloading);
        String txtMsg = "";
        print("***********************************");
        if (downloading == "paused" || downloading == "running") {
          //checkCounteDownload?.countDownload.remove(model.fileID);
          //checkCounteDownload?.countDownload.remove(model.fileID);
          txtMsg = "توقف التحميل";
          downloading = "paused";
        } else if (downloading == "failed") {
          processData.checkOnLocal(
              fileUrl: model.downurl,
              fileLocalRouteStr: fileLocalRouteStr,
              size: model.size,
              listPrograss: model.progress,
              testSize: sizeFile);
          //  checkDownloadFilesIsWaite();
          //checkCounteDownload?.countDownload.remove(model.fileID);
          downloading = "failed";
          txtMsg = "فشل التحميل اعد المحاولة";
        } else {
          processData.checkOnLocal(
              fileUrl: model.downurl,
              fileLocalRouteStr: fileLocalRouteStr,
              size: model.size,
              listPrograss: model.progress,
              testSize: sizeFile);
          txtMsg = model.txtMassege.isNotEmpty || model.txtMassege != ''
              ? model.txtMassege
              : "فشل التحميل اعد المحاولة";
          downloading = "failed";
        }
        checkCounteDownload?.countDownload.remove(model.fileID);

        print(txtMsg);
        Map<String, dynamic> dataMap = {
          'fileID': model.fileID,
          'downurl': model.downurl,
          'downloading': downloading,
          'pathfile': model.pathfile,
          'size': model.size,
          'sizeLocal': model.sizeLocal,
          'txtMassege': txtMsg,
          'progress': model.progress,
        };
        updateModelInList(dataMap, 'update');
        print(txtMsg + '---------------------------------------------------');
        print(
            'remove ${model.fileID} equque------------------------------------------------');
        checkDownloadFilesIsWaite();
        notifyListeners();

        // notifyListeners();
        return null;
      }
    }
    //notifyListeners();
    processData.checkOnLocal(
      fileUrl: model.downurl,
      fileLocalRouteStr: fileLocalRouteStr,
      size: model.size,
      listPrograss: model.progress,
      testSize: sizeFile,
    );
    //   return localFile;
  }
}
