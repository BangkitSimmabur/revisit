import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkService with ChangeNotifier {

  String _token;

  Future<dynamic> doHttpGet(url) async {
    String reqUrl = "https://revisit-backend.herokuapp.com/api/$url";

    Map<String,dynamic> header;

    if (_token != null) {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };
    } else {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    }

    http.Response response = await http.get(reqUrl, headers: header);

    if (response.statusCode == 200) {

      return response;
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> doHttpPost(url, body) async {
    String reqUrl = "https://revisit-backend.herokuapp.com/api/$url";

    Map<String,dynamic> header;

    if (_token != null) {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };
    } else {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    }

    http.Response response = await http.get(reqUrl, headers: header);

    if (response.statusCode == 200) {

      return response;
    } else {
      print(response.statusCode);
    }
  }
}