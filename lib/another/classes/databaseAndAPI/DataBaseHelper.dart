import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: unused_import
import 'package:path/path.dart';
import 'dart:io';

class DataBaseHelper {
  static Database? _db;
  static Future<Database?> getdb() async {
    if (_db != null) {
      return _db;
    } else {
      _db = await OpenDb();
      return _db;
    }
  }

  static Future<Database> OpenDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    var weterMachineDb;
    // List<StorageInfo> storng = await PathProviderEx.getStorageInfo();
    Directory targetPath = Directory("${dir.path}/DataBase");
    if (!await targetPath.exists()) {
      targetPath.create();
      String path = join(targetPath.path, 'downliad_files.db');
      weterMachineDb =
          await openDatabase(path, version: 1, onCreate: _FirstCreate);
    } else {
      String path = join(targetPath.path, 'downliad_files.db');
      weterMachineDb =
          await openDatabase(path, version: 1, onCreate: _FirstCreate);
      print(targetPath.path);
    }

    return weterMachineDb;
  }

  static void Restart() async {
    Directory dir = await getApplicationDocumentsDirectory();
    //List<StorageInfo> storng = await PathProviderEx.getStorageInfo();
    Directory targetPath = Directory("${dir.path}/DataBase");
    if (!await targetPath.exists()) {
      targetPath.create();
      String path = join(targetPath.path, 'downliad_files.db');
      File f = new File(path);
      if (!f.existsSync()) {
        deleteDatabase(path);
        print("Database has Deleted");
      }
    } else {
      // Directory targetPath = Directory("${storng[0].appFilesDir}/DataBase");
      String path = join(targetPath.path, 'downliad_files.db');
      File f = new File(path);
      if (!f.existsSync()) {
        deleteDatabase(path);
        print("Database has Deleted");
      }
    }
    print(targetPath.path);
  }

  static void _FirstCreate(Database db, int version) async {
    var createSearchTableStatment = """
CREATE TABLE IF NOT EXISTS "search" ("id_search" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  ,"search_search" VARCHAR(20)  NOT NULL  COLLATE BINARY,"date_search" SMALLINT  NOT NULL  ,"nameUrl" Text);""";
    await db.execute(createSearchTableStatment);
    var createVideosTableStatment = """
CREATE TABLE IF NOT EXISTS "fileModel" ("id_file" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  ,"fileTitle" VARCHAR(200)  NOT NULL  COLLATE BINARY,"filePublishDate" VARCHAR(200)  NOT NULL  COLLATE BINARY,"fileID" VARCHAR(200)  NOT NULL  COLLATE BINARY,"downloading" VARCHAR(10)  NOT NULL  COLLATE BINARY ,"progress" Text,"url" Text,"downurl" Text,"pathfile" Text,fileQuality Text,"txtMassege" Text,"size" INTEGER  NOT NULL,"sizeLocal" INTEGER  NOT NULL,"imageFile" Text,"type" Text,"typDown" Text);""";
    await db.execute(createVideosTableStatment);
    var createTabsPubUpWebTable =
        """CREATE TABLE IF NOT EXISTS "tabWeb" ("id_tab" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"name_tab" VARCHAR(200)  NOT NULL  COLLATE BINARY,"url_tab" Text,"img" BLOB);""";
    await db.execute(createTabsPubUpWebTable);
    var createBubbleTable =
        """CREATE TABLE IF NOT EXISTS "bubble" ("id_tab" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"bub" VARCHAR(200)  NOT NULL  COLLATE BINARY);""";
    await db.execute(createBubbleTable);
  }

  static Future<void> CloseDb() async {
    var db = await getdb();
    db?.close();
    _db = null;
  }
}
