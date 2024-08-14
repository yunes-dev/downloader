// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ListViewOfFiles extends StatelessWidget {
//   const ListViewOfFiles({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TaskData>(builder: );
//   }
// }
// class TaskData extends ChangeNotifier{
  
//   Future<List<FileSystemEntity>> loadFiles(Directory documentsDirectory) async {
//     //  var targetPath=
//     //var tarhetPath = await getApplicationDocumentsDirectory();
//     //var documentsDirectory = Directory('${tarhetPath.path}/$nextFolder');
//     List<FileSystemEntity> allFiles = documentsDirectory.listSync();
//     List contenes = documentsDirectory.listSync();
//     contenes.forEach((element) {
//       print(element);
//     });
// return allFiles;
//   }
//   void DeleteTask(Task task){

//   }
// }