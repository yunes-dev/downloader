// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newpipeextractor_dart/models/streams/audioOnlyStream.dart';
import 'package:newpipeextractor_dart/models/streams/videoStream.dart';
import 'package:newpipeextractor_dart/models/video.dart';
import 'package:newpipeextractor_dart/models/videoInfo.dart';
import '../classes/components/components.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/fileModel.dart';
import '../classes/components/processData.dart';
import 'providerDownload.dart';

class YoutubeDownload {
  ProcessData processData = ProcessData();
  Components _elementeWidget = Components();
  DataAPI _api = DataAPI();
  DateTime dateTime = DateTime.now();
  void buildBottomYoutubeDownload(BuildContext context,
      ProviderDownload provider, YoutubeVideo getInfoFile) async {
    try {
      final audioStream = getInfoFile.audioOnlyStreams;
      var stream = getInfoFile.videoStreams;
      var infoFile = getInfoFile.videoInfo;
      // final size =
      //     20; //await processData.getTotalSize(infoFile.url.toString());
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height / 1,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0)),
                  child: Column(children: [
                    ListTile(
                      title: Text(infoFile.name.toString().length > 50
                          ? infoFile.name.toString().substring(0, 50)
                          : infoFile.name.toString()),
                      leading: Container(
                          width: 70,
                          height: 100,
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://i.ytimg.com/vi/${infoFile.id}/hqdefault.jpg',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(), // عنصر بديل أثناء تحميل الصورة
                              errorWidget: (context, url, error) => Image.asset(
                                  'assets/images/logo.png'), // صورة بديلة في حالة حدوث خطأ
                            ),
                          )),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(500),
                              bottomLeft: Radius.circular(500),
                              bottomRight: Radius.circular(0)),
                          gradient: _elementeWidget.gradient),
                      child: Text(
                        "موسيقى",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: List.generate(audioStream!.length, (index) {
                            final currentStream = audioStream[index];

                            processData
                                .getTotalSize(audioStream[index].url.toString())
                                .then((value) => currentStream.size = value);
                            setState;
                            //     print(currentStream.size.toString());
                            return StreamBuilder(
                                stream: Stream.periodic(Duration(seconds: 0))
                                    .asyncMap((i) =>
                                        currentStream), // i is null here (check periodic docs)
                                builder: (context, snapshot) {
                                  return wrapChiledMusic(currentStream, () {
                                    downLoadOneMusic(infoFile, provider,
                                        currentStream, index);
                                    Navigator.of(context).pop();
                                  });
                                });
                          })),
                    )),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(500),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(500)),
                          gradient: _elementeWidget.gradient),
                      child: Text(
                        "فيديو",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: List.generate(stream!.length, (index) {
                                final currentStream = stream[index];
                                processData
                                    .getTotalSize(stream[index].url.toString())
                                    .then(
                                        (value) => currentStream.size = value);
                                setState;
                                if (index > 0 &&
                                    currentStream.resolution ==
                                        stream[index - 1].resolution) {
                                  return SizedBox
                                      .shrink(); // Skip repeated resolutions
                                }
                                return StreamBuilder(
                                    stream: Stream.periodic(
                                            Duration(seconds: 0))
                                        .asyncMap((i) =>
                                            currentStream), // i is null here (check periodic docs)
                                    builder: (context, snapshot) {
                                      return wrapChiledVidoe(currentStream, () {
                                        downLoadOneVideo(
                                            infoFile, provider, stream, index);
                                        Navigator.of(context).pop();
                                      });
                                    });
                              })),
                        ],
                      ),
                    )),
                  ]));
            });
          });
    } catch (e) {
      print('error');
    }
  }

  Widget wrapChiledVidoe(VideoStream currentStream, Function() onPress) {
    String readySize = currentStream.size == null
        ? ''
        : _elementeWidget.splitSizeFile(currentStream.size.toString());
    return GestureDetector(
      onTap: onPress,
      child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              border: Border.all(color: Colors.black, width: 2.0)),
          child: Column(
            children: [
              Text(currentStream.resolution.toString()),
              readySize.isEmpty
                  ? CircularProgressIndicator(
                      strokeWidth: 2.2,
                    )
                  : Text(
                      readySize + 'MB',
                      style: TextStyle(fontSize: 10),
                    )
            ],
          )),
    );
  }

  Widget wrapChiledMusic(AudioOnlyStream currentStream, Function() onPress) {
    String readySize = currentStream.size == null
        ? ''
        : _elementeWidget.splitSizeFile(currentStream.size.toString());
    return GestureDetector(
      onTap: onPress,
      child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              border: Border.all(color: Colors.black, width: 2.0)),
          child: Column(
            children: [
              Text(currentStream.formatName.toString()),
              readySize.isEmpty
                  ? CircularProgressIndicator(
                      strokeWidth: 2.2,
                    )
                  : Text(
                      readySize + 'MB',
                      style: TextStyle(fontSize: 10),
                    )
            ],
          )),
    );
  }

  downLoadOneVideo(VideoInfo infoFile, ProviderDownload provider,
      List<VideoStream> stream, int index) async {
    String idVideo = infoFile.id.toString() +
        "_metaCode" +
        stream[index].resolution.toString() +
        stream[index].formatName.toString();
    String nameVideo = infoFile.name!.contains('/')
        ? infoFile.name!.split('/').first.toString() +
            infoFile.name!.split('/').last.toString()
        : infoFile.name.toString();

    String videoID = provider.getListItems!.fileItems
        .where((item) => item.fileID.toString() == idVideo)
        .map((e) => e.fileID.toString())
        .firstWhere((element) => true, orElse: () => '')
        .toString();
    if (videoID.isEmpty) {
      final model = FileModel(
          id_file: '',
          size: stream[index].size!,
          fileTitle:
              '${nameVideo + stream[index].resolution.toString() + stream[index].formatName.toString()}.${stream[index].formatSuffix.toString()}',
          filePublishDate: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          fileID: idVideo,
          downloading: 'running',
          url: infoFile.url.toString(),
          downurl: stream[index].url.toString(),
          pathfile: '',
          typDown: 'tool',
          sizeLocal: 0,
          imageFile:
              "https://i.ytimg.com/vi/${infoFile.id.toString()}/hqdefault.jpg",
          fileQuality: stream[index].resolution.toString(),
          txtMassege: 'جاري التوصيل...',
          progress: 0,
          type: 'videos');
      provider.getListItems?.fileItems.add(model);
      provider.updateItems(
          GetListItems(fileItems: provider.getListItems!.fileItems));
      if (provider.checkCounteDownload!.countDownload.length > 3) {
        await _api.addData({
          'fileTitle':
              '${nameVideo + stream[index].resolution.toString() + stream[index].formatName.toString()}.${stream[index].formatSuffix.toString()}',
          'filePublishDate':
              '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          'fileID': idVideo,
          'downloading': 'enqueued',
          'progress': '0',
          'url': infoFile.url.toString(),
          'imageFile': "https://i.ytimg.com/vi/${infoFile.id}/hqdefault.jpg",
          'size': model.size,
          'sizeLocal': model.sizeLocal,
          'typDown': model.typDown,
          'pathfile': '',
          'downurl': stream[index].url.toString(),
          'txtMassege': ' قيد الأنتظار',
          'fileQuality': stream[index].resolution.toString(),
          'type': model.type
        }, 'fileModel');
      } else {
        provider.checkCounteDownload!.countDownload.add(model.fileID);
        provider.updateCountDwonload(CheckCounteDownload(
            countDownload: provider.checkCounteDownload!.countDownload));
        provider.download(model);
        await _api.addData({
          'fileTitle':
              '${nameVideo + stream[index].resolution.toString() + stream[index].formatName.toString()}.${stream[index].formatSuffix.toString()}',
          'filePublishDate':
              '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          'fileID': idVideo,
          'downloading': 'enqueued',
          'progress': '0',
          'url': infoFile.url.toString(),
          'imageFile': "https://i.ytimg.com/vi/${infoFile.id}/hqdefault.jpg",
          'size': model.size,
          'typDown': model.typDown,
          'sizeLocal': model.sizeLocal,
          'pathfile': '',
          'downurl': stream[index].url.toString(),
          'txtMassege': 'جاري التوصيل...',
          'fileQuality': stream[index].resolution.toString(),
          'type': model.type
        }, 'fileModel');
      }
    } else {
      final fileModel = provider.getListItems!.fileItems.firstWhere(
        (item) => item.fileID == idVideo,
      );
      fileModel.downurl = stream[index].url.toString();
      if (fileModel.downloading == 'complete') {
        _elementeWidget.toast('هذا الملف موجود من قبل');
      } else {
        provider.updateModelInList({
          'fileID': fileModel.fileID,
          'downurl': fileModel.downurl,
          'txtMassege': 'تم تحديث الرابط',
          'downloading': fileModel.downloading,
          'pathfile': fileModel.pathfile,
          'size': fileModel.size.toString(),
          'sizeLocal': fileModel.sizeLocal,
          'progress': fileModel.progress.toString(),
        }, 'updateWithOutNoti');
        _elementeWidget.toast('تم تجديد رابط الملف');
      }
    }
  }

  downLoadOneMusic(VideoInfo infoFile, ProviderDownload provider,
      AudioOnlyStream stream, int index) async {
    String idVideo =
        infoFile.id.toString() + "_metaCode" + stream.formatName.toString();
    String nameVideo = infoFile.name!.contains('/')
        ? infoFile.name!.split('/').first.toString() +
            infoFile.name!.split('/').last.toString()
        : infoFile.name.toString();
    String videoID = provider.getListItems!.fileItems
        .where((item) => item.fileID.toString() == idVideo)
        .map((e) => e.fileID.toString())
        .firstWhere((element) => true, orElse: () => '')
        .toString();
    if (videoID.isNotEmpty) {
      final fileModel = provider.getListItems!.fileItems.firstWhere(
        (item) => item.fileID == idVideo,
      );
      fileModel.downurl = stream.url.toString();
      if (fileModel.downloading == 'complete') {
        _elementeWidget.toast('هذا الملف موجود من قبل');
      } else {
        provider.updateModelInList({
          'fileID': fileModel.fileID,
          'downurl': fileModel.downurl,
          'txtMassege': 'تم تحديث الرابط',
          'downloading': fileModel.downloading,
          'pathfile': fileModel.pathfile,
          'size': fileModel.size.toString(),
          'sizeLocal': fileModel.sizeLocal,
          'progress': fileModel.progress.toString(),
        }, 'updateWithOutNoti');
        _elementeWidget.toast('تم تجديد رابط الملف');
      }
    } else {
      final model = FileModel(
          id_file: '',
          size: stream.size!,
          fileTitle:
              '${nameVideo + stream.formatName.toString()}.${stream.formatSuffix.toString()}',
          filePublishDate: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          fileID: idVideo,
          downloading: 'running',
          url: infoFile.url.toString(),
          downurl: stream.url.toString(),
          pathfile: '',
          typDown: 'tool',
          sizeLocal: 0,
          imageFile: "https://meta-code-ye.com/images/music.png",
          fileQuality: stream.formatName.toString(),
          txtMassege: 'جاري التوصيل...',
          type: 'audio',
          progress: 0);
      provider.getListItems?.fileItems.add(model);
      provider.updateItems(
          GetListItems(fileItems: provider.getListItems!.fileItems));
      String txtMassege = '';
      String downloading = '';
      if (provider.checkCounteDownload!.countDownload.length > 3) {
        downloading = 'enqueued';
        txtMassege = ' قيد الأنتظار';
      } else {
        downloading = 'enqueued';
        txtMassege = 'جاري التوصيل...';
        provider.checkCounteDownload!.countDownload.add(model.fileID);
        provider.updateCountDwonload(CheckCounteDownload(
            countDownload: provider.checkCounteDownload!.countDownload));
        provider.download(model);
      }
      await _api.addData({
        'fileTitle':
            '${nameVideo + stream.formatName.toString()}.${stream.formatSuffix.toString()}',
        'filePublishDate': '${dateTime.year}-${dateTime.month}-${dateTime.day}',
        'fileID': idVideo,
        'downloading': downloading,
        'progress': '0',
        'url': infoFile.url.toString(),
        'imageFile': model.imageFile,
        'size': model.size,
        'typDown': model.typDown,
        'sizeLocal': model.sizeLocal,
        'pathfile': '',
        'downurl': stream.url.toString(),
        'txtMassege': txtMassege,
        'fileQuality': stream.formatName.toString(),
        'type': model.type,
      }, 'fileModel');
      //  print('----------------------------------------------------------33');
    }
  }
}
