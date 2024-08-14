import 'DataBaseHelper.dart';

class DataAPI {
  Future<String> getCon() async {
    var con = await DataBaseHelper.getdb();
    if (con!.isOpen) {
      await DataBaseHelper.OpenDb();
      print("is open");
      return "is Open";
    } else {
      print("is close");
      return "is close";
    }
  }

  Future<int> addData(Map<String, dynamic> dataMap, String table) async {
    try {
      var db = await DataBaseHelper.getdb();
      // print(dataMap.values);
      int result = await db!.insert(table, dataMap);
      return result;
    } catch (e) {
      // print(e);
      return 0;
    }
  }

  //Object body = {'id': '1', 'name': 'ali'};

  Future<int> UpdateData(
      Map<String, dynamic> dataMap, String table, String NameID) async {
    try {
      var db = await DataBaseHelper.getdb();
      // print(dataMap.values);
      int result = await db!.update(table, dataMap,
          where: "$NameID=?", whereArgs: [dataMap[NameID]]);
      return result;
    } catch (e) {
      //print(e);
      return 0;
    }
  }

  Future<List> GetAllData(String select) async {
    var db = await DataBaseHelper.getdb();
    String SelectAllDatatatment = select;
    List<Map> result = await db!.rawQuery(SelectAllDatatatment);
    return result.toList();
  }

  Future<int> DeleteData(String table, String NameID, String id) async {
    var db = await DataBaseHelper.getdb();
    int re = await db!.delete(table, where: "$NameID=?", whereArgs: [id]);
    print(re);
    print('////////////');
    return re;
  }

  Future<int> DeleteAllData(String table) async {
    var db = await DataBaseHelper.getdb();
    int re = await db!.delete(table);
    print(re);
    print('////////////');
    return re;
  }
}
