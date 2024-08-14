import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newpipeextractor_dart/models/infoItems/video.dart';
import '../classes/components/components.dart';
import '../classes/databaseAndAPI/dataApi.dart';
import '../classes/models/fileModel.dart';
import 'providerDownload.dart';

class PlayListYoutube {
  DateTime dateTime = DateTime.now();
  void buildBottomPlayList(
    BuildContext context,
    ProviderDownload provider,
    List itemVideos,
    List<StreamInfoItem> playList,
  ) async {
    Components _elementeWidget = Components();
    DataAPI _api = DataAPI();
    List<FileModel> newVideos = [];
    playList.forEach((element) {
      String nameVideo = element.name!.contains('/')
          ? element.name!.split('/').first.toString() +
              element.name!.split('/').last.toString()
          : element.name.toString();
      newVideos.add(FileModel(
          id_file: '',
          fileTitle: nameVideo + ".mp4",
          filePublishDate: '${dateTime.year}-${dateTime.month}-${dateTime.day}',
          fileID: element.id.toString(),
          downloading: '',
          progress: 0,
          typDown: 'tool',
          url: element.url.toString(),
          downurl: '',
          pathfile: '',
          fileQuality: '',
          size: 0,
          sizeLocal: 0,
          type: 'video',
          imageFile:
              "https://i.ytimg.com/vi/${element.id.toString()}/hqdefault.jpg",
          txtMassege: 'جاري التوصيل...'));
    });
    List<String> _selectVideos = [];
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
                    title: Text('قائمة الفيديوهات'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () async {
                              print(_selectVideos);
                              print(
                                  '/////////////////////////////////////////////////////////////////');
                              for (var i = 0; i < newVideos.length; i++) {
                                if (_selectVideos
                                    .contains(newVideos[i].fileID)) {
                                  String video = itemVideos
                                      .where((item) =>
                                          item['fileID'] == newVideos[i].fileID)
                                      .map((e) => e['fileID'])
                                      .firstWhere((element) => true,
                                          orElse: () => '')
                                      .toString();
                                  if (video.isEmpty) {
                                    //add to list

                                    //check count
                                    if (provider.checkCounteDownload!
                                            .countDownload.length >
                                        3) {
                                      newVideos[i].txtMassege = ' قيد الأنتظار';
                                      newVideos[i].downloading = 'enqueued';
                                      provider.getListItems?.fileItems
                                          .add(newVideos[i]);
                                      provider.updateItems(GetListItems(
                                          fileItems: provider
                                              .getListItems!.fileItems));
                                      await _api.addData({
                                        'fileTitle': newVideos[i].fileTitle,
                                        'filePublishDate':
                                            newVideos[i].filePublishDate,
                                        'fileID': newVideos[i].fileID,
                                        'downloading': 'enqueued',
                                        'progress': '0',
                                        'size': newVideos[i].size,
                                        'sizeLocal': newVideos[i].sizeLocal,
                                        'url': newVideos[i].url,
                                        'typDown': newVideos[i].typDown,
                                        'txtMassege': ' قيد الأنتظار',
                                        'pathfile': newVideos[i].pathfile,
                                        'downurl': newVideos[i].downurl,
                                        'imageFile': newVideos[i].imageFile,
                                        'fileQuality': '',
                                        'type': 'videos'
                                      }, 'fileModel');
                                    } else {
                                      newVideos[i].downloading = 'notStrat';
                                      provider.getListItems?.fileItems
                                          .add(newVideos[i]);
                                      provider.updateItems(GetListItems(
                                          fileItems: provider
                                              .getListItems!.fileItems));
                                      provider
                                          .checkCounteDownload!.countDownload
                                          .add(newVideos[i].fileID);

                                      provider.updateCountDwonload(
                                          CheckCounteDownload(
                                              countDownload: provider
                                                  .checkCounteDownload!
                                                  .countDownload));

                                      provider.download(newVideos[i]);

                                      await _api.addData({
                                        'fileTitle': newVideos[i].fileTitle,
                                        'filePublishDate':
                                            newVideos[i].filePublishDate,
                                        'fileID': newVideos[i].fileID,
                                        'downloading': 'notStrat',
                                        'progress': '0',
                                        'size': newVideos[i].size,
                                        'sizeLocal': newVideos[i].sizeLocal,
                                        'url': newVideos[i].url,
                                        'typDown': newVideos[i].typDown,
                                        'txtMassege': newVideos[i].txtMassege,
                                        'pathfile': newVideos[i].pathfile,
                                        'imageFile': newVideos[i].imageFile,
                                        'fileQuality': '',
                                        'type': 'videos'
                                      }, 'fileModel');
                                    }
                                  } else {
                                    _elementeWidget
                                        .toast('هذا الملف موجود من قبل');
                                  }
                                }
                              }
                              setState;
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.download,
                              color: _elementeWidget.lightColor,
                              size: 30,
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        Checkbox(
                          value: _selectVideos.length == newVideos.length
                              ? true
                              : false,
                          onChanged: (value) {
                            if (_selectVideos.isEmpty) {
                              newVideos.forEach((element) {
                                setState(() {
                                  _selectVideos.add(element.fileID);
                                });
                              });
                            } else {
                              setState(() {
                                _selectVideos.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: newVideos.length,
                        itemBuilder: (context, index) {
                          final videoModel = newVideos[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                  videoModel.fileTitle.toString().length > 20
                                      ? videoModel.fileTitle
                                          .toString()
                                          .substring(0, 20)
                                      : videoModel.fileTitle.toString()),
                              leading: Container(
                                  width: 60,
                                  height: 55,
                                  padding: EdgeInsets.symmetric(vertical: 0.0),
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://i.ytimg.com/vi/${videoModel.fileID}/hqdefault.jpg',
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(), // عنصر بديل أثناء تحميل الصورة
                                      errorWidget: (context, url, error) =>
                                          Image.network(
                                              'https://play-lh.googleusercontent.com/vA4tG0v4aasE7oIvRIvTkOYTwom07DfqHdUPr6k7jmrDwy_qA_SonqZkw6KX0OXKAdk'), // صورة بديلة في حالة حدوث خطأ
                                    ),
                                  )),
                              trailing: Checkbox(
                                value: _selectVideos.contains(videoModel.fileID)
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  if (_selectVideos
                                      .contains(videoModel.fileID)) {
                                    setState(() {
                                      _selectVideos.remove(videoModel.fileID);
                                    });
                                  } else {
                                    setState(() {
                                      _selectVideos.add(videoModel.fileID);
                                    });
                                  }
                                },
                              ),
                              onTap: () async {},
                            ),
                          );
                        }),
                  ),
                ]));
          });
        });
  }
}
