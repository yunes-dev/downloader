import 'dart:convert';

import 'package:http/http.dart' as http;

const server = ("https://meta-code-ye.com/apps/number_chatgpt");

class APIHosting {
  Future<List> getDataFRomHostByGet(String url) async {
    List data = [];
    try {
      var response = await http.get(Uri.parse(url));
      data = json.decode(response.body);
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<List> getDataFRomHostByPost(String url, Object body) async {
    List data = [];
    try {
      var response = await http.post(Uri.parse(url), body: body);
      data = json.decode(response.body);
      return data;
    } catch (e) {
      return [];
    }
  }
}
