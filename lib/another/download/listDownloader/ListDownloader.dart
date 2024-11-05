import 'package:download_every_thing/another/download/listDownloader/showLIstDownloader.dart';
import 'package:download_every_thing/another/setting/settingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:overlay_progress_indicator/overlay_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import '../../classes/models/fileModel.dart';
import '../../classes/models/menuListOption.dart';
import '../providerDownload.dart';
import 'compneontsListDownloader.dart';

class ListTitleDownLOader extends StatelessWidget {
  const ListTitleDownLOader({super.key});

  @override
  Widget build(BuildContext context) {
    List<MenuListOption> menuListOption = [
      MenuListOption(
          id: '1', name: "استئناف الكل", iconData: Icons.share_sharp),
      MenuListOption(id: '2', name: 'ايقاف الكل', iconData: Icons.delete),
      MenuListOption(
          id: '3', name: 'تجميع اجزاء الملفات', iconData: Icons.link_sharp),
      // MenuListOption(id: '4', name: 'ايقاف الكل', iconData: Icons.delete),
    ];
    final provider = Provider.of<ProviderDownload>(context, listen: false);
    provider.selected.clear();
    return Consumer<ProviderDownload>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
                //padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
              gradient: provider.elementeWidget.gradient,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            )),
            title: Text('مدير التحميل'),
            actions: [
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () async {
                  showSearch(
                      context: context,
                      delegate: SearchPage(
                          searchStyle: TextStyle(
                            color: Colors.white,
                          ),
                          barTheme: ThemeData(
                            cardColor: Colors.white,
                            inputDecorationTheme: InputDecorationTheme(
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            appBarTheme: AppBarTheme(
                              backgroundColor:
                                  provider.elementeWidget.lightColor,
                            ),
                          ),
                          onQueryUpdate: print,
                          items: provider.getListItems!.fileItems,
                          searchLabel: 'البحث',
                          suggestion: const Center(
                            child: Text('ابحث باستخدام اسم الملف او  الوقت ',
                                textAlign: TextAlign.center),
                          ),
                          failure: const Center(
                            child: Text('هذا الملف غير موجود :('),
                          ),
                          filter: (fileModel) => [
                                fileModel.fileTitle,
                                fileModel.txtMassege,
                                fileModel.type,
                                fileModel.fileQuality,
                                fileModel.filePublishDate,
                                fileModel.fileID,
                              ],
                          sort: (a, b) => a.fileID.compareTo(b.fileID),
                          builder: (fileModel) => ShowListDownloader(
                              fileModel: fileModel, provid: provider)));
                },
              ),
              // IconButton(
              //     onPressed: () {
              //       print(provider.getListItems?.fileItems.length);
              //       provider.selected.forEach((element) async {
              //         FileModel hh = provider.getListItems!.fileItems
              //             .firstWhere((e) => e.fileID == element, orElse: null);
              //         print(hh.fileID);
              //         await provider.cancel(hh);
              //         await provider.deleteData(
              //             element, 'fileModel', 'fileID', 'listfiles');
              //         await provider.deleteSelect(element);
              //       });
              //     },
              //     icon: Icon(Icons.dangerous)),
              IconButton(
                  onPressed: () {
                    // print(provider..length);
                    // print(provider.testSize[4]);
                    //  loadFiles();
                    provider.elementeWidget.pushed(SettingWidget(), context);
                    //  print(provider.checkCounteDownload?.countDownload.length);
                    //  provider.checkCounteDownload?.countDownload.clear();
                    // provider.checkDownloadFilesIsWaite();
                  },
                  icon: Icon(Icons.settings)),
              provider.selected.isEmpty
                  ? CompneontsListDownloader().dropPubButton(
                      context, 'complete', menuListOption, (id) async {
                      if (id == '1') {
                        provider.getListItems?.fileItems
                            .where((element) =>
                                element.downloading == 'paused' ||
                                element.downloading == 'failed')
                            .forEach((element) {
                          if (provider
                                  .checkCounteDownload!.countDownload.length >
                              3) {
                            element.downloading = 'enqueued';
                            element.txtMassege = ' قيد الأنتظار';
                            provider.updateModelInList({
                              'fileID': element.fileID,
                              'downloading': element.downloading,
                              'downurl': element.downurl,
                              'pathfile': element.pathfile,
                              'size': element.size,
                              'sizeLocal': element.sizeLocal,
                              'txtMassege': element.txtMassege,
                              'progress': element.progress,
                            }, 'update');
                          } else {
                            provider.checkCounteDownload!.countDownload
                                .add(element.fileID);
                            provider.updateCountDwonload(CheckCounteDownload(
                                countDownload: provider
                                    .checkCounteDownload!.countDownload));
                            provider.download(element);
                          }
                        });
                      } else if (id == '2') {
                        print('*********************************************');
                        print(provider.getListItems?.fileItems.length);
                        provider.getListItems?.fileItems
                            .where((element) =>
                                element.downloading == 'running' ||
                                element.downloading == 'enqueued')
                            .forEach((element) {
                          var index =
                              provider.getListItems?.fileItems.indexOf(element);
                          //   print(element.downloading);
                          provider.cancelToken[index!];
                          provider.updateModelInList({
                            'fileID': element.fileID,
                            'downloading': 'paused',
                            'downurl': element.downurl,
                            'pathfile': element.pathfile,
                            'size': element.size,
                            'sizeLocal': element.sizeLocal,
                            'txtMassege': 'توقف التحميل',
                            'progress': element.progress,
                          }, 'stop');
                        });
                      } else if (id == '3') {
                        provider.elementeWidget.dialogBuildToExit(context);
                        provider.getListItems?.fileItems.forEach((element) {
                          provider.processData.checkOnLocal(
                              fileUrl: element.downurl,
                              fileLocalRouteStr: element.pathfile,
                              size: element.size,
                              testSize: [element.size],
                              listPrograss: element.progress);
                          if (provider.getListItems?.fileItems.last ==
                              element) {
                            OverlayProgressIndicator.hide();
                          }
                        });
                      }
                    })
                  : ElevatedButton(
                      onPressed: () {
                        provider.selected.clear();
                      },
                      child: Text(
                        'cancel',
                        style: TextStyle(color: Colors.red),
                      ))
            ],
          ),
          body: provider.getListItems!.fileItems.isEmpty ||
                  provider.getListItems!.fileItems.length == 0
              ? const Center(
                  child: Text("لا توجد بيانات بعد"),
                )
              : Container(
                  //  color: provider.elementeWidget.darkColor,
                  child: GroupedListView<FileModel, int>(
                    elements: provider.getListItems!.fileItems,
                    groupBy: (element) {
                      if (element.progress == 1.0 &&
                          element.downloading == 'complete') {
                        return 1;
                      } else {
                        return 0;
                      }
                    },
                    itemComparator: (value1, value2) {
                      if (value1.downloading == 'running' &&
                          value2.downloading == 'running') {
                        return value1.progress.compareTo(value2.progress);
                      } else if (value1.downloading == 'running' &&
                          value2.downloading != 'running') {
                        return -1;
                      } else if (value1.downloading != 'running' &&
                          value2.downloading == 'running') {
                        return 1;
                      } else {
                        return 0;
                      }
                    },
                    groupSeparatorBuilder: (int groupByValue) => Card(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          groupByValue == 1 ? 'تم التنزيل' : 'جاري التنزيل',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    indexedItemBuilder: (context, element, index) {
                      final fileModel = element;
                      return ShowListDownloader(
                          fileModel: fileModel, provid: provider);
                    },
                    groupComparator: (value1, value2) =>
                        value1.compareTo(value2),
                    //reverse: true,
                    //     order: GroupedListOrder.DESC
                  ),
                ),
          bottomNavigationBar: provider.selected.isNotEmpty
              ? BottomNavigationBar(
                  onTap: (value) {
                    if (value == 0) {
                      if (provider.selected.length ==
                          provider.getListItems?.fileItems.length) {
                        cancelSelectItem(provider);
                      } else {
                        selectAllItem(provider);
                      }
                    } else {
                      //print('****************************************');
                      deletSelectItem(provider);
                    }
                  },
                  backgroundColor: Color.fromARGB(255, 33, 30, 30),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.done_all_sharp,
                          color: Colors.white), // Set icon color
                      label: provider.selected.length ==
                              provider.getListItems?.fileItems.length
                          ? 'الغاء التحديد'
                          : 'تحديد الكل',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.delete,
                          color: Colors.white), // Set icon color
                      label: 'حذف',
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  void selectAllItem(ProviderDownload provider) {
    provider.getListItems?.fileItems.forEach((element) async {
      if (!provider.selected.contains(element.fileID)) {
        provider.addSelect(element.fileID);
      }
    });
  }

  void cancelSelectItem(ProviderDownload provider) {
    print(provider.selected.length);
    provider.deleteAllSelect();
  }

  Future<void> deletSelectItem(ProviderDownload provider) async {
    List<String> elementsToDelete =
        List.from(provider.selected); // Create a copy
    for (String element in elementsToDelete) {
      FileModel model = provider.getListItems!.fileItems
          .firstWhere((e) => e.fileID == element, orElse: null);
      if (model.downloading == 'running' || model.downloading == 'queued') {
        print(model.fileID);
        var index = provider.getListItems?.fileItems.indexOf(model);
        provider.cancelToken[index!];
        provider.updateModelInList({
          'fileID': model.fileID,
          'downloading': 'paused',
          'downurl': model.downurl,
          'pathfile': model.pathfile,
          'size': model.size,
          'sizeLocal': model.sizeLocal,
          'txtMassege': 'توقف التحميل',
          'progress': model.progress,
        }, 'stop');
        await provider.deleteSelect(element);
        await provider.deleteData(element, 'fileModel', 'fileID', 'listfiles');
      } else {
        await provider.deleteSelect(element);
        await provider.deleteData(element, 'fileModel', 'fileID', 'listfiles');
      }
    }
  }
}
