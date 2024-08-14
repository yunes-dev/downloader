import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../classes/components/components.dart';

class FilesDownloadPath extends StatefulWidget {
  const FilesDownloadPath({super.key});

  @override
  State<FilesDownloadPath> createState() => _FilesDownloadPathState();
}

class _FilesDownloadPathState extends State<FilesDownloadPath> {
  String title = 'My Files';
  List<String> _selected = [];
  List<String> pathFolders = [];
  List<FileSystemEntity> filesDown = [];
  Components _elementeWidget = Components();
  @override
  void initState() {
    super.initState();
    requstPermsion();
  }

  Future<void> loadFiles(Directory documentsDirectory) async {
    //  var targetPath=
    //var tarhetPath = await getApplicationDocumentsDirectory();
    //var documentsDirectory = Directory('${tarhetPath.path}/$nextFolder');
    List<FileSystemEntity> allFiles = documentsDirectory.listSync();

    setState(() {
      filesDown = allFiles;
    });

    List contenes = documentsDirectory.listSync();
    contenes.forEach((element) {
      print(element);
    });
  }

  Icon getFileIcon(FileSystemEntity entity) {
    if (_elementeWidget.isFile(entity)) {
      return Icon(
        Icons.insert_drive_file,
      );
    } else {
      return Icon(
        Icons.folder,
        color: Colors.amber,
      );
    }
  }

  void requstPermsion() async {
    var path = await getApplicationDocumentsDirectory();
    var targetPath = Directory('${path.path}');
    _elementeWidget.getPermison().then((value) {
      if (value == 1) {
        setState(() {
          loadFiles(targetPath);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                final targetPath = await _elementeWidget.getPath('videohh');
                _selected.forEach((element) {
                  final file = File(element);
                  file.copy("$targetPath/${file.path.split('/').last}");
                });
              },
              icon: Icon(Icons.copy))
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            print(pathFolders);
            if (pathFolders.isNotEmpty) {
              int index = pathFolders.length - 1;
              var gg = pathFolders[index];
              var tt = pathFolders[index].split(title).first;
              print(pathFolders.length);
              print(gg);
              print(title);
              print(tt);
              loadFiles(Directory(tt));
              pathFolders.remove(gg);
            } else {
              print(pathFolders.length);
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filesDown.length,
              itemBuilder: (context, index) {
                FileSystemEntity entity = filesDown[index];
                String lengthFile = _elementeWidget.isFile(entity)
                    ? File(entity.path.toString()).lengthSync().toString()
                    : '';
                if (_elementeWidget.isFile(entity)) {
                } else {
                  title = entity.path.split('/').last;
                }
                return Column(
                  children: [
                    Card(
                      color: _selected.contains(filesDown[index].path)
                          ? Colors.blue.withOpacity(0.5)
                          : null,
                      child: ListTile(
                          leading: getFileIcon(entity),
                          title: Text(entity.path.split('/').last),
                          onTap: () {
                            if (_selected.isNotEmpty) {
                              if (_selected.contains(filesDown[index].path)) {
                                setState(() {
                                  _selected.remove(filesDown[index].path);
                                });
                                print(_selected);
                              } else {
                                setState(() {
                                  _selected.add(filesDown[index].path);
                                });
                                print(_selected);
                              }
                            }
                          },
                          onLongPress: () {
                            if (_selected.isEmpty) {
                              setState(() {
                                _selected.add(filesDown[index].path);
                              });
                            }
                            print(_selected);
                          },
                          // leading: CircleAvatar(
                          //   child: Text(index.toString()),
                          // ),
                          subtitle: Text(lengthFile),
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            Text('open'),
                            IconButton(
                              icon: Icon(Icons.open_in_new),
                              onPressed: () async {
                                if (_elementeWidget.isFile(entity)) {
                                  print('this is file');
                                  print(entity.path);
                                } else {
                                  //    var getpath = entity.path
                                  //      .split(entity.path.split('/').last);

                                  setState(() {
                                    title = entity.path.split('/').last;
                                  });
                                  pathFolders.add(entity.path.toString());
                                  //print(getpath);
                                  print('name ${entity.path.split('/').last}');
                                  print('this is folofer');
                                  print(entity.path);
                                  loadFiles(Directory(entity.path.toString()));
                                }
                                //   print(itemVideos.length);
                              },
                            ),
                          ])),
                    ),
                    const Divider(
                      color: Colors.black,
                      height: 5,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
