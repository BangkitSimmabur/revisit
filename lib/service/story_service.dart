import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:revisit/constant.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/models/story.dart';
import 'package:revisit/platform/platform_main.dart';
import 'package:revisit/service/constant_service.dart';
import 'package:revisit/service/handling_server_log.dart';
import 'package:revisit/service/network_service.dart';

class StoryService extends NetworkService {
  StoryService(ConstantService constantService) : super(constantService);

  var storyList = <Story>[];
  Story currentStory;
  StoryV2 currentStoryV2;
  String currentKeyWord;
  var storyExplore = <Story>[];
  var storySearchResult = <Story>[];
  var myStory = <Story>[];

  Future<HandlingServerLog> createStory({
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
      HandlingServerLog serverLog = await doHttpPost('story/', reqBody);

      print('serverLog:');
      print(serverLog);
      if (!serverLog.success) {
        return serverLog;
      }

      currentStory = storyFromJson(serverLog.data);

      // var storyCreated = serverLog?.data;
      if (photo != null) {
        print('test foto');
        var handlingLog = await doHttpPutUpload(
            'story/upload/banner/${currentStory.id}', photo);
        print('ini log');
        print(handlingLog);

        if (!handlingLog.success) {
          handlingLog = await doHttpDelete('story/delete/${currentStory.id}');

          currentStory = null;
          return new HandlingServerLog.failed(false, "failed");
        }
      }
      currentStory = null;

      return serverLog;
    } else if (action == ItemAction.update && currentStory.id != null) {
      if (!serverLog.success) {
        return serverLog;
      }
    }

    return serverLog;
  }

  Future<HandlingServerLog> getAllStory(int page, bool isNew) async {
    print('gettingStory');
    if (isNew) {
      storyExplore = [];
    }
    var serverLog = await doHttpGet("story?to='all'&limit=10&page=$page");
    if (!serverLog.success || serverLog.data == null) {
      storyExplore = <Story>[];
      return serverLog;
    }

    var stories = storiesFromJson(serverLog.data["docs"]);

    if (isNew) {
      storyExplore = stories;
    }

    if (!isNew) {
      storyExplore = [...storyExplore, ...stories];
    }

    print(storyExplore);
    return serverLog;
  }

  Future<HandlingServerLog> getStoryById(String id) async {
    print('gettingStory');
    currentStoryV2 = null;

    var serverLog = await doHttpGet("story/id/$id");
    if (!serverLog.success || serverLog.data == null) {
      return serverLog;
    }
    print('datanya');
    print(serverLog.data);

    currentStoryV2 = storyV2FromJson(serverLog.data);

    return serverLog;
  }

  Future<HandlingServerLog> likeStory(String id) async {
    var serverLog = await doHttpPut("story/like/$id", null);

    return serverLog;
  }

  Future<HandlingServerLog> createComment(String id, String comment) async {
    Map reqBody = {
      "comment": comment,
    };
    var serverLog = await doHttpPost("comment/create/$id?to=Story", reqBody);

    return serverLog;
  }

  Future<HandlingServerLog> reportStory(
      String id, String title, String text) async {
    Map reqBody = {
      "title": title,
      "text": text,
    };
    var serverLog = await doHttpPost("report/$id?content=Story", reqBody);

    return serverLog;
  }

  Future<HandlingServerLog> getMyStory(int page, bool isNew) async {
    print('gettingStory');
    if (isNew) {
      myStory = [];
    }
    var serverLog = await doHttpGet("story/my?limit=10&page=$page");
    if (!serverLog.success || serverLog.data == null) {
      myStory = <Story>[];
      return serverLog;
    }
    print('datanya');
    print(serverLog.data["docs"]);

    var stories = storiesFromJson(serverLog.data["docs"]);

    if (isNew) {
      myStory = stories;
    }

    if (!isNew) {
      myStory = [...myStory, ...stories];
    }

    print(myStory);
    return serverLog;
  }

  Future<HandlingServerLog> updateStory({
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
    HandlingServerLog serverLog = await doHttpPut('story/update/$id', reqBody);

    print(serverLog);
    if (!serverLog.success) {
      return serverLog;
    }

    currentStory = storyFromJson(serverLog.data);

    if (photo != null) {
      print('test foto');
      await doHttpPutUpload('story/upload/banner/$id', photo);
    }

    if (serverLog.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.backTransitionPage(context);
      currentStory = null;
    }
    if (!serverLog.success) {
      MainPlatform.backTransitionPage(context);
      MainPlatform.showErrorSnackbar(context, 'Gagal menyunting cerita');
    }
    return serverLog;
  }

  Future<HandlingServerLog> deleteStory(String id) async {
    currentStoryV2 = null;

    var serverLog = await doHttpDelete('story/delete/$id');

    return serverLog;
  }

  Future<HandlingServerLog> getSearchStory({int page, bool isNew, String keyWord}) async {
    print('gettingStory');
    if (isNew) {
      storySearchResult = [];
    }
    var serverLog = await doHttpGet(
        // "story?to='all'&limit=10&page=$page"
      "search/$keyWord?limit=10&page=$page&to=Story"
    );
    if (!serverLog.success || serverLog.data == null) {
      storySearchResult = <Story>[];
      return serverLog;
    }

    var stories = storiesFromJson(serverLog.data["docs"]);

    if (isNew) {
      storySearchResult = stories;
    }

    if (!isNew) {
      storySearchResult = [...storySearchResult, ...stories];
    }

    print(storySearchResult);
    return serverLog;
  }
}
