// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:download_every_thing/another/download/providerDownload.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hls_parser/flutter_hls_parser.dart';
// import '../classes/components/components.dart';
// import '../classes/components/processData.dart';
// import '../classes/databaseAndAPI/dataApi.dart';
// import '../classes/models/TiktokData.dart';
// import '../classes/models/fileModel.dart';
// import 'package:http/http.dart' as http;

// class TestLinksVideos {
//   ProcessData processData = ProcessData();
//   Components _elementeWidget = Components();
//   DataAPI _api = DataAPI();
//   DateTime dateTime = DateTime.now();
//   void buildBottomTestDownload(
//       BuildContext context, ProviderDownload provider, List testList) async {
//     try {
//       showModalBottomSheet(
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setState) {
//               return Container(
//                   height: MediaQuery.of(context).size.height / 1,
//                   padding: const EdgeInsets.all(5.0),
//                   decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 2.0)),
//                   child: Column(children: [
//                     ListTile(
//                       title: Text('.....'),
//                       leading: Container(
//                           width: 70,
//                           height: 100,
//                           padding: EdgeInsets.symmetric(vertical: 0.0),
//                           alignment: Alignment.center,
//                           child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: _elementeWidget.imageCatch(
//                                   "https://meta-code-ye.com/images/logo.png"))),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(500),
//                               topRight: Radius.circular(0),
//                               bottomLeft: Radius.circular(0),
//                               bottomRight: Radius.circular(500)),
//                           gradient: _elementeWidget.gradient),
//                       child: const Text(
//                         "فيديو",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                         child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Wrap(
//                             spacing: 8.0,
//                             runSpacing: 8.0,
//                             children: testList.map((item) {
//                               var splitLastSyml =
//                                   _elementeWidget.removeSymolInFristLast(item!);

//                               int? size;
//                               processData
//                                   .getTotalSize(splitLastSyml.toString())
//                                   .then((value) {
//                                 if (value != null) {
//                                   size = value;
//                                 }
//                               });
//                               setState;
//                               return StreamBuilder(
//                                   stream: Stream.periodic(Duration(seconds: 0))
//                                       .asyncMap((i) =>
//                                           splitLastSyml), // i is null here (check periodic docs)
//                                   builder: (context, snapshot) {
//                                     return wrapChiled(splitLastSyml, size,
//                                         () async {
//                                       final req =
//                                           await http.get(Uri.parse(item));
//                                       //log("${req.statusCode}");
//                                       log("${req.body}");
//                                       log("${req.request?.headers}");
//                                       final lines = req.body;
//                                       //final lines = req.body;
//                                       print(item);
//                                       try {
//                                         var playList =
//                                             await HlsPlaylistParser.create()
//                                                 .parseString(
//                                                     Uri.parse(item), lines);
//                                         playList as HlsMediaPlaylist;
//                                         int i = 0;
//                                         print(playList.segments.first.url);
//                                         playList.segments.forEach((element) {
//                                           i += 1;
//                                           Dio dio = Dio();
//                                           dio.download(
//                                             element.url.toString(),
//                                             "${provider.dir?.path}/${element.url}_$i.ts",
//                                             onReceiveProgress: (count, total) {
//                                               print(count / total);
//                                             },
//                                           );
//                                           print(element.url);
//                                         });
//                                       } catch (error) {
//                                         log("HlsPlaylistParser Error:P $error");
//                                       }
//                                     });
//                                   });
//                             }).toList(), // Convert the iterable to a list
//                           ),
//                         ],
//                       ),
//                     )),
//                   ]));
//             });
//           });
//     } catch (e) {
//       print('error');
//     }
//   }

//   Widget wrapChiled(String currentStream, int? size, Function() onPress) {
//     var siz =
//         size == null ? '...' : _elementeWidget.splitSizeFile(size.toString());
//     return GestureDetector(
//       onTap: onPress,
//       child: Container(
//           padding: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(5),
//                   topRight: Radius.circular(5),
//                   bottomLeft: Radius.circular(5),
//                   bottomRight: Radius.circular(5)),
//               border: Border.all(color: Colors.black, width: 2.0)),
//           child: Column(
//             children: [
//               Text("Mp4"),
//               Text(
//                 size == null ? '....' : siz + 'MB',
//                 style: TextStyle(fontSize: 10),
//               )
//             ],
//           )),
//     );
//   }

//   Future<void> downLoadOneVideo(ProviderDownload provider,
//       TiktokData tiktokData, String urlDown, int? size1) async {
//     //get Size
//     var size = size1 == null ? 0 : size1;
//     print(size * 1024 * 1024);
// //split name
//     String name1 = tiktokData.name.length >= 50
//         ? tiktokData.name.substring(0, 50) + size.toString()
//         : tiktokData.name + size.toString();
//     //remove syymole
//     var idFile = tiktokData.id + size.toString();
//     String name = _elementeWidget.removeSymol(name1) + idFile;
//     //make id
//     String videoID = provider.getListItems!.fileItems
//         .where((item) => item.fileID.toString() == idFile)
//         .map((e) => e.fileID.toString())
//         .firstWhere((element) => true, orElse: () => '')
//         .toString();
//     if (videoID.isEmpty) {
//       final fileModel = FileModel(
//           id_file: '',
//           size: size,
//           fileTitle: '${name}.mp4',
//           filePublishDate: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
//           fileID: idFile,
//           downloading: 'running',
//           url: tiktokData.url,
//           downurl: urlDown,
//           pathfile: '',
//           typDown: 'web',
//           sizeLocal: 0,
//           imageFile: tiktokData.img,
//           fileQuality: '',
//           txtMassege: 'جاري التوصيل...',
//           progress: 0,
//           type: 'videos');
//       provider.getListItems?.fileItems.add(fileModel);
//       provider.updateItems(
//           GetListItems(fileItems: provider.getListItems!.fileItems));
//       String downloading = '';
//       String txtMassege = '';
//       if (provider.checkCounteDownload!.countDownload.length > 3) {
//         downloading = 'enqueued';
//         txtMassege = ' قيد الأنتظار';

//         print('-----------------------');
//       } else {
//         provider.checkCounteDownload!.countDownload.add(fileModel.fileID);
//         provider.updateCountDwonload(CheckCounteDownload(
//             countDownload: provider.checkCounteDownload!.countDownload));
//         provider.downloadFromTiktok(fileModel);
//         downloading = 'notStrat';
//         txtMassege = '...جاري التوصيل';
//       }
//       Map<String, dynamic> dataMap = {
//         'fileTitle': fileModel.fileTitle,
//         'filePublishDate': fileModel.filePublishDate,
//         'fileID': fileModel.fileID,
//         'downloading': downloading,
//         'progress': '0.0',
//         'size': fileModel.size,
//         'typDown': fileModel.typDown,
//         'sizeLocal': fileModel.sizeLocal,
//         'url': fileModel.url,
//         'txtMassege': txtMassege,
//         'pathfile': fileModel.pathfile,
//         'downurl': fileModel.downurl,
//         'imageFile': fileModel.imageFile,
//         'fileQuality': fileModel.fileQuality,
//         'type': fileModel.type,
//       };
//       await _api.addData(dataMap, 'fileModel');
//     } else {
//       final fileModel = provider.getListItems!.fileItems.firstWhere(
//         (item) => item.fileID == idFile,
//       );
//       fileModel.downurl = urlDown;
//       if (fileModel.downloading == 'complete') {
//         _elementeWidget.toast('هذا الملف موجود من قبل');
//       } else {
//         provider.updateModelInList({
//           'fileID': fileModel.fileID,
//           'downurl': fileModel.downurl,
//           'txtMassege': 'تم تحديث الرابط',
//           'downloading': fileModel.downloading,
//           'pathfile': fileModel.pathfile,
//           'size': fileModel.size.toString(),
//           'sizeLocal': fileModel.sizeLocal,
//           'progress': fileModel.progress.toString(),
//         }, 'updateWithOutNoti');
//         _elementeWidget.toast('تم تجديد رابط الملف');
//       }
//     }
//   }
// }
