import 'package:download_every_thing/another/download/providerDownload.dart';
import 'package:flutter/material.dart';
import '../classes/components/components.dart';
import '../classes/components/processData.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/TiktokData.dart';
import '../classes/models/fileModel.dart';

class TikTokDownloader {
  ProcessData processData = ProcessData();
  Components _elementeWidget = Components();
  DataAPI _api = DataAPI();
  DateTime dateTime = DateTime.now();
  void buildBottomTiktokDownload(BuildContext context,
      ProviderDownload provider, TiktokData tiktokData) async {
    try {
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
                      title: Text('${tiktokData.id}' +
                          '${tiktokData.name.toString().length > 50 ? tiktokData.name.toString().substring(0, 50) : tiktokData.name.toString()}'),
                      leading: Container(
                          width: 70,
                          height: 100,
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          alignment: Alignment.center,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  _elementeWidget.imageCatch(tiktokData.img))),
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
                            children: tiktokData.linksDown.map((item) {
                              var splitLastSyml =
                                  _elementeWidget.removeSymolInFristLast(item!);

                              int? size;
                              processData
                                  .getTotalSize(splitLastSyml.toString())
                                  .then((value) {
                                if (value != null) {
                                  size = value;
                                }
                              });
                              setState;
                              return StreamBuilder(
                                  stream: Stream.periodic(Duration(seconds: 0))
                                      .asyncMap((i) =>
                                          splitLastSyml), // i is null here (check periodic docs)
                                  builder: (context, snapshot) {
                                    return wrapChiled(splitLastSyml, size,
                                        () async {
                                      await downLoadOneVideo(provider,
                                          tiktokData, splitLastSyml, size);
                                      Navigator.of(context).pop();
                                    });
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

  Widget wrapChiled(String currentStream, int? size, Function() onPress) {
    var siz =
        size == null ? '...' : _elementeWidget.splitSizeFile(size.toString());
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
              Text("Mp4"),
              Text(
                size == null ? '....' : siz + 'MB',
                style: TextStyle(fontSize: 10),
              )
            ],
          )),
    );
  }

  Future<void> downLoadOneVideo(ProviderDownload provider,
      TiktokData tiktokData, String urlDown, int? size1) async {
    //get Size
    var size = size1 == null ? 0 : size1;
    print(size * 1024 * 1024);
//split name
    String name1 = tiktokData.name.length >= 50
        ? tiktokData.name.substring(0, 50) + size.toString()
        : tiktokData.name + size.toString();
    //remove syymole
    var idFile = tiktokData.id + size.toString();
    String name = _elementeWidget.removeSymol(name1) + idFile;
    //make id
    String videoID = provider.getListItems!.fileItems
        .where((item) => item.fileID.toString() == idFile)
        .map((e) => e.fileID.toString())
        .firstWhere((element) => true, orElse: () => '')
        .toString();
    if (videoID.isEmpty) {
      final fileModel = FileModel(
          id_file: '',
          size: size,
          fileTitle: '${name}.mp4',
          filePublishDate: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          fileID: idFile,
          downloading: 'running',
          url: tiktokData.url,
          downurl: urlDown,
          pathfile: '',
          typDown: 'web',
          sizeLocal: 0,
          imageFile: tiktokData.img,
          fileQuality: '',
          txtMassege: 'جاري التوصيل...',
          progress: 0,
          type: 'videos');
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
        provider.downloadFromTiktok(fileModel);
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
      final fileModel = provider.getListItems!.fileItems.firstWhere(
        (item) => item.fileID == idFile,
      );
      fileModel.downurl = urlDown;
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
