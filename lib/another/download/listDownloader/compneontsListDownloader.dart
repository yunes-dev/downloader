import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/models/fileModel.dart';
import '../../classes/models/menuListOption.dart';
import '../providerDownload.dart';

class CompneontsListDownloader {
  Components elementWidget = Components();
  Widget dropPubButton(BuildContext context, String StateDown,
      List<MenuListOption> menuListOption, Function(String id) onPress) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        onPress(value);
      },
      constraints: const BoxConstraints.tightForFinite(),
      itemBuilder: (context) {
        final menuItems = <PopupMenuEntry<String>>[];
        final filteredOptions = List.from(menuListOption);
        if (StateDown != 'complete') {
          filteredOptions.removeWhere((element) => element.id == '1');
          filteredOptions.removeWhere((element) => element.id == '5');
        } else {
          filteredOptions.removeWhere((element) => element.id == '4');
        }
        for (var e in filteredOptions) {
          menuItems.add(
            PopupMenuItem<String>(
              value: e.id,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    child: Icon(e.iconData),
                  ),
                  Text(e.name),
                ],
              ),
            ),
          );
        }
        return menuItems;
      },
    );
  }

  Future<void> dialogBuildRenameFile(
      BuildContext context, FileModel fileModel) async {
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    TextEditingController name = TextEditingController();
    name.text = fileModel.fileTitle;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextField(
                        controller: name,
                        maxLines: 4,
                        minLines: 1,
                        onSubmitted: (value) async {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Center(
                child: Container(
                    child: ElevatedButton(
                        onPressed: () async {
                          fileModel.fileTitle = name.text;
                          String getFilename =
                              fileModel.pathfile.split('/').last;
                          String getTargetPath =
                              fileModel.pathfile.split('$getFilename').first;
                          //   print(fileModel.pathfile);

                          File getNewfile = File(fileModel.pathfile);
                          if (await getNewfile.exists()) {
                            await getNewfile.rename(getTargetPath + name.text);
                            print(getNewfile.path);
                            fileModel.pathfile = getTargetPath + name.text;
                            print('File renamed successfully.');
                          } else {
                            print('File rename failed.');
                          }

                          Map<String, dynamic> dataMap = {
                            'fileID': fileModel.fileID,
                            'downurl': fileModel.downurl,
                            'downloading': fileModel.downloading,
                            'txtMassege': fileModel.txtMassege,
                            'size': fileModel.size,
                            'pathfile': fileModel.pathfile,
                            'sizeLocal': fileModel.sizeLocal,
                            'progress': fileModel.progress,
                          };
                          provider.updateModelInList(dataMap, 'rename');

                          Navigator.of(context).pop();
                        },
                        child: Text("اعادة التسمية"))),
              )
            ],
          );
        });
  }

  Container buildBottom(BuildContext context, FileModel fileModel) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border: Border.all(color: elementWidget.lightColor, width: 2.0)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(children: [
            Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                          //    width: 70,
                          height: 100,
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: fileModel.imageFile,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(), // عنصر بديل أثناء تحميل الصورة
                              errorWidget: (context, url, error) => Image.network(
                                  'https://play-lh.googleusercontent.com/vA4tG0v4aasE7oIvRIvTkOYTwom07DfqHdUPr6k7jmrDwy_qA_SonqZkw6KX0OXKAdk'), // صورة بديلة في حالة حدوث خطأ
                            ),
                          )),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          // color: Colors.amber,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(fileModel.fileTitle),
                                  ),

                                  //dropdown
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                    height: 20, color: elementWidget.lightColor, thickness: 2),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        //  padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text('مسار الملف'),
                            // Text(':'),

                            Text(
                              fileModel.pathfile
                                  .split(fileModel.fileTitle)
                                  .first,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Text('حالة التحميل'),
                            // Text(':'),
                            SizedBox(
                              width: 15,
                            ),
                            Text(fileModel.txtMassege),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text('حجم التحميل'),
                            // Text(':'),
                            SizedBox(
                              width: 15,
                            ),
                            Text(elementWidget
                                    .splitSizeFile(fileModel.size.toString()) +
                                'MB'),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text('التاريخ'),
                            // Text(':'),
                            SizedBox(
                              width: 15,
                            ),
                            Text(fileModel.filePublishDate),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
