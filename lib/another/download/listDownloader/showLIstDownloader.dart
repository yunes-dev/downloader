import 'dart:io';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/searchDirctly/searchDirctly.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../../classes/models/fileModel.dart';
import '../../classes/models/menuListOption.dart';
import '../../webviewSearch/webViewSearch.dart';
import '../providerDownload.dart';
import 'compneontsListDownloader.dart';

// ignore: must_be_immutable
class ShowListDownloader extends StatelessWidget {
  FileModel fileModel;
  ProviderDownload provid;
  ShowListDownloader(
      {super.key, required this.fileModel, required this.provid});
  String indexName = '1';
  List<MenuListOption> menuListOption = [
    MenuListOption(id: '1', name: "المشاركة", iconData: Icons.share_sharp),
    MenuListOption(id: '2', name: 'الحذف', iconData: Icons.delete),
    MenuListOption(
        id: '3', name: 'انتقال الى صفحة', iconData: Icons.find_in_page_rounded),
    MenuListOption(id: '4', name: 'تجديد الرابط', iconData: Icons.link_sharp),
    MenuListOption(id: '5', name: 'اعادة التسمية', iconData: Icons.edit_note),
    MenuListOption(id: '6', name: 'تفاصيل', iconData: Icons.info),
  ];
  @override
  Widget build(BuildContext context) {
    String splitLocalSize =
        Components().splitSizeFile(fileModel.sizeLocal.toString());
    String orginalSize = Components().splitSizeFile(fileModel.size.toString());

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onSelectItem(context, provid, fileModel);
          },
          onLongPress: () {
            onLongParess(provid, fileModel);
          },
          child: Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: provid.elementeWidget.lightColor),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Card(
                color: provid.selected.contains(fileModel.fileID)
                    ? Colors.blue.withOpacity(0.5)
                    : Color.fromARGB(255, 227, 230, 230),
                child: Row(
                  children: [
                    Container(
                        width: 105,
                        height: 75,
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        alignment: Alignment.center,
                        child: ClipRRect(
                            //  borderRadius: BorderRadius.circular(10),

                            child: provid.elementeWidget
                                .imageCatch(fileModel.imageFile))),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        // color: Colors.amber,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    fileModel.fileTitle.length > 45
                                        ? fileModel.fileTitle.substring(0, 45) +
                                            '....'
                                        : fileModel.fileTitle,
                                    softWrap:
                                        true, // Allow text to wrap to the next line
                                    maxLines:
                                        2, // Specify the maximum number of lines
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13, fontFamily: 'Cairo'),
                                  ),
                                ),

                                //dropdown

                                CompneontsListDownloader().dropPubButton(
                                    context,
                                    fileModel.downloading,
                                    menuListOption, (id) async {
                                  if (id == '1') {
                                    provid.elementeWidget
                                        .shareFiles(fileModel.pathfile);
                                  } else if (id == '2') {
                                    await provid.cancel(fileModel);
                                    await provid.deleteData(fileModel.fileID,
                                        'fileModel', 'fileID', 'listfiles');
                                  } else if (id == '3') {
                                    //  print('************************************');
                                    provid.elementeWidget.pushed(
                                        WebViewSearch(
                                            url: fileModel.url, idTabs: ''),
                                        context);
                                  } else if (id == '4') {
                                    provid.elementeWidget.pushed(
                                        SearchDirctly(
                                            url: fileModel.url, typeWork: ''),
                                        context);
                                  } else if (id == '5') {
                                    CompneontsListDownloader()
                                        .dialogBuildRenameFile(
                                            context, fileModel);
                                  } else {
                                    showBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          CompneontsListDownloader()
                                              .buildBottom(context, fileModel),
                                    );
                                  }
                                }),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 3,
                            // ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        fileModel.downloading == 'complete' &&
                                                fileModel.progress == 100.0
                                            ? Container()
                                            : Text(
                                                "$splitLocalSize MiB /  $orginalSize MiB",
                                                textAlign: TextAlign.left,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        fileModel.downloading == 'complete'
                                            ? Text(
                                                fileModel.filePublishDate,
                                                style: TextStyle(fontSize: 10),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: fileModel.downloading ==
                                                'complete' &&
                                            fileModel.progress == 1.0
                                        ? null
                                        : LinearProgressIndicator(
                                            value: fileModel.progress,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 201, 193, 193),
                                            valueColor: fileModel.downloading ==
                                                        'paused' ||
                                                    fileModel.downloading ==
                                                        'failed'
                                                ? const AlwaysStoppedAnimation<
                                                        Color>(
                                                    Color.fromARGB(
                                                        255, 157, 150, 150))
                                                : const AlwaysStoppedAnimation<
                                                        Color>(
                                                    Color.fromARGB(
                                                        255, 195, 7, 7)),
                                          ),
                                  ),
                                  Row(
                                    children: [
                                      fileModel.downloading == 'complete'
                                          ? Container()
                                          : fileModel.downloading == 'paused'
                                              ? Icon(
                                                  Icons.pause,
                                                  color: Color.fromARGB(
                                                      255, 157, 150, 150),
                                                  size: 15,
                                                )
                                              : fileModel.downloading ==
                                                      'running'
                                                  ? Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.red,
                                                      size: 15,
                                                    )
                                                  : fileModel.downloading ==
                                                          'enqueued'
                                                      ? Icon(
                                                          Icons.pause,
                                                          color: Color.fromARGB(
                                                              255,
                                                              157,
                                                              150,
                                                              150),
                                                          size: 15,
                                                        )
                                                      : fileModel.downloading ==
                                                              'notStrat'
                                                          ? Icon(
                                                              Icons.pause,
                                                              color: Colors.red,
                                                              size: 15,
                                                            )
                                                          : Icon(
                                                              Icons.restart_alt,
                                                              color: Colors.red,
                                                              size: 15,
                                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        fileModel.txtMassege,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Cairo',
                                            color: fileModel.downloading ==
                                                        'paused' ||
                                                    fileModel.downloading ==
                                                        'failed'
                                                ? Color.fromARGB(
                                                    255, 157, 150, 150)
                                                : fileModel.downloading ==
                                                        'running'
                                                    ? Colors.blue
                                                    : fileModel.downloading ==
                                                            'complete'
                                                        ? Colors.black
                                                        : Colors.red),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onSelectItem(BuildContext context, ProviderDownload provid,
      FileModel fileModel) async {
    print(provid.selected.length);
    if (provid.selected.isNotEmpty) {
      if (provid.selected.contains(fileModel.fileID)) {
        provid.deleteSelect(fileModel.fileID);
      } else {
        provid.addSelect(fileModel.fileID);
      }
    } else {
      await provid.initializeLocalStorageRoute();

      if (fileModel.downloading == 'enqueued' ||
          fileModel.downloading == 'running') {
        cancelDownload(provid, fileModel);
      } else if (fileModel.downloading == 'complete') {
        print('open files');
        File filePath = File(fileModel.pathfile);
        if (fileModel.fileTitle.split('.').last != "apk") {
          try {
            if (filePath.existsSync()) {
              OpenFilex.open(fileModel.pathfile);
            } else {
              startDownload(context, fileModel);
            }
          } catch (e) {
            startDownload(context, fileModel);
          }
        } else {
          var snackBar = SnackBar(
              content: Text(
                  'لا يمكنك فتح هذا النوع من الملفات قم بالدخول الى التخزين الداخلي للجهاز'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        startDownload(context, fileModel);
      }
    }
  }

  void onLongParess(ProviderDownload provid, FileModel fileModel) {
    if (provid.selected.isEmpty) {
      provid.addSelect(fileModel.fileID);
    }
  }

  Future<void> startDownload(BuildContext context, FileModel fileModel) async {
    final provid = Provider.of<ProviderDownload>(context, listen: false);

    if (provid.checkCounteDownload!.countDownload.length < 3) {
      provid.checkCounteDownload!.countDownload.add(fileModel.fileID);
      provid.updateModelInList({
        'fileID': fileModel.fileID,
        'txtMassege': 'جاري التوصيل',
        'downloading': 'running',
        'downurl': fileModel.downurl,
        'size': fileModel.size,
        'sizeLocal': fileModel.sizeLocal,
        'progress': fileModel.progress.toString(),
        'pathfile': fileModel.pathfile,
      }, 'update');
      if (fileModel.url.contains("m.youtube") ||
          fileModel.url.contains("youtube.com") ||
          fileModel.url.contains("youtu.be")) {
        provid.download(fileModel);
      } else if (fileModel.url.contains('instagram.com') ||
          fileModel.url.contains('fb.watch') ||
          fileModel.url.contains('facebook.com')) {
        print(fileModel.pathfile);
        provid.downloadFromFaceInsta(fileModel);
      } else if (fileModel.url.contains('vt.tiktok.com') ||
          fileModel.url.contains('tiktok.com')) {
        provid.downloadFromTiktok(fileModel);
      } else {
        print(fileModel.progress);
        provid.downloadDirectLinks(fileModel);
      }
    } else {
      provid.updateModelInList({
        'fileID': fileModel.fileID,
        'txtMassege': ' قيد الأنتظار',
        'downloading': 'enqueued',
        'downurl': fileModel.downurl,
        'size': fileModel.size,
        'sizeLocal': fileModel.sizeLocal,
        'progress': fileModel.progress.toString(),
        'pathfile': fileModel.pathfile,
      }, 'update');
    }
  }

//776802
  Future<void> cancelDownload(
      ProviderDownload provid, FileModel fileModel) async {
    provid.cancel(
      fileModel,
    );
  }
}
