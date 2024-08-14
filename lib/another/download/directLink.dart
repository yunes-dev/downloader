import 'package:download_every_thing/another/download/providerDownload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../classes/components/components.dart';
import '../classes/components/processData.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/fileModel.dart';

class DirectLink {
  ProcessData processData = ProcessData();
  Components _elementeWidget = Components();
  DataAPI _api = DataAPI();
  DateTime dateTime = DateTime.now();

  Future<void> dialogBuildDown(BuildContext context, String url,
      DownloadStartRequest respons, ProviderDownload provider) async {
    int? size = respons.contentLength;
    //int.parse(respons.headers.value('content-length')!);
    // String content = respons.headers['content-type']![0].toString();
    //if (!_elementeWidget.contentTypes.toString().contains(content)) {
    var filename = respons.suggestedFilename;
    //respons.headers.map.containsKey('content-disposition')
    //  ? respons.headers['content-disposition']![0]
    // : '';

    // print(filename);
    // print('******************************************');
    // print(content.split('/').last);
    // var tryGetName = filename.isNotEmpty || filename != ''
    //     ? _elementeWidget
    //         .removeSymol(filename.toString().split('filename=').last)
    //     : content.split('/').last;

    // String name = "${url.split('/').last} ${size.toString()}.${tryGetName}";
    //String totleSize = _elementeWidget.splitSizeFile(size.toString());
    addItemToDownload(url, respons, provider, filename!, size);
    // return showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: SingleChildScrollView(
    //           child: ListBody(
    //             children: <Widget>[
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.end,
    //                 children: [
    //                   Container(
    //                     child: Text(
    //                       'name: $filename',
    //                       textAlign: TextAlign.left,
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 10,
    //                   ),
    //                   Container(
    //                       child: Text(
    //                     'size: $totleSize',
    //                     textAlign: TextAlign.left,
    //                   ))
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         actions: <Widget>[
    //           Center(
    //             child: Container(
    //                 child: ElevatedButton(
    //                     onPressed: () async {
    //                       addItemToDownload(
    //                           url, respons, provider, filename!, size);
    //                       Navigator.of(context).pop();
    //                     },
    //                     child: Text("تحميل"))),
    //           )
    //         ],
    //       );
    //     });
  }

  void addItemToDownload(String url, DownloadStartRequest respons,
      ProviderDownload provider, String name, int size) {
    String idFile = name;
    var date = DateTime.now().toString();
    print(size);
    var typeFile = respons.mimeType!.contains('mp4')
        ? "videos"
        : respons.mimeType!.contains('mp3')
            ? "music"
            : 'files';
    FileModel fileModel = FileModel(
        id_file: '',
        fileTitle: name,
        filePublishDate: date,
        fileID: idFile,
        downloading: 'notStart',
        progress: 0.0,
        typDown: '',
        url: url,
        downurl: respons.url.toString(),
        pathfile: '',
        fileQuality: '',
        size: size,
        type: typeFile,
        sizeLocal: 0,
        imageFile: '',
        txtMassege: 'قيد الانتظار');
    print('this is not page web');
    print(fileModel.fileTitle);

    String item = provider.getListItems!.fileItems
        .where((item) => item.fileID == fileModel.fileID)
        .map((e) => e.fileID)
        .firstWhere((element) => true, orElse: () => '')
        .toString();
    //
    if (item.isEmpty) {
      provider.getListItems?.fileItems.add(fileModel);
      provider.updateItems(
          GetListItems(fileItems: provider.getListItems!.fileItems));
      String downloading = '';
      String txtMassege = '';
      //check count
      if (provider.checkCounteDownload!.countDownload.length > 3) {
        downloading = 'enqueued';
        txtMassege = ' قيد الأنتظار';
      } else {
        provider.checkCounteDownload!.countDownload.add(fileModel.fileID);
        provider.updateCountDwonload(CheckCounteDownload(
            countDownload: provider.checkCounteDownload!.countDownload));
        provider.downloadDirectLinks(fileModel);
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
        'typDown': '',
        'sizeLocal': fileModel.sizeLocal,
        'url': fileModel.url,
        'txtMassege': txtMassege,
        'pathfile': fileModel.pathfile,
        'downurl': fileModel.downurl,
        'imageFile': fileModel.imageFile,
        'fileQuality': '',
        'type': fileModel.type,
      };
      _api.addData(dataMap, 'fileModel');
    } else {
      final fileModel = provider.getListItems!.fileItems.firstWhere(
        (item) => item.fileID == idFile,
      );
      fileModel.downurl = respons.url.toString();
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
