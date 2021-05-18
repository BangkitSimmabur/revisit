import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revisit/service/constant_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'dart:convert';

class NetworkService with ChangeNotifier {
  ConstantService constantService;

  NetworkService(this.constantService);

  Future<HandlingServerLog> doHttpGet(url) async {
    String reqUrl = "https://revisit-backend.herokuapp.com/api/$url";

    var header;

    if (constantService.token != null) {
      header = {
        'Content-Type': 'application/json',
        'Bearer' : "${constantService.token}"
      };
    } else {
      header = {
        'Content-Type': 'application/json',
      };
    }

    http.Response response = await http.get(reqUrl, headers: header);

    var resBody = json.decode(response.body);

    // if (resBody['check'] == true) {
    //   return HandlingServerLog.success(resBody['check'], resBody['results']);
    // } else {
    //   return HandlingServerLog.failed(resBody['check'], resBody['caption']);
    // }
    return new HandlingServerLog(resBody['check'], resBody['results'], resBody['caption']);
  }

  Future<HandlingServerLog> doHttpPost(
    String url,
    reqBody,
  ) async {
    String reqUrl = "https://revisit-backend.herokuapp.com/api/$url";

    var requestBody = json.encode(reqBody);

    var header;

    print(url);
    if (constantService.token != null) {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Bearer' : "${constantService.token}"
      };
    } else {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    }

    http.Response response =
        await http.post(reqUrl, body: requestBody, headers: header);

    var resBody = json.decode(response.body);

    // if (resBody['check'] == true) {
    //   return HandlingServerLog.success(resBody['check'], resBody['results']);
    // } else {
    //   return HandlingServerLog.failed(resBody['check'], resBody['caption']);
    // }
    return new HandlingServerLog(resBody['check'], resBody['results'], resBody['caption']);
  }

  Future<HandlingServerLog> doHttpPut(
    String url,
    reqBody,
  ) async {
    String reqUrl = "https://revisit-backend.herokuapp.com/api/$url";

    var requestBody;
    if (reqBody == null) {
      requestBody = null;
    }
    if (reqBody != null) {
      requestBody = json.encode(reqBody);
    }

    var header;

    if (constantService.token != null) {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Bearer' : "${constantService.token}"
      };
    } else {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    }

    http.Response response =
        await http.put(reqUrl, body: requestBody, headers: header);

    print(response);
    print(response.body);
    var resBody = json.decode(response.body);

    // if (resBody['check'] == true) {
    //   return HandlingServerLog.success(resBody['check'], resBody['results']);
    // } else {
    //   return HandlingServerLog.failed(resBody['check'], resBody['caption']);
    // }
    return new HandlingServerLog(resBody['check'], resBody['results'], resBody['caption']);
  }

  Future<HandlingServerLog> doHttpDelete(url) async {
    String reqUrl = "https://revisit-backend.herokuapp.com/api/$url";

    var header;

    if (constantService.token != null) {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Bearer' : "${constantService.token}"
      };
    } else {
      header = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    }

    http.Response response = await http.delete(reqUrl, headers: header);

    var resBody = json.decode(response.body);

    // if (resBody['check'] == true) {
    //   return HandlingServerLog.success(resBody['check'], resBody['results']);
    // } else {
    //   return HandlingServerLog.failed(resBody['check'], resBody['caption']);
    // }
    return new HandlingServerLog(resBody['check'], resBody['results'], resBody['caption']);
  }

  Future<HandlingServerLog> doHttpPutUpload(url,File file) async {
    String reqUrl = "https://revisit-backend.herokuapp.com/api/$url";

    var header;

    if (constantService.token != null) {
      header = {
        "Content-type": "multipart/form-data",
        "Accept": "application/json",
        'Bearer' : "${constantService.token}"
      };
    } else {
      header = {
        "Content-type": "multipart/form-data",
        "Accept": "application/json",
      };
    }

    var request = http.MultipartRequest(
      'PUT', Uri.parse(reqUrl),

    );
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    request.headers.addAll(header);

    var response = await request.send();
    var res = await http.Response.fromStream(response);
    var resBody = json.decode(res.body);

    // if (resBody['check'] == true) {
    //   return HandlingServerLog.success(resBody['check'], resBody['results']);
    // } else {
    //   return HandlingServerLog.failed(resBody['check'], resBody['caption']);
    // }
    return new HandlingServerLog(resBody['check'], resBody['results'], resBody['caption']);
  }
}
