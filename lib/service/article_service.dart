import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/article.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/constant_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/service/network_service.dart';

class ArticleService extends NetworkService {
  ArticleService(ConstantService constantService) : super(constantService);

  var articleExplore = <Article>[];
  var articleSearchResult = <Article>[];
  ArticleV2 currentArticleV2;
  Article currentArticle;
  var myArticle = <Article>[];
  String currentKeyWord;
  Future<HandlingServerLog> getAllArticle(int page, bool isNew) async {
    if (isNew) {
      articleExplore = [];
    }
    var serverLog =
        await doHttpGet("article?to='published'&limit=10&page=$page");
    if (!serverLog.success || serverLog.data == null) {
      articleExplore = <Article>[];
      return serverLog;
    }
    print('datanya');
    print(serverLog.data["docs"]);

    var articles = articlesFromJson(serverLog.data["docs"]);

    if (isNew) {
      articleExplore = articles;
    }

    if (!isNew) {
      articleExplore = [...articleExplore, ...articles];
    }

    print(articleExplore);
    return serverLog;
  }

  Future<HandlingServerLog> createArticle({
    String title,
    String text,
    File photo,
    ItemAction action,
    LocationData locationData,
  }) async {
    print(constantService.token);
    HandlingServerLog serverLog;
    if (action == ItemAction.create) {
      Map reqBody = {
        "title": title,
        "text": text,
        "location": locationData,
      };
      HandlingServerLog serverLog = await doHttpPost('article/', reqBody);

      print('serverLog:');
      print(serverLog);
      if (!serverLog.success) {
        return serverLog;
      }

      currentArticle = articleFromJson(serverLog.data);

      // var articleCreated = serverLog?.data;
      if (photo != null) {
        print('test foto');
        var handlingLog = await doHttpPutUpload(
            'article/upload/banner/${currentArticle.id}', photo);
        print('ini log');
        print(handlingLog);

        if (!handlingLog.success) {
          handlingLog =
              await doHttpDelete('article/delete/${currentArticle.id}');

          currentArticle = null;
          return new HandlingServerLog.failed(false, "failed");
        }
      }
      currentArticle = null;

      return serverLog;
    } else if (action == ItemAction.update && currentArticle.id != null) {
      if (!serverLog.success) {
        return serverLog;
      }
    }

    return serverLog;
  }

  Future<HandlingServerLog> getArticleById(String id) async {
    print('gettingArticle');
    currentArticleV2 = null;

    var serverLog = await doHttpGet("article/id/$id");
    if (!serverLog.success || serverLog.data == null) {
      return serverLog;
    }
    print('datanya');
    print(serverLog.data);

    currentArticleV2 = articleV2FromJson(serverLog.data);

    return serverLog;
  }

  Future<HandlingServerLog> likeArticle(String id) async {
    var serverLog = await doHttpPut("article/like/$id", null);

    return serverLog;
  }

  Future<HandlingServerLog> createComment(String id, String comment) async {
    Map reqBody = {
      "comment": comment,
    };
    var serverLog = await doHttpPost("comment/create/$id?to=Article", reqBody);

    return serverLog;
  }

  Future<HandlingServerLog> reportArticle(
      String id, String title, String text) async {
    Map reqBody = {
      "title": title,
      "text": text,
    };
    var serverLog = await doHttpPost("report/$id?content=Article", reqBody);

    return serverLog;
  }

  Future<HandlingServerLog> getMyArticle(int page, bool isNew) async {
    print('gettingArticle');
    if (isNew) {
      myArticle = [];
    }
    var serverLog = await doHttpGet("article/my?limit=10&page=$page");
    if (!serverLog.success || serverLog.data == null) {
      myArticle = <Article>[];
      return serverLog;
    }
    print('datanya');
    print(serverLog.data["docs"]);

    var articles = articlesFromJson(serverLog.data["docs"]);

    if (isNew) {
      myArticle = articles;
    }

    if (!isNew) {
      myArticle = [...myArticle, ...articles];
    }

    print(myArticle);
    return serverLog;
  }

  Future<HandlingServerLog> updateArticle({
    BuildContext context,
    String id,
    String title,
    String text,
    File photo,
    LocationData locationData,
  }) async {
    print(constantService.token);
    Map reqBody = {
      "title": title,
      "text": text,
      "location": locationData,
    };
    HandlingServerLog serverLog = await doHttpPut('article/update/$id', reqBody);

    print(serverLog);
    if (!serverLog.success) {
      return serverLog;
    }

    currentArticle = articleFromJson(serverLog.data);

    if (photo != null) {
      print('test foto');
      await doHttpPutUpload('article/upload/banner/$id', photo);
    }

    if (serverLog.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.backTransitionPage(context);
      currentArticle = null;
    }
    if (!serverLog.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.showErrorSnackbar(context, 'Gagal menyunting artikel');
    }
    return serverLog;
  }

  Future<HandlingServerLog> deleteArticle(String id) async {
    currentArticleV2 = null;

    var serverLog = await doHttpDelete('article/delete/$id');

    return serverLog;
  }


  Future<HandlingServerLog> getSearchArticle({int page, bool isNew, String keyWord}) async {
    print('gettingarticle');
    if (isNew) {
      articleSearchResult = [];
    }
    var serverLog = await doHttpGet(
      // "article?to='all'&limit=10&page=$page"
        "search/$keyWord?limit=10&page=$page&to=Article"
    );
    if (!serverLog.success || serverLog.data == null) {
      articleSearchResult = <Article>[];
      return serverLog;
    }

    var articles = articlesFromJson(serverLog.data["docs"]);

    if (isNew) {
      articleSearchResult = articles;
    }

    if (!isNew) {
      articleSearchResult = [...articleSearchResult, ...articles];
    }

    print(articleSearchResult);
    return serverLog;
  }
}
