// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/components/components.dart';

// ignore: must_be_immutable
class SettingGeneral extends StatefulWidget {
  String title;
  SettingGeneral({super.key, required this.title});

  @override
  State<SettingGeneral> createState() => _SettingGeneralState();
}

class _SettingGeneralState extends State<SettingGeneral> {
  Components components = Components();
  String? dirPath;
  getPath() async {
    dirPath = await components.getPath('');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: components.gradient,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        )),
      ),
      body: Container(
        padding: const EdgeInsets.all(7),
        child: Column(
          children: [
            Card(
                child: ListTile(
              onTap: () async {
                print(dirPath);
                var rootPath =
                    await ExternalPath.getExternalStoragePublicDirectory("");
                var path = await FilesystemPicker.open(
                  title: 'حدد مسار الحفظ',
                  context: context,
                  rootDirectory: Directory(rootPath),
                  fsType: FilesystemType.folder,
                  pickText: 'تحديد هذا المجلد ',
                  caseSensitiveFileExtensionComparison: true,
                  itemFilter: (fsEntity, path, name) {
                    return true;
                  },
                  showGoUp: true,
                );
                var spliteLastDir = path?.split('/').last;
                if (spliteLastDir != null && spliteLastDir != '0') {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('path', path!);
                  setState(() {
                    dirPath = path;
                  });
                  var snackBar = const SnackBar(
                      content: Text(
                    'يجب عليك نقل الملفات التي لم يكتمل تحميلها الى المجلد الجديد',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  print(path);
                } else {
                  var snackBar = const SnackBar(
                      content: Text(
                    'لا يمكنك تحديد المجلد الرئيسي',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              trailing: Icon(
                Icons.save,
                size: 30,
                color: components.lightColor,
              ),
              title: const Text(
                "تغيير مسار الحفظ",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Air'),
                //   textAlign: TextAlign.center,
              ),
              subtitle: Text(
                dirPath ?? '',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.left,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
