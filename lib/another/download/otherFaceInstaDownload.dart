import 'package:flutter/material.dart';
import '../classes/components/components.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/faceBookInstagram.dart';
import '../classes/models/fileModel.dart';
import '../classes/components/processData.dart';
import 'providerDownload.dart';

class OtherFaceInstaDownload {
  ProcessData processData = ProcessData();
  Components _elementeWidget = Components();

  void downloadFaceBookAndInstgram(BuildContext context,
      FaceBookInstagram videoData, ProviderDownload provider, String urlLink) {
    try {
      String getTitle = videoData.name.isNotEmpty
          ? videoData.name
          : videoData.linksDown.map((e) => e).first.toString();
      String title1 =
          _elementeWidget.containsNonEnglishLetters(videoData.name) == true
              ? getTitle + ".mp4"
              : urlLink.contains('instagram.com')
                  ? _elementeWidget.getTitleInstgram(getTitle).split('/').last
                  : _elementeWidget.getBaseUrl(getTitle).split('/').last;
      title1 = _elementeWidget.removeSymol(title1);
      String title = title1.length >= 50
          ? title1.substring(0, 50) +
              title1.substring(title1.length - 4, title1.length)
          : title1;
      videoData.name = title;

      print('**********************************************************');
      print(videoData.img.toString());
      print('**********************************************************');
      // String? gg;
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                  height: MediaQuery.of(context).size.height / 1,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0)),
                  child: Column(children: [
                    ListTile(
                      title: Text(title),
                      leading: Container(
                          width: 70,
                          height: 100,
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          alignment: Alignment.center,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _elementeWidget
                                  .imageCatch(videoData.img.toString()))),
                    ),
                    SizedBox(
                      height: 50,
                    ),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: List.generate(videoData.linksDown.length,
                              (index) {
                            String size = '';

                            final currentStream = videoData.linksDown[index];
                            processData
                                .getTotalSize(currentStream.toString())
                                .then((value) {
                              //  print(value);
                              size = value.toString();
                              //  print(size);
                              setState;
                            });
                            setState;
                            return GestureDetector(
                              onTap: () async {
                                print(videoData.linksDown[index]);
                                print(videoData.name.length);
                                StartDownload().addFileToDownload(
                                    videoData, provider, index, urlLink, size);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                      border: Border.all(
                                          color: Colors.black, width: 2.0)),
                                  child: Column(
                                    children: [
                                      Text('MP4'),
                                      StreamBuilder(
                                          stream: Stream.periodic(
                                                  Duration(seconds: 0))
                                              .asyncMap((i) =>
                                                  size), // i is null here (check periodic docs)
                                          builder: (context, snapshot) {
                                            return Text(
                                              '${size.isEmpty ? '' : _elementeWidget.splitSizeFile(size) + 'MB'}',
                                              style: TextStyle(fontSize: 10),
                                            );
                                          })
                                    ],
                                  )),
                            );
                          })),
                    )),
                  ]));
            });
          });
    } catch (e) {
      print('error');
    }
  }
}

class StartDownload {
  ProcessData processData = ProcessData();
  Components _elementeWidget = Components();
  DataAPI _api = DataAPI();
  DateTime dateTime = DateTime.now();
  Future<void> addFileToDownload(FaceBookInstagram videoData,
      ProviderDownload provider, int index, String urlLink, String size) async {
    size.isEmpty
        ? await processData.getTotalSize(videoData.linksDown[index].toString())
        : size;
    String title = videoData.name;
    String idVideo = title + "_metaCode" + size.toString();
    print(videoData.img);
    String video = provider.getListItems!.fileItems
        .where((item) => item.fileID.toString() == idVideo)
        .map((e) => e.fileID.toString())
        .firstWhere((element) => true, orElse: () => '')
        .toString();

    if (video.isEmpty) {
      final model = FileModel(
          id_file: '',
          size: size.isEmpty ? 0 : int.parse(size),
          fileTitle: title,
          filePublishDate: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          fileID: idVideo,
          downloading: 'running',
          url: urlLink,
          downurl: videoData.linksDown[index].toString(),
          pathfile: '',
          typDown: '',
          sizeLocal: 0,
          imageFile: videoData.img.toString(),
          fileQuality: videoData.linksDown[index].toString(),
          type: 'videos',
          txtMassege: 'جاري التوصيل...',
          progress: 0);
      provider.getListItems?.fileItems.add(model);

      provider.updateItems(
          GetListItems(fileItems: provider.getListItems!.fileItems));
      if (provider.checkCounteDownload!.countDownload.length > 3) {
        await _api.addData({
          'fileTitle': title,
          'filePublishDate':
              '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          'fileID': idVideo,
          'downloading': 'enqueued',
          'progress': '0',
          'url': urlLink,
          'typDown': '',
          'imageFile': model.imageFile,
          'size': model.size,
          'sizeLocal': model.sizeLocal,
          'pathfile': '',
          'downurl': model.downurl,
          'type': 'videos',
          'txtMassege': ' قيد الأنتظار',
          'fileQuality': model.fileQuality
        }, 'fileModel');
      } else {
        provider.checkCounteDownload!.countDownload.add(model.fileID);
        provider.updateCountDwonload(CheckCounteDownload(
            countDownload: provider.checkCounteDownload!.countDownload));
        provider.downloadFromFaceInsta(model);
        await _api.addData({
          'fileTitle': title,
          'filePublishDate':
              '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          'fileID': idVideo,
          'downloading': 'enqueued',
          'progress': '0',
          'typDown': '',
          'url': urlLink,
          'imageFile': model.imageFile,
          'size': model.size,
          'sizeLocal': model.sizeLocal,
          'pathfile': '',
          'downurl': model.downurl,
          'type': 'videos',
          'txtMassege': 'جاري التوصيل...',
          'fileQuality': model.fileQuality,
        }, 'fileModel');
      }
    } else {
      final fileModel = provider.getListItems!.fileItems.firstWhere(
        (item) => item.fileID == idVideo,
      );
      fileModel.downurl = videoData.linksDown[index].toString();
      if (fileModel.downloading == 'complete') {
        _elementeWidget.toast('هذا الملف موجود من قبل');
      } else {
        provider.updateModelInList({
          'fileID': fileModel.fileID.toString(),
          'downurl': fileModel.downurl,
          'txtMassege': 'تم تحديث الرابط',
          'downloading': fileModel.downloading,
          'pathfile': fileModel.pathfile,
          'size': fileModel.size,
          'sizeLocal': fileModel.sizeLocal,
          'progress': fileModel.progress.toString(),
        }, 'updateWithOutNoti');
        _elementeWidget.toast('تم تجديد رابط الملف');
      }
    }
  }
}
