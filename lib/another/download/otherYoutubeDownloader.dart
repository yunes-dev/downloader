import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../classes/components/components.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/fileModel.dart';
import '../classes/components/processData.dart';
import 'providerDownload.dart';

class OtherYoutubeDownloader {
  ProcessData processData = ProcessData();
  Components _elementeWidget = Components();
  DataAPI _api = DataAPI();
  DateTime dateTime = DateTime.now();
  void buildBottomYoutubeDownload(BuildContext context,
      ProviderDownload provider, Map videoDetalis, String url) async {
    try {
      Map infoVideo = videoDetalis['links']['mp4'];
      print(infoVideo);
      Map infoAudio = Map();
      infoAudio.addAll(videoDetalis['links']['mp3']);
      infoAudio.addAll(videoDetalis['links']['ogg']);
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
                      title: Text(videoDetalis['title'].toString().length > 50
                          ? videoDetalis['title'].toString().substring(0, 50)
                          : videoDetalis['title'].toString()),
                      leading: Container(
                          width: 70,
                          height: 100,
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://i.ytimg.com/vi/${videoDetalis['vid']}/hqdefault.jpg',
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
                          gradient: _elementeWidget.gradient,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(500),
                              bottomLeft: Radius.circular(500),
                              bottomRight: Radius.circular(0))),
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
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: infoAudio.entries.map((entry) {
                              return wrapChiled(entry.value, () {
                                downLoadOneVideo(
                                    entry.value, provider, videoDetalis, url);
                                Navigator.of(context).pop();
                              });
                            }).toList(), // Convert the iterable to a list
                          ),
                        ],
                      ),
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
                            children: infoVideo.entries.map((entry) {
                              return wrapChiled(entry.value, () {
                                downLoadOneVideo(
                                    entry.value, provider, videoDetalis, url);
                                Navigator.of(context).pop();
                              });
                            }).toList(), // Convert the iterable to a list
                          ),
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

  Widget wrapChiled(Map currentStream, Function() onPress) {
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
              Text(currentStream['q'].toString()),
              Text(
                currentStream['size'],
                style: TextStyle(fontSize: 10),
              )
            ],
          )),
    );
  }

  downLoadOneVideo(
    Map videoinfo,
    ProviderDownload provider,
    Map allDataVideo,
    String url,
  ) async {
    String idVideo = allDataVideo['vid'].toString() +
        "_metaCode" +
        videoinfo['q'].toString();
    String nameVideo = allDataVideo['title'].toString().contains('/')
        ? allDataVideo['title'].toString().split('/').first.toString() +
            allDataVideo['title'].toString().split('/').last.toString()
        : allDataVideo['title'].toString().toString();
    print(double.parse(videoinfo['size'].toString().split('MB').first));
    int size = (double.parse(videoinfo['size'].toString().split('MB').first) *
            1024 *
            1024)
        .toInt();
    print('------------------------------------------');
    await _api.GetAllData("select * from fileModel where fileID='${idVideo}'")
        .then((value) async {
      if (value.isEmpty) {
        final fileModel = FileModel(
            id_file: '',
            size: size,
            fileTitle:
                '${nameVideo + videoinfo['q'].toString()}.${videoinfo['f'].toString()}',
            filePublishDate:
                '${dateTime.year}-${dateTime.month}-${dateTime.day}',
            fileID: idVideo,
            downloading: 'running',
            url: url,
            downurl: '',
            pathfile: '',
            typDown: 'web',
            sizeLocal: 0,
            imageFile:
                "https://i.ytimg.com/vi/${allDataVideo['vid'].toString()}/hqdefault.jpg",
            fileQuality: videoinfo['q'].toString(),
            txtMassege: 'جاري التوصيل...',
            progress: 0,
            type: videoinfo['f'].toString() == 'mp4' ? 'videos' : 'audio');
        await processData.otherWayInfoYoutube(fileModel);
        provider.getListItems?.fileItems.add(fileModel);
        provider.updateItems(
            GetListItems(fileItems: provider.getListItems!.fileItems));
        String downloading = '';
        String txtMassege = '';
        if (provider.checkCounteDownload!.countDownload.length > 3) {
          downloading = 'enqueued';
          txtMassege = ' قيد الأنتظار';

          print('-----------------------');
        } else {
          provider.checkCounteDownload!.countDownload.add(fileModel.fileID);
          provider.updateCountDwonload(CheckCounteDownload(
              countDownload: provider.checkCounteDownload!.countDownload));
          provider.download(fileModel);
          downloading = 'notStrat';
          txtMassege = '...جاري التوصيل';
        }
        Map<String, dynamic> dataMap = {
          'fileTitle': fileModel.fileTitle,
          'filePublishDate': fileModel.filePublishDate,
          'fileID': fileModel.fileID,
          'downloading': downloading,
          'progress': '0.0',
          'size': fileModel.size,
          'typDown': fileModel.typDown,
          'sizeLocal': fileModel.sizeLocal,
          'url': fileModel.url,
          'txtMassege': txtMassege,
          'pathfile': fileModel.pathfile,
          'downurl': fileModel.downurl,
          'imageFile': fileModel.imageFile,
          'fileQuality': fileModel.fileQuality,
          'type': fileModel.type,
        };
        await _api.addData(dataMap, 'fileModel');
      } else {
        _elementeWidget.toast('هذا الملف موجود من قبل');
      }
    });
  }
}
