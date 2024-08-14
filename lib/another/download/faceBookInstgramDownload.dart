import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import '../classes/components/components.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/fileModel.dart';
import '../classes/components/processData.dart';
import 'providerDownload.dart';

class FaceBookInstgramDownload {
  ProcessData processData = ProcessData();
  Components _elementeWidget = Components();
  DataAPI _api = DataAPI();
  DateTime dateTime = DateTime.now();
  void downloadFaceBookAndInstgram(BuildContext context, VideoData videoData,
      ProviderDownload provider, String urlLink) {
    try {
      String getTitle = videoData.links!.map((e) => e.href).first.toString();
      String title = urlLink.contains('instagram.com')
          ? _elementeWidget.getTitleInstgram(getTitle)
          : _elementeWidget.getBaseUrl(getTitle).split('/').last;
      // print(videoData.thumbnail.toString());
      // print(title.length);
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
                                  .imageCatch(videoData.thumbnail!))),
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
                          children:
                              List.generate(videoData.links!.length, (index) {
                            String size = '';

                            final currentStream = videoData.links![index];
                            processData
                                .getTotalSize(currentStream.href!)
                                .then((value) {
                              //  print(value);
                              size = value.toString();
                              print(size);
                              setState;
                            });
                            setState;
                            return GestureDetector(
                              onTap: () async {
                                print(videoData.links![index].href);
                                await addFileToDownload(videoData, provider,
                                    index, title, urlLink, size);
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
                                      Text(currentStream.text.toString()),
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

  Future<void> addFileToDownload(VideoData videoData, ProviderDownload provider,
      int index, String title, String urlLink, String size) async {
    size.isEmpty
        ? await processData
            .getTotalSize(videoData.links![index].href.toString())
        : size;
    String idVideo = title + "_metaCode" + size.toString();

    String video = provider.getListItems!.fileItems
        .where((item) => item.fileID == idVideo)
        .map((e) => e.fileID)
        .firstWhere((element) => true, orElse: () => '')
        .toString();

    if (video.isEmpty) {
      final model = FileModel(
          id_file: '',
          size: int.parse(size),
          fileTitle: videoData.links![index].text.toString() + title,
          filePublishDate: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          fileID: idVideo,
          downloading: 'running',
          url: urlLink,
          downurl: videoData.links![index].href.toString(),
          pathfile: '',
          typDown: '',
          sizeLocal: 0,
          imageFile: videoData.thumbnail.toString(),
          fileQuality: videoData.links![index].text.toString(),
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
      fileModel.downurl = videoData.links![index].href.toString();
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
}
